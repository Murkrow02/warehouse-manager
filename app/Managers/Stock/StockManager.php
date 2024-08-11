<?php

namespace App\Managers\Stock;

use App\Models\Stock;

class StockManager
{
    // The stock we are editing
    private Stock $stock;


    // Constructor to set the target item with attributes
    public function __construct(
        protected int   $itemId,
        protected int   $warehouseId,
        protected array $attributeIds,
    )
    {

        // Get stocks for given item inside the store (these can be of multiple variants)
        $itemStocks = Stock::where('item_id', $this->itemId)
            ->where('warehouse_id', $this->warehouseId);

        // Filter out the ones where the attributes do not match
        $itemStocks->whereHas('attributes', function ($query) {
            $query->whereIn('id', $this->attributeIds);
        });

        // Get the first stock that matches the attributes
        $existing = $itemStocks->first();
        if ($existing) {
            $this->stock = $existing;
            return;
        }

        // If no stock exists, create a new one
        $this->stock = Stock::create([
            'item_id' => $this->itemId,
            'warehouse_id' => $this->warehouseId,
            'quantity' => 0,
        ]);
        $this->stock->attributes()->attach($this->attributeIds);
    }


    public function increment(int $quantity): void
    {
        $this->stock->quantity += $quantity;
        $this->stock->save();
    }

    public function decrement(int $quantity): void
    {
        $this->stock->quantity -= $quantity;
        $this->stock->save();
    }

    public function set(int $quantity): void
    {
        $this->stock->quantity = $quantity;
        $this->stock->save();
    }

    public function getQuantity(): int
    {
        $this->stock->refresh();
        return $this->stock->quantity ?? 0;
    }
}
