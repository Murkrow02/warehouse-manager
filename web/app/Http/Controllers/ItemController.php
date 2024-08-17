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
            return $query->where('name', 'like', "%{$search}%");
        })->simplePaginate();

        return response()->json($items);
    }

    public function show(Item $item): JsonResponse
    {
        return $this->okResponse($item->load('supplier', 'categories'));
    }

    public function showByCode(string $code): JsonResponse
    {
        $item = Item::where('code', $code)->first();
        return $this->okResponse($item->load('supplier', 'categories'));
    }

    public function store(StoreItemRequest $request): JsonResponse
    {
        $item = Item::create($request->validated());
        return response()->json($item, 201);
    }

    public function addImages(Item $item): JsonResponse
    {
        // Add new images
        $item->addMultipleMediaFromRequest(['images'])
            ->each(function ($fileAdder) {
                $fileAdder->toMediaCollection('images');
            });
        return response()->json($item->getMedia('images'));
    }

    public function update(UpdateItemRequest $request, Item $item): JsonResponse
    {
        $item->update($request->validated());
        return response()->json($item);
    }

    public function destroy(Item $item): JsonResponse
    {
        $item->delete();
        return response()->json(null, 204);
    }


}
