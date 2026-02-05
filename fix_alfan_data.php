<?php
require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\Wallet;
use App\Models\Category;

$email = 'almusyaddad00@gmail.com';
$user = User::where('email', $email)->first();

if (!$user) {
    echo "User not found.\n";
    exit;
}

if (Wallet::where('user_id', $user->id)->count() == 0) {
    echo "Initializing data for " . $user->email . "...\n";
    Wallet::create([
        'user_id' => $user->id,
        'type' => 'tunai',
        'name' => 'Dompet Utama',
        'balance' => 0,
    ]);

    $categories = [
        ['name' => 'Pendapatan', 'type' => 'pemasukan'],
        ['name' => 'Makan & Minum', 'type' => 'pengeluaran'],
        ['name' => 'Transportasi', 'type' => 'pengeluaran'],
        ['name' => 'Kebutuhan Rumah', 'type' => 'pengeluaran'],
        ['name' => 'Hiburan', 'type' => 'pengeluaran'],
    ];

    foreach ($categories as $cat) {
        Category::create([
            'user_id' => $user->id,
            'name' => $cat['name'],
            'type' => $cat['type'],
        ]);
    }
    echo "Done.\n";
} else {
    echo "User already has data.\n";
}
