<?php

namespace App\Http\Controllers;

use App\Http\Requests\PurchaseOrder\StorePurchaseOrderRequest;
use App\Models\PurchaseOrder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PurchaseOrderController extends Controller
{
    public function index(): JsonResponse
    {
        $orders = PurchaseOrder::with('supplier')->get();
        return response()->json($orders);
    }

    public function show(PurchaseOrder $order): JsonResponse
    {
        return response()->json($order->load('supplier', 'purchaseItems.item'));
    }

    public function store(StorePurchaseOrderRequest $request): JsonResponse
    {
        $request->validate([
            'supplier_id' => 'required|exists:suppliers,id',
            'order_date' => 'required|date',
            'status' => 'required|string',
        ]);

        $order = PurchaseOrder::create($request->all());
        return response()->json($order, 201);
    }

    public function update(Request $request, PurchaseOrder $order): JsonResponse
    {
        $request->validate([
            'supplier_id' => 'exists:suppliers,id',
            'order_date' => 'date',
            'status' => 'string',
        ]);

        $order->update($request->all());

        return response()->json($order);
    }

    public function destroy(PurchaseOrder $order): JsonResponse
    {
        $order->delete();
        return response()->json(null, 204);
    }
}
