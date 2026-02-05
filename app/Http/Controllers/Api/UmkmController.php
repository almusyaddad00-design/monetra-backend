<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UmkmDebt;
use App\Models\UmkmSale;
use Illuminate\Http\Request;

class UmkmController extends Controller
{
    public function getSales(Request $request)
    {
        return response()->json($request->user()->umkmSales()->latest()->get());
    }

    public function storeSale(Request $request)
    {
        $request->validate([
            'customer_name' => 'required|string',
            'amount' => 'required|numeric',
            'date' => 'required|date',
        ]);

        $sale = $request->user()->umkmSales()->create($request->all());

        return response()->json($sale, 201);
    }

    public function getDebts(Request $request)
    {
        return response()->json($request->user()->umkmDebts()->latest()->get());
    }

    public function storeDebt(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'type' => 'required|in:hutang,piutang',
            'amount' => 'required|numeric',
            'due_date' => 'required|date',
        ]);

        $debt = $request->user()->umkmDebts()->create($request->all());

        return response()->json($debt, 201);
    }
}
