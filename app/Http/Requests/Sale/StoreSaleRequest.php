<?php

namespace App\Http\Requests\Sale;

use Illuminate\Foundation\Http\FormRequest;

class StoreSaleRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Adjust authorization as needed
    }

    public function rules(): array
    {
        return [
            'customer' => 'required|string|max:255',
            'sale_date' => 'required|date',
            'status' => 'required|string',
            'payment_method' => 'required|string',
            'sale_items' => 'required|array',
            'sale_items.*.item_id' => 'required|exists:items,id',
            'sale_items.*.quantity' => 'required|integer|min:1',
            'sale_items.*.price' => 'required|numeric|min:0',
        ];
    }
}
