<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class AttributeFactory extends Factory
{
    protected $model = \App\Models\Attribute::class;

    public function definition()
    {
        // Define possible options for each attribute type
        $attributes = [
            'Color' => ['Red', 'Blue', 'Green', 'Yellow', 'Black', 'White'],
            'Size' => ['Small', 'Medium', 'Large', 'Extra Large'],
            'Material' => ['Cotton', 'Polyester', 'Wool', 'Silk'],
            'Pattern' => ['Striped', 'Plain', 'Polka Dot', 'Checked'],
            'Brand' => ['Nike', 'Adidas', 'Puma', 'Under Armour'],
        ];

        // Randomly select an attribute type
        $name = $this->faker->randomElement(array_keys($attributes));
        // Select a value from the selected attribute type
        $value = $this->faker->randomElement($attributes[$name]);

        return [
            'name' => $name,
            'value' => $value,
        ];
    }
}
