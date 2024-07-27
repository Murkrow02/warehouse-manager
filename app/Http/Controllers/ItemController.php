<?php

namespace App\Http\Controllers;

use App\Http\Requests\Item\StoreItemRequest;
use App\Http\Requests\Item\UpdateItemRequest;
use App\Models\Item;
use App\Models\Stock;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $items = Item::when($request->input('search'), function ($query, $search) {
            return $query->where('name', 'like', "%{$search}%")
                ->orWhere('code', 'like', "%{$search}%");
        })->simplePaginate();

        return response()->json($items);
    }

    public function show(int $id): JsonResponse
    {
        $item = Item::findOrFail($id);
        return response()->json($item);
    }

    public function store(StoreItemRequest $request): JsonResponse
    {
        $item = Item::create($request->validated());
        return response()->json($item, 201);
    }

    public function update(UpdateItemRequest $request, int $id): JsonResponse
    {
        $item = Item::findOrFail($id);
        $item->update($request->validated());
        return response()->json($item);
    }

    public function destroy(int $id): JsonResponse
    {
        $item = Item::findOrFail($id);
        $item->delete();
        return response()->json(null, 204);
    }


}
