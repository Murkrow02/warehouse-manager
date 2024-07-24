<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class SaleFactory extends Factory
{
    protected $model = \App\Models\Sale::class;

    public function definition()
    {
        return [
            'sale_date' => $this->faker->date(),
            'customer' => $this->faker->name,
            'total_price' => $this->faker->randomFloat(2, 10, 500),
            'payment_method' => $this->faker->randomElement(['cash', 'credit_card', 'paypal']),
        ];
    }
}
