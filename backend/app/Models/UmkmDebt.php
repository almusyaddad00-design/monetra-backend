<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UmkmDebt extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'user_id',
        'name',
        'type',
        'amount',
        'due_date',
        'is_paid',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
