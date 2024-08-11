<?php

namespace App\Managers\PurchaseOrder;

use App\Managers\Stock\StockManager;
use App\Models\PurchaseItem;
use App\Models\PurchaseOrder;
use App\Models\Stock;
use DB;
use Exception;

class PurchaseOrderManager
{
    public array $items = [];   // Array of [purchaseItem, attributeIds]

    public function __construct(
        protected int $supplierId,
    ) {}

    /**
     * @throws Exception
     */
    public function purchase(): void
    {
        DB::beginTransaction();

        try {
            // Create the purchase order
            $purchaseOrder = PurchaseOrder::create([
                'supplier_id' => $this->supplierId,
                'order_date' => now(),
                'status' => 'pending',
            ]);

            // Create the purchase items
            foreach ($this->items as $itemData) {

                /** @var PurchaseItem $purchaseItem */
                $purchaseItem = $itemData['purchaseItem'];

                // Set the purchase order id
                $purchaseItem->purchase_order_id = $purchaseOrder->id;
                $purchaseItem->save();

                // Attach the attributes
                $purchaseItem->attributes()->attach($itemData['attributeIds']);

                // Fill the stock for the item
                $stockManager = new StockManager(
                    $purchaseItem->item_id,
                    $purchaseItem->warehouse_id,
                    $itemData['attributeIds']
                );

                $stockManager->increment($purchaseItem->quantity);
            }

            DB::commit();
        } catch (Exception $e) {
            DB::rollBack();
            throw $e; // Re-throw the exception after rolling back the transaction
        }
    }

    /*
    |--------------------------------------------------------------------------
    | Builder
    |--------------------------------------------------------------------------
    */
    public function newItem($itemId) : PurchaseItemBuilder
    {
        return new PurchaseItemBuilder($itemId, $this);
    }
}
