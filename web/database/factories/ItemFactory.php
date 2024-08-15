<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ItemFactory extends Factory
{
    protected $model = \App\Models\Item::class;

    public function definition()
    {
        return [
            'code' => $this->faker->unique()->ean13,
            'name' => $this->faker->word,
            'description' => $this->faker->sentence,
            'gender' => $this->faker->randomElement(['male', 'female']),
            'purchase_price' => $this->faker->randomFloat(2, 1, 100),
            'sale_price' => $this->faker->randomFloat(2, 1, 150),
            'vat' => $this->faker->randomFloat(2, 1, 20),
            'min_stock_quantity' => $this->faker->numberBetween(1, 20),
            'last_reorder_date' => $this->faker->date(),
            'supplier_id' => \App\Models\Supplier::factory(),
            'serial_number' => $this->faker->uuid,
        ];
    }
}
