<?php

namespace App\Http\Controllers;

use App\Exceptions\InvalidStoreException;
use App\Http\Requests\Sale\StoreSaleRequest;
use App\Http\Requests\Sale\UpdateSaleRequest;
use App\Managers\Sale\SaleManager;
use App\Models\Sale;
use App\Models\SaleItem;
use App\Models\Stock;
use DB;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class SaleController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $sales = Sale::where('store_id', $this->getStoreIdOrThrow())
            ->when($request->input('search'), function ($query, $search) {
                return $query->where('customer', 'like', "%{$search}%");
            })
            ->simplePaginate();

        return response()->json($sales);
    }

    public function show(Sale $sale): JsonResponse
    {
        return response()->json($sale->load('saleItems.item'));
    }

    /**
     * @throws InvalidStoreException
     */
    public function store(StoreSaleRequest $request): JsonResponse
    {

        // Instantiate a new sale for provided customer
        $saleManager = new SaleManager($this->getStoreIdOrThrow(), $request->customer, $request->payment_method);

        // Start adding articles
        foreach ($request->items as $item)
        {
            $saleManager->newItem($item['id'])
                ->count($item['quantity'])
                ->attributeIds($item['attributes'] ?? [])
                ->getFromWarehouse($item['warehouse_id'])
                ->price($item['price'])
                ->add();
        }

        // Execute the sale
        $sale = $saleManager->process();
        return response()->json($sale, 201);
    }

    public function update(UpdateSaleRequest $request, Sale $sale): JsonResponse
    {
        $sale->update($request->all());
        return response()->json($sale);
    }

    public function destroy(Sale $sale): JsonResponse
    {
        $sale->delete();
        return response()->json(null, 204);
    }
}
