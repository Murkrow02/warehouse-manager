<?php

namespace App\Http\Requests\PurchaseOrder;

use Illuminate\Foundation\Http\FormRequest;

class StorePurchaseOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Adjust as necessary for authorization
    }

    public function rules(): array
    {
        return [
//            'supplier_id' => 'required|exists:suppliers,id',
//            'order_date' => 'required|date',
//            'items' => 'required|array',
//            'items.*.item_id' => 'required|exists:items,id',
//            'items.*.quantity' => 'required|integer|min:1',
//            'items.*.attributes' => 'array',
//            'items.*.attributes.*' => 'integer|exists:attributes,id',
        ];
    }
}
