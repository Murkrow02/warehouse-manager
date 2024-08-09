<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class SupplierFactory extends Factory
{
    protected $model = \App\Models\Supplier::class;

    public function definition()
    {
        return [
            'name' => $this->faker->company,
            'contact_details' => $this->faker->address,
            'payment_details' => 'Bank transfer',
        ];
    }
}
