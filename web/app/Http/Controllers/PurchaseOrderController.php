<?php

namespace App\Http\Controllers;

use App\Http\Requests\PurchaseOrder\StorePurchaseOrderRequest;
use App\Managers\PurchaseOrder\PurchaseOrderManager;
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
        return response()->json($order->load('supplier', 'purchaseItems.item', 'purchaseItems.attributes', 'purchaseItems.warehouse'));
    }

    public function store(StorePurchaseOrderRequest $request): JsonResponse
    {
        // Instantiate a new purchase for provided supplier
        $manager = new PurchaseOrderManager($request->supplier_id, $request->order_date);

        // Start adding articles
        foreach ($request->items as $item) {
            $manager->newItem($item['id'])
                ->count($item['quantity'])
                ->attributeIds($item['attributes'] ?? [])
                ->sendToWarehouse($item['warehouse_id'])
                ->price($item['price'])
                ->add();
        }

        // Execute the purchase
        $order = $manager->process();
        return response()->json($order, 201);
    }

    public function destroy(PurchaseOrder $order): JsonResponse
    {
        $order->delete();
        return response()->json(null, 204);
    }
}
