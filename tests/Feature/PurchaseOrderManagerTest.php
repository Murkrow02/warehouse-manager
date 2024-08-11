<?php

use App\Managers\PurchaseOrder\PurchaseOrderManager;
use App\Managers\PurchaseOrder\PurchaseItemBuilder;
use App\Managers\Stock\StockManager;
use App\Models\PurchaseOrder;
use App\Models\PurchaseItem;
use App\Models\Stock;
use App\Models\Item;
use App\Models\Attribute;
use App\Models\Supplier;
use App\Models\Warehouse;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;

uses(RefreshDatabase::class);

beforeEach(function () {
    // Arrange common data for the tests
    $this->supplier = Supplier::factory()->create();
    $this->item = Item::factory()->create();
    $this->attributes = Attribute::factory()->count(3)->create();
    $this->warehouse = Warehouse::factory()->create();
    $this->purchaseOrderManager = new PurchaseOrderManager($this->supplier->id);
    $this->stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());
});

it('creates a purchase order and associated items', function () {

    // Arrange
    $this->purchaseOrderManager->newItem($this->item->id)
        ->count(5)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(100)
        ->sendToWarehouse($this->warehouse->id)
        ->add();

    // Act
    $this->purchaseOrderManager->purchase();

    $this->stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());

    // Assert
    $purchaseOrder = PurchaseOrder::first();
    expect($purchaseOrder)->not()->toBeNull()
        ->and(PurchaseItem::where('purchase_order_id', $purchaseOrder->id)->count())->toBe(1)
        ->and(PurchaseItem::first()->quantity)->toBe(5)
        ->and($this->stockManager->getQuantity())->toBe(5);
});


it('increments stock quantity correctly', function () {

    // Arrange
    $this->purchaseOrderManager->newItem($this->item->id)
        ->count(10)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(200)
        ->sendToWarehouse($this->warehouse->id)
        ->add();
    $this->purchaseOrderManager->purchase();

    // Act
    $stockManager = new StockManager(
        $this->item->id,
        $this->warehouse->id,
        $this->attributes->pluck('id')->toArray()
    );

    // Assert
    expect($stockManager->getQuantity())->toBe(10);
});

it('handles stock increment correctly when same item is purchased multiple times', function () {
    // Arrange
    $this->purchaseOrderManager->newItem($this->item->id)
        ->count(5)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(100)
        ->sendToWarehouse($this->warehouse->id)
        ->add();
    $this->purchaseOrderManager->newItem($this->item->id)
        ->count(3)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(50)
        ->sendToWarehouse($this->warehouse->id)
        ->add();
    $this->purchaseOrderManager->purchase();

    // Act
    $stockManager = new StockManager(
        $this->item->id,
        $this->warehouse->id,
        $this->attributes->pluck('id')->toArray()
    );

    // Assert
    expect($stockManager->getQuantity())->toBe(8); // 5 + 3
});

it('throws an exception if no warehouse is set in purchase item builder', function () {
    // Arrange
    $builder = $this->purchaseOrderManager->newItem($this->item->id)
        ->count(10)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(200);

    // Assert
    expect(fn () => $builder->add())->toThrow(Exception::class);
});

it('rolls back transaction on exception', function () {

    // Simulate an exception by inserting a non-existent attribute id
    $wrongAttributeIds = [-1];

    // Arrange
    $this->purchaseOrderManager->newItem($this->item->id)
        ->count(5)
        ->attributeIds($wrongAttributeIds)
        ->price(100)
        ->sendToWarehouse($this->warehouse->id)
        ->add();


    // Act & Assert
    expect(fn() => $this->purchaseOrderManager->purchase())->toThrow(Exception::class)
        ->and(PurchaseOrder::count())->toBe(0)
        ->and(PurchaseItem::count())->toBe(0)
        ->and($this->stockManager->getQuantity())->toBe(0);
});
