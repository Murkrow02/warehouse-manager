<?php

namespace App\Http\Controllers;

use App\Models\Stock;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class StockController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $stocks = Stock::where('store_id', $this->getStoreIdOrThrow())
            ->with('item')
            ->paginate(10);

        return response()->json($stocks);
    }

    public function show(Stock $stock): JsonResponse
    {
        return response()->json($stock->load('item'));
    }
}
