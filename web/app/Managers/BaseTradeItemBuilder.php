<?php

namespace App\Managers;

use Exception;

abstract class BaseTradeItemBuilder
{
    public $item;                       // Generic item that can be either a SaleItem or PurchaseItem
    protected array $attributeIds = []; // Store attributes in memory

    public function __construct(
        protected int $itemId,
        protected $manager // This will be either a SaleManager or PurchaseOrderManager
    ) {
        $this->item = $this->createItemInstance([
            'item_id' => $this->itemId,
        ]);
    }

    abstract protected function createItemInstance(array $attributes);

    public function count(int $quantity): static
    {
        $this->item->quantity = $quantity;
        return $this;
    }

    public function attributeIds(array $attributeIds): static
    {
        $this->attributeIds = $attributeIds;
        return $this;
    }

    public function price(float $price): static
    {
        $this->item->price = $price;
        return $this;
    }

    /**
     * @throws Exception
     */
    public function add(): void
    {
        // Ensure necessary fields are set before adding the item
        $this->validate();

        // Shared validation
        if (!$this->item->warehouse_id) {
            throw new Exception('You must set the warehouse to send the items to or take them from.');
        }

        // Add the item to the manager's items array
        $this->manager->items[] = [
            'item' => $this->item,
            'attributeIds' => $this->attributeIds,
        ];
    }

    abstract protected function validate(): void;
}
