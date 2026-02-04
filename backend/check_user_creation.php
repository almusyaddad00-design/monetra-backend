<?php
require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\Wallet;

$emails = ['almusyaddad00@gmail.com', 'almusyaddad00@gmail'];

foreach ($emails as $email) {
    $user = User::where('email', $email)->first();
    if ($user) {
        echo "User: $email\n";
        echo "ID: " . $user->id . "\n";
        echo "Created: " . $user->created_at . "\n";
        echo "Wallets: " . Wallet::where('user_id', $user->id)->count() . "\n";
        foreach (Wallet::where('user_id', $user->id)->get() as $w) {
            echo " - Wallet: " . $w->name . " (Balance: " . $w->balance . ")\n";
        }
    } else {
        echo "User: $email NOT FOUND\n";
    }
}
