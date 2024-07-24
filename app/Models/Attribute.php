<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Attribute extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'value',
    ];

    public function attributeAssignments(): HasMany
    {
        return $this->hasMany(AttributeAssignment::class);
    }
}
