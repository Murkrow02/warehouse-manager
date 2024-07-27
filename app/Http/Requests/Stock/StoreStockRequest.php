<?php

namespace App\Http\Requests\Stock;

use Illuminate\Foundation\Http\FormRequest;

class StoreStockRequest extends FormRequest
{
    public function authorize(): bool
    {
        // Authorization logic if needed
        return true;
    }

    public function rules(): array
    {
        return [
            'item_id' => 'required|exists:items,id',
            'store_id' => 'required|exists:stores,id',
            'quantity' => 'required|integer|min:0',
            'attributes' => 'array',
            'attributes.*.id' => 'required|exists:attributes,id',
        ];
    }
}
