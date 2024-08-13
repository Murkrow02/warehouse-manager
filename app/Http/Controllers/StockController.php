<?php

namespace App\Http\Controllers;

use App\Http\Requests\Stock\DeleteStockRequest;
use App\Http\Requests\Stock\StoreStockRequest;
use App\Http\Requests\Stock\UpdateStockRequest;
use App\Models\Item;
use App\Models\Stock;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class StockController extends Controller
{
    public function index(): JsonResponse
    {
        // Get warehouses available for the store
        $storeWarehouses = $this->getStoreOrThrow()->warehouses->pluck('id');

        // Get search queries
        $name = request()->query('name');
        $code = request()->query('code');

        // Start by filtering items by name
        $items = Item::query();
        if ($code) { // If code is provided, filter by code only
            $items->where('code', $code);
        }
        else if ($name) { // If name is provided, filter by name
            $items->where('name', 'like', "%$name%");
        }

        // Get items available for the store
        $items = $items->whereHas('stocks', function ($query) use ($storeWarehouses) {
            $query->whereIn('warehouse_id', $storeWarehouses);
        })->simplePaginate();

        // Get the item IDs
        $itemIds = $items->pluck('id');

        // Get the stocks
        $stocks = Stock::whereIn('item_id', $itemIds)
            ->with(['item', 'attributes'])
            ->get();

        // Group the stocks by item
        $groupedStocks = $stocks->groupBy('item_id')->map(function ($stocks) {
            $item = $stocks->first()->item;
            return [
                'item' => $item,
                'stocks' => $stocks->map(function ($stock) {
                    return $stock->only(['id', 'quantity', 'attributes']);
                }),
            ];
        });

        // Transform the items
        $items->getCollection()->transform(function ($item) use ($groupedStocks) {
            return $groupedStocks->get($item->id);
        });

        return response()->json($items);
    }

    public function show(int $id): JsonResponse
    {
        // Get the store ID
        $storeId = $this->getStoreIdOrThrow();

        // Get the stock
        $stock = Stock::where('store_id', '=', $storeId)
            ->where('id', '=', $id)
            ->with(['item', 'attributes'])
            ->firstOrFail();

        return response()->json($stock);
    }


    public function store(StoreStockRequest $request): JsonResponse
    {
        $validated = $request->validated();

        DB::beginTransaction();
        try {

            // Create the stock
            $stock = Stock::create([
                'item_id' => $validated['item_id'],
                'store_id' => $validated['store_id'],
                'quantity' => $validated['quantity'],
            ]);

            // Add the attributes
            if (isset($validated['attributes'])) {
                foreach ($validated['attributes'] as $attribute) {
                    $stock->attributes()->create([
                        'attribute_id' => $attribute['id'],
                    ]);
                }
            }

            DB::commit();

            return response()->json($stock->load('attributes'), 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Failed to create stock'], 500);
        }
    }

    public function update(UpdateStockRequest $request, Stock $stock): JsonResponse
    {
        $validated = $request->validated();


        DB::beginTransaction();
        try {

            // Update the stock
            $stock->update(array_filter($validated, function($value, $key) {
                return in_array($key, ['item_id', 'store_id', 'quantity']);
            }, ARRAY_FILTER_USE_BOTH));

            if (isset($validated['attributes'])) {
                $stock->attributes()->delete();

                foreach ($validated['attributes'] as $attribute) {
                    $stock->attributes()->create([
                        'attribute_id' => $attribute['id'],
                    ]);
                }
            }

            DB::commit();

            return response()->json($stock->load('attributes'));
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Failed to update stock'], 500);
        }
    }

    public function destroy(Stock $stock): JsonResponse
    {
        DB::beginTransaction();
        try {
            $stock->attributes()->delete();
            $stock->delete();

            DB::commit();

            return response()->json(['message' => 'Stock deleted successfully']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Failed to delete stock'], 500);
        }
    }
}
