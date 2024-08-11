<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('attributables', function (Blueprint $table) {
            $table->foreignId('attribute_id')->constrained();
            $table->morphs('attributable');
        });
    }

    public function down()
    {
        Schema::dropIfExists('attributables');
    }
};
