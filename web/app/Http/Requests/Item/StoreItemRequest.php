<?php

namespace App\Http\Requests\Item;

use Illuminate\Foundation\Http\FormRequest;

class StoreItemRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Adjust as necessary for authorization
    }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'gender' => 'nullable|string|max:255',
            'purchase_price' => 'required|numeric',
            'sale_price' => 'required|numeric',
            'vat' => 'nullable|numeric',
            'min_stock_quantity' => 'required|integer',
            'last_reorder_date' => 'nullable|date',
            'supplier_id' => 'nullable|exists:suppliers,id',
            'serial_number' => 'nullable|string',
            'images' => 'nullable|array',
        ];
    }
}
