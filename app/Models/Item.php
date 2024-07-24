<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;

class Item extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'name',
        'description',
        'gender',
        'purchase_price',
        'sale_price',
        'vat',
        'image',
        'barcode',
        'qrcode',
        'min_stock_quantity',
        'last_reorder_date',
        'supplier_id',
        'serial_number',
    ];

    protected $hidden = [
        'supplier_id',
    ];

    protected $casts = [
        'last_reorder_date' => 'date',
    ];

    public function supplier(): BelongsTo
    {
        return $this->belongsTo(Supplier::class);
    }

    public function stocks(): HasMany
    {
        return $this->hasMany(Stock::class);
    }

    public function categories(): BelongsToMany
    {
        return $this->belongsToMany(Category::class, 'item_categories');
    }

    public function purchaseItems(): HasMany
    {
        return $this->hasMany(PurchaseItem::class);
    }

    public function saleItems(): HasMany
    {
        return $this->hasMany(SaleItem::class);
    }

    public function attributeAssignments(): MorphMany
    {
        return $this->morphMany(AttributeAssignment::class, 'attributable');
    }
}
