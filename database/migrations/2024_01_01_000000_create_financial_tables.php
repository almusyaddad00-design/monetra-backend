<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('name');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('pin')->nullable();
            $table->timestamps();
        });

        Schema::create('wallets', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
            $table->string('type'); // cash, bank, credit_card
            $table->string('name');
            $table->decimal('balance', 15, 2)->default(0);
            $table->timestamps();
        });

        Schema::create('categories', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
            $table->string('name');
            $table->string('type'); // income, expense
            $table->timestamps();
        });

        Schema::create('transactions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
            $table->foreignUuid('wallet_id')->constrained()->onDelete('cascade');
            $table->foreignUuid('category_id')->nullable()->constrained()->onDelete('set null');
            $table->string('type'); // income, expense, transfer
            $table->decimal('amount', 15, 2);
            $table->dateTime('date');
            $table->text('note')->nullable();
            $table->timestamps();
        });

        Schema::create('bills', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
            $table->string('title');
            $table->decimal('amount', 15, 2);
            $table->date('due_date');
            $table->string('repeat_cycle')->nullable(); // monthly, weekly
            $table->string('status')->default('unpaid');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bills');
        Schema::dropIfExists('transactions');
        Schema::dropIfExists('categories');
        Schema::dropIfExists('wallets');
        Schema::dropIfExists('users');
    }
};
