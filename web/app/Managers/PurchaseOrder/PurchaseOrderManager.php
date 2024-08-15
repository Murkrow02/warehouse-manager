<?php

namespace App\Managers\PurchaseOrder;

use App\Managers\BaseTradeManager;
use App\Models\PurchaseItem;
use App\Models\PurchaseOrder;
use App\Managers\Stock\StockManager;

class PurchaseOrderManager extends BaseTradeManager
{

    public function __construct(
        protected int $entityId,
        protected $orderDate = null
    ) {
        //parent::__construct();
    }

    protected function createMainTradeEntity(): PurchaseOrder
    {
        return PurchaseOrder::create([
            'supplier_id' => $this->entityId,
            'order_date' => $this->orderDate ?? now(),
            'status' => 'pending',
            'total_price' => $this->getItemsTotalPrice(),
        ]);
    }

    protected function setMainTradeEntityId($tradeItem, int $entityId): void
    {
        $tradeItem->purchase_order_id = $entityId;
    }

    protected function updateStocksForTradeItem(StockManager $stockManager, $tradeItem): void
    {
        $stockManager->increment($tradeItem->quantity);
    }

    /*
    |--------------------------------------------------------------------------
    | Builder
    |--------------------------------------------------------------------------
    */
    public function newItem($itemId): PurchaseItemBuilder
    {
        return new PurchaseItemBuilder($itemId, $this);
    }
}
