<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class PurchaseOrderFactory extends Factory
{
    protected $model = \App\Models\PurchaseOrder::class;

    public function definition()
    {
        return [
            'supplier_id' => \App\Models\Supplier::factory(),
            'order_date' => $this->faker->date(),
            'status' => $this->faker->randomElement(['pending', 'completed', 'shipped']),
        ];
    }
}
