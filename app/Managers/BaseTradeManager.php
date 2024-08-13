<?php

namespace App\Managers;

use App\Managers\Stock\StockManager;
use App\Models\PurchaseOrder;
use App\Models\Sale;
use DB;
use Exception;

/*
 * BaseTradeManager is an abstract class that provides a template for creating Sale and PurchaseOrder managers
 * This groups the logic for creating the main entity (PurchaseOrder or Sale) and the corresponding PurchaseItem or SaleItem
 */
abstract class BaseTradeManager
{
    public array $items = []; // Array of ['item' => PurchaseItem|SaleItem, 'attributeIds' => [int])]

    /**
     * @throws Exception
     */
    public function process(): PurchaseOrder|Sale
    {
        DB::beginTransaction();

        try {

            // Create the main entity (PurchaseOrder or Sale)
            $entity = $this->createMainTradeEntity();

            // Create the items
            foreach ($this->items as $itemData) {

                // Get the trade item
                $item = $itemData['item'];

                // Set the main entity id (purchase_order_id or sale_id)
                $this->setMainTradeEntityId($item, $entity->id);
                $item->save();

                // Attach the attributes
                $item->attributes()->attach($itemData['attributeIds']);

                // Update stock or perform other necessary actions
                $stockManager = new StockManager(
                    $item->item_id,
                    $item->warehouse_id,
                    $itemData['attributeIds']
                );
                $this->updateStocksForTradeItem($stockManager, $item);
            }

            DB::commit();

            return $entity;
        } catch (Exception $e) {
            DB::rollBack();
            throw $e; // Re-throw the exception after rolling back the transaction
        }
    }

    /*
     * Get the total price of all items
     */
    public function getItemsTotalPrice(): float
    {
        return collect($this->items)->sum(function ($itemData) {
            return $itemData['item']->price * $itemData['item']->quantity;
        });
    }


    /*
     * Create the main entity (PurchaseOrder or Sale)
     * To be implemented by the child class
     */
    abstract protected function createMainTradeEntity();

    /*
     * Set the main entity id (purchase_order_id or sale_id) on the trade item
     * To be implemented by the child class
     */
    abstract protected function setMainTradeEntityId($tradeItem, int $entityId);

    /*
     * Update stock or perform other necessary actions for the trade item
     * To be implemented by the child class
     */
    abstract protected function updateStocksForTradeItem(StockManager $stockManager, $tradeItem);
}
