<?php

use App\Managers\Sale\SaleManager;
use App\Managers\Stock\StockManager;
use App\Models\Sale;
use App\Models\SaleItem;
use App\Models\Item;
use App\Models\Attribute;
use App\Models\Store;
use App\Models\Warehouse;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

beforeEach(function () {
    $this->item = Item::factory()->create();
    $this->store = Store::factory()->create();
    $this->attributes = Attribute::factory()->count(3)->create();
    $this->warehouse = Warehouse::factory()->create();
    $this->saleManager = new SaleManager($this->store->id, 'John Doe', 'cash');
    $this->stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());


    // Fill with some stocks before each test
    $this->stockManager->increment(10);
});

it('creates a sale and associated items', function () {
    $this->saleManager->newItem($this->item->id)
        ->count(5)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(100)
        ->getFromWarehouse($this->warehouse->id)
        ->add();

    $this->saleManager->process();

    $sale = Sale::first();
    expect($sale)->not()->toBeNull()
        ->and(SaleItem::where('sale_id', $sale->id)->count())->toBe(1)
        ->and(SaleItem::first()->quantity)->toBe(5)
        ->and($this->stockManager->getQuantity())->toBe(5);
});

it('decrements stock quantity correctly', function () {
    $this->saleManager->newItem($this->item->id)
        ->count(10)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(200)
        ->getFromWarehouse($this->warehouse->id)
        ->add();

    $this->saleManager->process();

    expect($this->stockManager->getQuantity())->toBe(0);
});

it('handles stock decrement correctly when same item is sold multiple times', function () {

    $this->saleManager->newItem($this->item->id)
        ->count(5)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(100)
        ->getFromWarehouse($this->warehouse->id)
        ->add();

    $this->saleManager->newItem($this->item->id)
        ->count(3)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(50)
        ->getFromWarehouse($this->warehouse->id)
        ->add();

    $this->saleManager->process();

    expect($this->stockManager->getQuantity())->toBe(2); // 10 - 5 - 3 = 2
});

it('calculates the total price of the sale correctly', function () {
    $this->saleManager->newItem($this->item->id)
        ->count(5)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(100)
        ->getFromWarehouse($this->warehouse->id)
        ->add();

    $this->saleManager->newItem($this->item->id)
        ->count(3)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(50)
        ->getFromWarehouse($this->warehouse->id)
        ->add();

    $this->saleManager->process();
    $totalPrice = $this->saleManager->getItemsTotalPrice();

    expect($totalPrice)->toBe(650.00);
});

it('throws an exception if no warehouse is set in sale item builder', function () {
    $builder = $this->saleManager->newItem($this->item->id)
        ->count(10)
        ->attributeIds($this->attributes->pluck('id')->toArray())
        ->price(200);

    expect(fn () => $builder->add())->toThrow(Exception::class);
});

it('rolls back transaction on exception', function () {
    $wrongAttributeIds = [-1];

    $this->saleManager->newItem($this->item->id)
        ->count(5)
        ->attributeIds($wrongAttributeIds)
        ->price(100)
        ->getFromWarehouse($this->warehouse->id)
        ->add();

    expect(fn() => $this->saleManager->process())->toThrow(Exception::class)
        ->and(Sale::count())->toBe(0)
        ->and(SaleItem::count())->toBe(0)
        ->and($this->stockManager->getQuantity())->toBe(10);
});
