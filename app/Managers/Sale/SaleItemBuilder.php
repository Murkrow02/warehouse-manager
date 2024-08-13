<?php

namespace App\Managers\Sale;

use App\Managers\BaseTradeItemBuilder;
use App\Models\SaleItem;
use Exception;

class SaleItemBuilder extends BaseTradeItemBuilder
{
    protected function createItemInstance(array $attributes): SaleItem
    {
        return new SaleItem($attributes);
    }

    public function getFromWarehouse(int $warehouseId): static
    {
        $this->item->warehouse_id = $warehouseId;
        return $this;
    }
    protected function validate(): void
    {

    }
}
