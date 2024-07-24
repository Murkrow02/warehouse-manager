<?php

namespace App\Http\Controllers;

use App\Models\Sale;
use App\Models\SaleItem;
use App\Models\Stock;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Gate;

class SaleController extends Controller
{


    public function index(Request $request): JsonResponse
    {
        $sales = Sale::where('store_id', $this->getStoreIdOrThrow())
            ->when($request->input('search'), function ($query, $search) {
                return $query->where('customer', 'like', "%{$search}%");
            })
            ->paginate(10);

        return response()->json($sales);
    }

    public function show(Sale $sale): JsonResponse
    {
        $this->authorize('view', $sale);

        return response()->json($sale->load('saleItems.item'));
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'customer' => 'required|string|max:255',
            'sale_date' => 'required|date',
            'status' => 'required|string',
            'sale_items' => 'required|array',
            'sale_items.*.item_id' => 'required|exists:items,id',
            'sale_items.*.quantity' => 'required|integer|min:1',
            'sale_items.*.price' => 'required|numeric|min:0',
        ]);

        $sale = Sale::create($request->except('sale_items'));

        foreach ($request->input('sale_items') as $itemData) {
            SaleItem::create([
                'sale_id' => $sale->id,
                'item_id' => $itemData['item_id'],
                'quantity' => $itemData['quantity'],
                'price' => $itemData['price'],
            ]);

            // Update stock after sale
            $stock = Stock::where('item_id', $itemData['item_id'])
                ->where('store_id', $this->getStoreIdOrThrow())
                ->firstOrFail();

            $stock->quantity -= $itemData['quantity'];
            $stock->save();
        }

        return response()->json($sale, 201);
    }

    public function update(Request $request, Sale $sale): JsonResponse
    {
        $request->validate([
            'customer' => 'string|max:255',
            'total_price' => 'numeric',
            'payment_method' => 'string',
        ]);

        $sale->update($request->all());

        return response()->json($sale);
    }

    public function destroy(Sale $sale): JsonResponse
    {
        $sale->delete();

        return response()->json(null, 204);
    }
}
