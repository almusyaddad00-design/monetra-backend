<?php
require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\Wallet;
use App\Models\Transaction;
use App\Models\UmkmSale;
use App\Models\UmkmDebt;
use App\Models\Bill;

$email = 'almusyaddad00@gmail.com';
$user = User::where('email', $email)->first();

if (!$user) {
    echo "User $email not found.\n";
    $allUsers = User::pluck('email')->toArray();
    echo "Existing users: " . implode(', ', $allUsers) . "\n";
    exit;
}

echo "User found: " . $user->name . " (ID: " . $user->id . ")\n";
echo "Wallets: " . Wallet::where('user_id', $user->id)->count() . "\n";
foreach (Wallet::where('user_id', $user->id)->get() as $w) {
    echo " - " . $w->name . ": " . $w->balance . "\n";
}
echo "Transactions: " . Transaction::where('user_id', $user->id)->count() . "\n";
echo "UMKM Sales: " . UmkmSale::where('user_id', $user->id)->count() . "\n";
echo "UMKM Debts: " . UmkmDebt::where('user_id', $user->id)->count() . "\n";
echo "Bills: " . Bill::where('user_id', $user->id)->count() . "\n";
