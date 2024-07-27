<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAttributeAssignmentsTable extends Migration
{
    public function up()
    {
        Schema::create('attribute_assignments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('attribute_id')->constrained();
            $table->morphs('attributable');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('attribute_assignments');
    }
}
