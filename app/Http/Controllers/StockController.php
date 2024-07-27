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
        $storeId = $this->getStoreIdOrThrow();

        $items = Item::whereHas('stocks', function ($query) use ($storeId) {
            $query->where('store_id', $storeId);
        })->simplePaginate();

        $itemIds = $items->pluck('id');

        $stocks = Stock::where('store_id', '=', $storeId)
            ->whereIn('item_id', $itemIds)
            ->with(['item', 'attributes'])
            ->get();

        $groupedStocks = $stocks->groupBy('item_id')->map(function ($stocks) {
            $item = $stocks->first()->item;
            return [
                'item' => $item,
                'stocks' => $stocks->map(function ($stock) {
                    return $stock->only(['id', 'quantity', 'attributes']);
                }),
            ];
        });

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

    public function update(UpdateStockRequest $request, int $id): JsonResponse
    {
        $validated = $request->validated();

        // Get the stock requested
        $stock = Stock::where('id', $id)
            ->where('store_id', $this->getStoreIdOrThrow())
            ->firstOrFail();

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

    public function destroy(int $id): JsonResponse
    {
        $stock = Stock::where('id', $id)
            ->where('store_id', $this->getStoreIdOrThrow())
            ->firstOrFail();

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
