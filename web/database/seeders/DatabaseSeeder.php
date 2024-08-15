<?php

namespace Database\Seeders;

use App\Managers\PurchaseOrder\PurchaseOrderManager;
use App\Models\User;
use App\Models\Warehouse;
use Illuminate\Database\Seeder;
use App\Models\Item;
use App\Models\Category;
use App\Models\Supplier;
use App\Models\Store;
use App\Models\Message;
use App\Models\Attribute;
use Faker\Factory as Faker;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();

        // Create test user
        User::factory()->create([
            'email' => 'a@a.it',
        ]);

        // Create Suppliers
        $suppliers = Supplier::factory()->count(10)->create();

        // Create root categories
        $categories = Category::factory()->count(10)->create();

        // Create subcategories
        $categories->each(function ($category) use ($categories, $faker) {
            $category->childCategories()->createMany(
                Category::factory()->count($faker->numberBetween(2, 5))->make()->toArray()
            );
        });

        // Update categories with all the subcategories
        $categories = Category::all();

        // Create Items
        $items = Item::factory()->count(50)->create()->each(function ($item) use ($faker, $categories) {
            $item->categories()->attach(
                $faker->randomElements($categories->pluck('id')->toArray(), $faker->numberBetween(1, 3))
            );
        });

        // Create Attributes
        $attributes = Attribute::factory()->count(20)->create();

        // Create stores with one warehouse each
        $stores = Store::factory()->count(10)->create()->each(function ($store) {
            $store->warehouses()->save(Warehouse::factory()->make());
        });

        // Foreach store, associate also the warehouse of the next store to mix up the data
        $stores->each(function ($store, $key) use ($stores) {
            $store->warehouses()->attach($stores->get(($key + 1) % $stores->count())->warehouses->first());
        });

        // Purchase some items foreach store
        foreach ($stores as $store) {

            // Purchase from random supplier
            $purchaseOrderManager = new PurchaseOrderManager(
                Supplier::inRandomOrder()->first()->id
            );

            // Add items to the purchase order
            for ($i = 0; $i < $faker->numberBetween(1, 5); $i++) {
                $purchaseOrderManager->newItem(Item::inRandomOrder()->first()->id)
                    ->count($faker->numberBetween(1, 10))
                    ->attributeIds($attributes->random($faker->numberBetween(1, 5))->pluck('id')->toArray())
                    ->price($faker->randomFloat(2, 1, 100))
                    ->sendToWarehouse($store->warehouses->random()->id)
                    ->add();
            }

            // Finalize the purchase
            $purchaseOrderManager->process();
        }

        // Create Messages
        $stores->each(function ($store) use ($stores, $faker) {
            $otherStores = $stores->where('id', '!=', $store->id);

            foreach ($otherStores as $otherStore) {
                Message::create([
                    'sender_store_id' => $store->id,
                    'receiver_store_id' => $otherStore->id,
                    'text' => $faker->text,
                    'status' => $faker->randomElement(['sent', 'received', 'read']),
                ]);
            }
        });
    }
}
