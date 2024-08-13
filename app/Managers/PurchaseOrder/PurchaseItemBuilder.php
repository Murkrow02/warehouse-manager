<?php

namespace App\Managers\PurchaseOrder;

use App\Managers\BaseTradeItemBuilder;
use App\Models\PurchaseItem;
use Exception;

class PurchaseItemBuilder extends BaseTradeItemBuilder
{
    protected function createItemInstance(array $attributes): PurchaseItem
    {
        return new PurchaseItem($attributes);
    }

    public function sendToWarehouse(int $warehouseId): static
    {
        $this->item->warehouse_id = $warehouseId;
        return $this;
    }

    protected function validate(): void
    {

    }
}
