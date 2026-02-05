<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Update Users with Role
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('user')->after('pin'); // user, umkm, admin
        });

        // UMKM Penjualan (Sales)
        Schema::create('umkm_sales', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
            $table->string('customer_name');
            $table->decimal('amount', 15, 2);
            $table->dateTime('date');
            $table->timestamps();
        });

        // UMKM Hutang Piutang (Debts/Receivables)
        Schema::create('umkm_debts', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
            $table->string('name');
            $table->string('type'); // hutang, piutang
            $table->decimal('amount', 15, 2);
            $table->date('due_date');
            $table->boolean('is_paid')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('umkm_debts');
        Schema::dropIfExists('umkm_sales');
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('role');
        });
    }
};
