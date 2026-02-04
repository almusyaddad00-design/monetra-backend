<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Wallet;
use App\Models\Category;
use App\Models\Transaction;
use App\Models\UmkmSale;
use App\Models\UmkmDebt;
use App\Models\Bill;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Create a Test User
        $user = User::create([
            'id' => (string) Str::uuid(),
            'name' => 'Budi Santoso',
            'email' => 'demo@example.com',
            'password' => Hash::make('password'),
            'pin' => '123456',
            'role' => 'umkm',
        ]);

        // 2. Create Wallets
        $tunai = Wallet::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'type' => 'tunai',
            'name' => 'Uang Tunai',
            'balance' => 1500000.00,
        ]);

        $bca = Wallet::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'type' => 'bank',
            'name' => 'Bank BCA',
            'balance' => 25000000.00,
        ]);

        $gopay = Wallet::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'type' => 'ewallet',
            'name' => 'GoPay',
            'balance' => 500000.00,
        ]);

        // 3. Create Categories
        $gaji = Category::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'name' => 'Gaji Bulanan',
            'type' => 'pemasukan',
        ]);

        $makan = Category::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'name' => 'Makan & Minum',
            'type' => 'pengeluaran',
        ]);

        // 4. Create Transactions
        Transaction::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'wallet_id' => $bca->id,
            'category_id' => $gaji->id,
            'type' => 'pemasukan',
            'amount' => 7500000.00,
            'date' => now()->subDays(2),
            'note' => 'Gaji Januari',
        ]);

        // 5. Create UMKM Data
        UmkmSale::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'customer_name' => 'Toko Barokah',
            'amount' => 450000.00,
            'date' => now(),
        ]);

        UmkmDebt::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'name' => 'Pak Haji Slamet',
            'type' => 'piutang',
            'amount' => 1200000.00,
            'due_date' => now()->addDays(7),
        ]);

        // 6. Create Bills
        Bill::create([
            'id' => (string) Str::uuid(),
            'user_id' => $user->id,
            'title' => 'Listrik PLN',
            'amount' => 350000.00,
            'due_date' => now()->addDays(3),
            'status' => 'unpaid',
        ]);

        $this->command->info('Database Monetra Seeded! User: demo@example.com / password');
    }
}
