<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class AttributeFactory extends Factory
{
    protected $model = \App\Models\Attribute::class;

    public function definition()
    {
        return [
            'name' => $this->faker->word,
            'value' => $this->faker->word,
        ];
    }
}
