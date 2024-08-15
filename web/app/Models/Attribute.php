<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Attribute extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'value',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
        'pivot'
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

}
