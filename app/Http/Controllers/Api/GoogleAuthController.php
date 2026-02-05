<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class GoogleAuthController extends Controller
{
    public function redirectToGoogle()
    {
        return Socialite::driver('google')->stateless()->redirect();
    }

    public function handleGoogleCallback()
    {
        try {
            $googleUser = Socialite::driver('google')->stateless()->user();

            $user = User::where('email', $googleUser->getEmail())->first();

            if (!$user) {
                $user = User::create([
                    'name' => $googleUser->getName(),
                    'email' => $googleUser->getEmail(),
                    'google_id' => $googleUser->getId(),
                    'avatar' => $googleUser->getAvatar(),
                    'password' => null, // No password for google users
                ]);

                // Initialize default data for new user
                $this->initializeDefaultData($user);
            } else {
                // Update google id and avatar if existing user
                $user->update([
                    'google_id' => $googleUser->getId(),
                    'avatar' => $googleUser->getAvatar(),
                ]);
            }

            $token = $user->createToken('google_auth_token')->plainTextToken;

            // For Flutter Web development, redirecting with token in fragment or query
// In production, you'd use a deep link or a more secure way
            return redirect('http://localhost:8080/#/login?token=' . $token);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Authentication failed: ' . $e->getMessage()], 401);
        }
    }

    private function initializeDefaultData(User $user)
    {
        // 1. Create Default Wallet
        \App\Models\Wallet::create([
            'user_id' => $user->id,
            'type' => 'tunai',
            'name' => 'Dompet Utama',
            'balance' => 0,
        ]);

        // 2. Create Essential Categories
        $categories = [
            ['name' => 'Pendapatan', 'type' => 'pemasukan'],
            ['name' => 'Makan & Minum', 'type' => 'pengeluaran'],
            ['name' => 'Transportasi', 'type' => 'pengeluaran'],
            ['name' => 'Kebutuhan Rumah', 'type' => 'pengeluaran'],
            ['name' => 'Hiburan', 'type' => 'pengeluaran'],
        ];

        foreach ($categories as $cat) {
            \App\Models\Category::create([
                'user_id' => $user->id,
                'name' => $cat['name'],
                'type' => $cat['type'],
            ]);
        }
    }
}