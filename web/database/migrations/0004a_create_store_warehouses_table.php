<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('store_warehouses', function (Blueprint $table) {
            $table->foreignId('store_id')->constrained();
            $table->foreignId('warehouse_id')->constrained();
            $table->primary(['store_id', 'warehouse_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('store_warehouses');
    }
};
