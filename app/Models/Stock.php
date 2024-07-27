<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\Relations\MorphOne;

class Stock extends Model
{

    protected $fillable = [
        'item_id',
        'store_id',
        'quantity',
    ];

    protected $hidden = [
        'created_at',
        'item_id',
        'store_id',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */
    public function item(): BelongsTo
    {
        return $this->belongsTo(Item::class);
    }

    public function store(): BelongsTo
    {
        return $this->belongsTo(Store::class);
    }

    public function attributes(): MorphMany
    {
        return $this->morphMany(AttributeAssignment::class, 'attributable');
    }
}
