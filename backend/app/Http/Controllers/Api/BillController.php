<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Bill;
use Illuminate\Http\Request;

class BillController extends Controller
{
    public function index(Request $request)
    {
        return $request->user()->bills;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string',
            'amount' => 'required|numeric',
            'due_date' => 'required|date',
            'repeat_cycle' => 'nullable|string',
            'status' => 'required|string|in:paid,unpaid,overdue',
        ]);

        $bill = $request->user()->bills()->create($validated);

        return response()->json($bill, 201);
    }

    public function show(Request $request, Bill $bill)
    {
        if ($request->user()->id !== $bill->user_id) {
            abort(403);
        }
        return $bill;
    }

    public function update(Request $request, Bill $bill)
    {
        if ($request->user()->id !== $bill->user_id) {
            abort(403);
        }

        $validated = $request->validate([
            'title' => 'sometimes|required|string',
            'amount' => 'sometimes|required|numeric',
            'due_date' => 'sometimes|required|date',
            'repeat_cycle' => 'nullable|string',
            'status' => 'sometimes|required|string|in:paid,unpaid,overdue',
        ]);

        $bill->update($validated);

        return $bill;
    }

    public function destroy(Request $request, Bill $bill)
    {
        if ($request->user()->id !== $bill->user_id) {
            abort(403);
        }

        $bill->delete();

        return response()->noContent();
    }
}
