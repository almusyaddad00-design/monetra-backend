<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Wallet;
use Illuminate\Http\Request;

class WalletController extends Controller
{
    public function index(Request $request)
    {
        return $request->user()->wallets;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'type' => 'required|string',
            'balance' => 'required|numeric',
        ]);

        $wallet = $request->user()->wallets()->create($validated);

        return response()->json($wallet, 201);
    }

    public function show(Request $request, Wallet $wallet)
    {
        if ($request->user()->id !== $wallet->user_id) {
            abort(403);
        }
        return $wallet;
    }

    public function update(Request $request, Wallet $wallet)
    {
        if ($request->user()->id !== $wallet->user_id) {
            abort(403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string',
            'type' => 'sometimes|required|string',
            'balance' => 'sometimes|required|numeric',
        ]);

        $wallet->update($validated);

        return $wallet;
    }

    public function destroy(Request $request, Wallet $wallet)
    {
        if ($request->user()->id !== $wallet->user_id) {
            abort(403);
        }

        $wallet->delete();

        return response()->noContent();
    }
}
