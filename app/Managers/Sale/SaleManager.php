<?php

namespace App\Managers\Sale;

use App\Managers\BaseTradeManager;
use App\Models\Sale;
use App\Models\SaleItem;
use App\Managers\Stock\StockManager;

class SaleManager extends BaseTradeManager
{
    public function __construct(
        protected int $storeId,
        protected string $customer,
        protected string $paymentMethod,
        protected $saleDate = null
    )
    {
        //parent::__construct();
    }

    protected function createMainTradeEntity(): Sale
    {
        return Sale::create([
            'customer' => $this->customer,
            'payment_method' => $this->paymentMethod,
            'store_id' => $this->storeId,
            'sale_date' => $this->saleDate ?? now(),
            'status' => 'pending',
            'total_price' => $this->getItemsTotalPrice(),
        ]);
    }

    protected function setMainTradeEntityId($tradeItem, int $entityId): void
    {
        $tradeItem->sale_id = $entityId;
    }

    protected function updateStocksForTradeItem(StockManager $stockManager, $tradeItem): void
    {
        $stockManager->decrement($tradeItem->quantity);
    }

    /*
    |--------------------------------------------------------------------------
    | Builder
    |--------------------------------------------------------------------------
    */
    public function newItem($itemId): SaleItemBuilder
    {
        return new SaleItemBuilder($itemId, $this);
    }
}
