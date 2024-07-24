<?php

namespace App\Http\Controllers;

use App\Models\AttributeAssignment;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class AttributeAssignmentController extends Controller
{
    public function index(): JsonResponse
    {
        $assignments = AttributeAssignment::with('attribute')->get();

        return response()->json($assignments);
    }

    public function show(AttributeAssignment $assignment): JsonResponse
    {
        return response()->json($assignment->load('attribute'));
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'attribute_id' => 'required|exists:attributes,id',
            'attributable_id' => 'required|integer',
            'attributable_type' => 'required|string',
            'value' => 'required|string',
        ]);

        $assignment = AttributeAssignment::create($request->all());

        return response()->json($assignment, 201);
    }

    public function update(Request $request, AttributeAssignment $assignment): JsonResponse
    {
        $request->validate([
            'attribute_id' => 'exists:attributes,id',
            'attributable_id' => 'integer',
            'attributable_type' => 'string',
            'value' => 'string',
        ]);

        $assignment->update($request->all());

        return response()->json($assignment);
    }

    public function destroy(AttributeAssignment $assignment): JsonResponse
    {
        $assignment->delete();

        return response()->json(null, 204);
    }
}
