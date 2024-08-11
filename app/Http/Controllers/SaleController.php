<?php

namespace App\Http\Controllers;

use App\Exceptions\InvalidStoreException;
use App\Http\Requests\Sale\StoreSaleRequest;
use App\Http\Requests\Sale\UpdateSaleRequest;
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
        DB::beginTransaction();

        // Get total price
        $totalPrice = collect($request->input('sale_items'))
            ->reduce(function ($carry, $itemData) {
                return $carry + $itemData['quantity'] * $itemData['price'];
            }, 0);

        // Merge total price to request data
        $data = array_merge($request->except('sale_items',), [
            'total_price' => $totalPrice,
            'store_id' => $this->getStoreIdOrThrow(),
        ]);

        // Create sale
        $sale = Sale::create($data);

        // Create sale items
        foreach ($request->input('sale_items') as $itemData) {

            SaleItem::create([
                'sale_id' => $sale->id,
                'item_id' => $itemData['item_id'],
                'quantity' => $itemData['quantity'],
                'price' => $itemData['price'],
            ]);

//            // Update stock after sale
//            $stockManager = new StockManager(
//                $itemData['item_id'],
//                $this->getStoreIdOrThrow(),
//                $itemData['attributes'],
//            );
//            $stockManager->increment($itemData['quantity']);
        }

        DB::commit();

        return response()->json($sale->load('saleItems.item'), 201);
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
