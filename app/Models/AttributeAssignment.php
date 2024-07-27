<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class AttributeAssignment extends Model
{
    use HasFactory;

    protected $fillable = [
        'attribute_id',
        'attributable_id',
        'attributable_type',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
        'attribute_id',
        'attributable_id',
        'attributable_type',
        'id',
    ];

    protected $with = ['attribute'];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */
    public function attribute(): BelongsTo
    {
        return $this->belongsTo(Attribute::class);
    }

    public function attributable(): MorphTo
    {
        return $this->morphTo();
    }
}
