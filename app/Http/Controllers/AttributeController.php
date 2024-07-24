<?php

namespace App\Http\Controllers;

use App\Models\Attribute;
use App\Models\AttributeAssignment;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class AttributeController extends Controller
{
    public function index(): JsonResponse
    {
        $attributes = Attribute::all();

        return response()->json($attributes);
    }

    public function show(Attribute $attribute): JsonResponse
    {
        return response()->json($attribute->load('attributeAssignments'));
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'value' => 'required|string|max:255',
        ]);

        $attribute = Attribute::create($request->all());

        return response()->json($attribute, 201);
    }

    public function update(Request $request, Attribute $attribute): JsonResponse
    {
        $request->validate([
            'name' => 'string|max:255',
            'value' => 'string|max:255',
        ]);

        $attribute->update($request->all());

        return response()->json($attribute);
    }

    public function destroy(Attribute $attribute): JsonResponse
    {
        $attribute->delete();

        return response()->json(null, 204);
    }
}
