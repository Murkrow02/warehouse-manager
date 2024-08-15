<?php

use App\Managers\Stock\StockManager;
use App\Models\Stock;
use App\Models\Item;
use App\Models\Attribute;
use App\Models\Warehouse;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

beforeEach(function () {

    // Arrange common data for the tests
    $this->item = Item::factory()->create();
    $this->attributes = Attribute::factory()->count(3)->create();
    $this->warehouse = Warehouse::factory()->create();
});

it('initializes stock manager with existing stock if it exists', function () {

    // Arrange specific to this test
    $existingStock = Stock::create([
        'item_id' => $this->item->id,
        'warehouse_id' => $this->warehouse->id,
        'quantity' => 10,
    ]);
    $existingStock->attributes()->attach($this->attributes);

    // Act
    $stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());

    // Assert
    expect($stockManager->getQuantity())->toBe(10)->and(Stock::count())->toBe(1);
});

it('initializes stock manager with new stock if none exists', function () {
    // Act
    $stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());
    $stockManager->set(10);

    // Assert
    expect($stockManager->getQuantity())->toBe(10)->and(Stock::count())->toBe(1);
});


it('does not create 2 stocks for the same item, attributes and warehouse', function () {

    // Arrange
    $stockManager1 = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());
    $stockManager1->set(10);

    // Act
    $stockManager2 = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());

    // Assert
    expect($stockManager2->getQuantity())->toBe(10)
        ->and(Stock::count())->toBe(1);
});


it('returns quantity of 0 when initializing same item, warehouse but different attributes', function () {

    // Arrange specific to this test
    $existingStock = Stock::create([
        'item_id' => $this->item->id,
        'warehouse_id' => $this->warehouse->id,
        'quantity' => 10,
    ]);

    // Attach attributes different from those used in the test
    $wrongAttributes = Attribute::factory()->count(2)->create();
    $existingStock->attributes()->attach($this->attributes);

    // Act
    $stockManager = new StockManager($this->item->id, $this->warehouse->id, $wrongAttributes->pluck('id')->toArray());

    // Assert
    expect($stockManager->getQuantity())->toBe(0);
});

it('increments stock quantity', function () {
    // Arrange
    $existingStock = Stock::create([
        'item_id' => $this->item->id,
        'warehouse_id' => $this->warehouse->id,
        'quantity' => 10,
    ]);
    $existingStock->attributes()->attach($this->attributes);

    // Act
    $stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());
    $stockManager->increment(5);

    // Assert
    expect($stockManager->getQuantity())->toBe(15);
});

it('decrements stock quantity', function () {
    // Arrange
    $existingStock = Stock::create([
        'item_id' => $this->item->id,
        'warehouse_id' => $this->warehouse->id,
        'quantity' => 10,
    ]);
    $existingStock->attributes()->attach($this->attributes);

    // Act
    $stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());
    $stockManager->decrement(3);

    // Assert
    expect($stockManager->getQuantity())->toBe(7);
});

it('sets stock quantity', function () {
    // Arrange
    $existingStock = Stock::create([
        'item_id' => $this->item->id,
        'warehouse_id' => $this->warehouse->id,
        'quantity' => 10,
    ]);
    $existingStock->attributes()->attach($this->attributes);

    // Act
    $stockManager = new StockManager($this->item->id, $this->warehouse->id, $this->attributes->pluck('id')->toArray());
    $stockManager->set(25);

    // Assert
    expect($stockManager->getQuantity())->toBe(25);
});
