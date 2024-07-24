<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\Item;
use App\Models\Stock;
use App\Models\Category;
use App\Models\ItemCategory;
use App\Models\Supplier;
use App\Models\PurchaseOrder;
use App\Models\PurchaseItem;
use App\Models\Sale;
use App\Models\SaleItem;
use App\Models\Store;
use App\Models\Message;
use App\Models\Attribute;
use App\Models\AttributeAssignment;
use Faker\Factory as Faker;

class DatabaseSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create();

        // Create test user
        User::factory()->create([
            'email' => 'a@a.it',
        ]);

        // Create Suppliers
        $suppliers = Supplier::factory()->count(10)->create();

        // Create Categories
        $categories = Category::factory()->count(10)->create();

        // Create Items
        $items = Item::factory()->count(50)->create()->each(function ($item) use ($faker, $categories) {
            $item->categories()->attach(
                $faker->randomElements($categories->pluck('id')->toArray(), $faker->numberBetween(1, 3))
            );
        });

        // Create Stores
        $stores = Store::factory()->count(5)->create();

        // Create Stocks
        $items->each(function ($item) use ($stores, $faker) {
            foreach ($stores as $store) {
                Stock::create([
                    'item_id' => $item->id,
                    'store_id' => $store->id,
                    'quantity' => $faker->numberBetween(1, 100),
                ]);
            }
        });

        // Create Purchase Orders and Purchase Items
        $suppliers->each(function ($supplier) use ($items, $faker) {
            $purchaseOrders = PurchaseOrder::factory()->count(5)->create([
                'supplier_id' => $supplier->id,
            ]);

            $purchaseOrders->each(function ($purchaseOrder) use ($items, $faker) {
                foreach ($items->random($faker->numberBetween(1, 5)) as $item) {
                    PurchaseItem::create([
                        'purchase_order_id' => $purchaseOrder->id,
                        'item_id' => $item->id,
                        'quantity' => $faker->numberBetween(1, 50),
                        'price' => $faker->randomFloat(2, 1, 100),
                    ]);
                }
            });
        });

        // Create Sales
        $sales = Sale::factory()->count(20)->create();

        // Create Sale Items
        $sales->each(function ($sale) use ($items, $faker) {
            foreach ($items->random($faker->numberBetween(1, 5)) as $item) {
                SaleItem::create([
                    'sale_id' => $sale->id,
                    'item_id' => $item->id,
                    'quantity' => $faker->numberBetween(1, 10),
                    'price' => $faker->randomFloat(2, 1, 100),
                ]);
            }
        });

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

        // Create Attributes
        $attributes = Attribute::factory()->count(20)->create();

        // Create Attribute Assignments
        $items->each(function ($item) use ($attributes, $faker) {
            foreach ($attributes->random($faker->numberBetween(1, 5)) as $attribute) {
                AttributeAssignment::create([
                    'attribute_id' => $attribute->id,
                    'attributable_id' => $item->id,
                    'attributable_type' => Item::class,
                    'value' => $faker->word,
                ]);
            }
        });
    }
}
