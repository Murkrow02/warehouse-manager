<?php

namespace App\Http\Controllers;

use App\Models\Item;
use App\Models\Stock;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Gate;

class ItemController extends Controller
{

    public function index(Request $request): JsonResponse
    {
        $items = Item::where('store_id', $this->getStoreIdOrThrow())
            ->when($request->input('search'), function ($query, $search) {
                return $query->where('name', 'like', "%{$search}%")
                    ->orWhere('code', 'like', "%{$search}%");
            })
            ->paginate(10);

        return response()->json($items);
    }

    public function show(Item $item): JsonResponse
    {
        return response()->json($item);
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'code' => 'required|string|max:255',
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'gender' => 'nullable|string|max:255',
            'purchase_price' => 'required|numeric',
            'sale_price' => 'required|numeric',
            'vat' => 'nullable|numeric',
            'image' => 'nullable|string',
            'barcode' => 'nullable|string',
            'qrcode' => 'nullable|string',
            'min_stock_quantity' => 'required|integer',
            'last_reorder_date' => 'nullable|date',
            'supplier_id' => 'nullable|exists:suppliers,id',
            'serial_number' => 'nullable|string',
        ]);

        $item = Item::create($request->all());

        return response()->json($item, 201);
    }

    public function update(Request $request, Item $item): JsonResponse
    {
        $request->validate([
            'code' => 'string|max:255',
            'name' => 'string|max:255',
            'description' => 'nullable|string',
            'gender' => 'nullable|string|max:255',
            'purchase_price' => 'numeric',
            'sale_price' => 'numeric',
            'vat' => 'nullable|numeric',
            'image' => 'nullable|string',
            'barcode' => 'nullable|string',
            'qrcode' => 'nullable|string',
            'min_stock_quantity' => 'integer',
            'last_reorder_date' => 'nullable|date',
            'supplier_id' => 'nullable|exists:suppliers,id',
            'serial_number' => 'nullable|string',
        ]);

        $item->update($request->all());

        return response()->json($item);
    }

    public function destroy(Item $item): JsonResponse
    {
        $item->delete();

        return response()->json(null, 204);
    }

    public function updateStock(Request $request, Item $item): JsonResponse
    {
        $request->validate([
            'quantity' => 'required|integer',
        ]);

        $stock = Stock::firstOrCreate(
            ['item_id' => $item->id, 'store_id' => $this->getStoreIdOrThrow()],
            ['quantity' => 0]
        );

        $stock->quantity += $request->input('quantity');
        $stock->save();

        return response()->json($stock);
    }
}
