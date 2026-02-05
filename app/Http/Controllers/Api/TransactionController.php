<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        return Transaction::where('user_id', $request->user()->id)
            ->with(['wallet', 'category'])
            ->orderBy('date', 'desc')
            ->get();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'wallet_id' => 'required|exists:wallets,id',
            'category_id' => 'nullable|exists:categories,id',
            'type' => 'required|string|in:income,expense,transfer',
            'amount' => 'required|numeric',
            'date' => 'required|date',
            'note' => 'nullable|string',
        ]);

        // Verify wallet ownership
        $request->user()->wallets()->findOrFail($validated['wallet_id']);

        if (isset($validated['category_id'])) {
            $request->user()->categories()->findOrFail($validated['category_id']);
        }

        $transaction = $request->user()->transactions()->create($validated);

        // Update Wallet Balance logic could go here or in a Service/Observer
        // keeping it simple for now, assuming Sync engine or manual balance updates

        return response()->json($transaction, 201);
    }

    public function show(Request $request, Transaction $transaction)
    {
        if ($request->user()->id !== $transaction->user_id) {
            abort(403);
        }
        return $transaction->load(['wallet', 'category']);
    }

    public function update(Request $request, Transaction $transaction)
    {
        if ($request->user()->id !== $transaction->user_id) {
            abort(403);
        }

        $validated = $request->validate([
            'wallet_id' => 'sometimes|required|exists:wallets,id',
            'category_id' => 'nullable|exists:categories,id',
            'type' => 'sometimes|required|string|in:income,expense,transfer',
            'amount' => 'sometimes|required|numeric',
            'date' => 'sometimes|required|date',
            'note' => 'nullable|string',
        ]);

        $transaction->update($validated);

        return $transaction;
    }

    public function destroy(Request $request, Transaction $transaction)
    {
        if ($request->user()->id !== $transaction->user_id) {
            abort(403);
        }

        $transaction->delete();

        return response()->noContent();
    }
}
