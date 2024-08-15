<?php

namespace App\Http\Requests\Item;

use Illuminate\Foundation\Http\FormRequest;

class UpdateItemRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'code' => 'string|max:255',
            'name' => 'string|max:255',
            'description' => 'nullable|string',
            'gender' => 'nullable|string|max:255',
            'purchase_price' => 'numeric',
            'sale_price' => 'numeric',
            'vat' => 'nullable|numeric',
            'min_stock_quantity' => 'integer',
            'last_reorder_date' => 'nullable|date',
            'supplier_id' => 'nullable|exists:suppliers,id',
            'serial_number' => 'nullable|string',
            'images' => 'nullable|array',
        ];
    }
}
