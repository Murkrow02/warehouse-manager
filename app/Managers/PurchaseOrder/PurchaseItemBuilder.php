<?php

namespace App\Managers\PurchaseOrder;

use App\Models\PurchaseItem;
use Exception;

class PurchaseItemBuilder
{
    public PurchaseItem $purchaseItem;
    protected array $attributeIds = []; // Store attributes in memory

    public function __construct(
        protected int $itemId,
        protected PurchaseOrderManager $purchaseManager,
    )
    {
        $this->purchaseItem = new PurchaseItem([
            'item_id' => $this->itemId,
        ]);
    }

    public function count(int $quantity) : PurchaseItemBuilder
    {
        $this->purchaseItem->quantity = $quantity;
        return $this;
    }

    public function attributeIds(array $attributeIds) : PurchaseItemBuilder
    {
        $this->attributeIds = $attributeIds; // Store attributes instead of attaching immediately
        return $this;
    }

    public function price(float $price) : PurchaseItemBuilder
    {
        $this->purchaseItem->price = $price;
        return $this;
    }

    public function sendToWarehouse(int $warehouseId) : PurchaseItemBuilder
    {
        $this->purchaseItem->warehouse_id = $warehouseId;
        return $this;
    }

    /**
     * @throws Exception
     */
    public function add() : void
    {
        // Ensure the warehouse is set
        if (!$this->purchaseItem->warehouse_id) {
            throw new Exception('You must set the warehouse to send the items to');
        }

        // Add the purchase item to the purchase manager's items array
        $this->purchaseManager->items[] = [
            'purchaseItem' => $this->purchaseItem,
            'attributeIds' => $this->attributeIds,
        ];
    }
}



