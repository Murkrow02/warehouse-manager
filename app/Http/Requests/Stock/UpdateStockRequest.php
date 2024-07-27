<?php

namespace App\Http\Requests\Stock;

use Illuminate\Foundation\Http\FormRequest;

class UpdateStockRequest extends FormRequest
{
    public function authorize(): bool
    {
        // Authorization logic if needed
        return true;
    }

    public function rules(): array
    {
        return [
            'item_id' => 'sometimes|required|exists:items,id',
            'store_id' => 'sometimes|required|exists:stores,id',
            'quantity' => 'sometimes|required|integer|min:0',
            'attributes' => 'sometimes|array',
            'attributes.*.id' => 'required_with:attributes|exists:attributes,id',
        ];
    }
}
