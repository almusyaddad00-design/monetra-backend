<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'email' => 'required|string|email|unique:users',
            'password' => 'required|string|min:6',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'pin' => $request->pin,
        ]);

        // Initialize Default User Data (Empty but ready)
        $this->initializeDefaultData($user);


        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user,
        ]);
    }

    public function login(Request $request)
    {
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['message' => 'Invalid login details'], 401);
        }

        $user = User::where('email', $request['email'])->firstOrFail();
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out successfully']);
    }

    public function updatePin(Request $request)
    {
        $request->validate([
            'pin' => 'required|string|size:6',
        ]);

        $user = $request->user();
        $user->pin = $request->pin;
        $user->save();

        return response()->json(['message' => 'PIN updated successfully']);
    }

    public function verifyPin(Request $request)
    {
        $request->validate([
            'pin' => 'required|string|size:6',
        ]);

        $user = $request->user();
        if ($user->pin === $request->pin) {
            return response()->json(['message' => 'PIN verified']);
        }

        return response()->json(['message' => 'PIN incorrect'], 401);
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

