<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bill extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'user_id',
        'title',
        'amount',
        'due_date',
        'repeat_cycle',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
