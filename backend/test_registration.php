<?php
require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\Wallet;
use Illuminate\Support\Facades\Hash;

$email = 'test_' . time() . '@example.com';
echo "Registering $email...\n";

$user = User::create([
    'name' => 'Test User',
    'email' => $email,
    'password' => Hash::make('password'),
]);

// AuthController logic
$categories = [
    ['name' => 'Pendapatan', 'type' => 'pemasukan'],
    ['name' => 'Makan & Minum', 'type' => 'pengeluaran'],
];

\App\Models\Wallet::create([
    'user_id' => $user->id,
    'type' => 'tunai',
    'name' => 'Dompet Utama',
    'balance' => 0,
]);

foreach ($categories as $cat) {
    \App\Models\Category::create([
        'user_id' => $user->id,
        'name' => $cat['name'],
        'type' => $cat['type'],
    ]);
}

$walletCount = Wallet::where('user_id', $user->id)->count();
echo "Registration successful. Wallets: $walletCount\n";
