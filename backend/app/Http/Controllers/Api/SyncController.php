<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Wallet;
use App\Models\Category;
use App\Models\Transaction;
use App\Models\Bill;
use App\Models\UmkmSale;
use App\Models\UmkmDebt;

class SyncController extends Controller
{
    public function pushSync(Request $request)
    {
        // Expecting data in format: { "transactions": [...], "wallets": [...] }
        $data = $request->all();
        $user = $request->user();

        DB::transaction(function () use ($data, $user) {
            if (isset($data['wallets'])) {
                foreach ($data['wallets'] as $record) {
                    $record['user_id'] = $user->id;
                    Wallet::upsert($record, ['id'], ['name', 'type', 'balance', 'updated_at']);
                }
            }
            if (isset($data['categories'])) {
                foreach ($data['categories'] as $record) {
                    $record['user_id'] = $user->id;
                    Category::upsert($record, ['id'], ['name', 'type', 'updated_at']);
                }
            }
            if (isset($data['transactions'])) {
                foreach ($data['transactions'] as $record) {
                    $record['user_id'] = $user->id;
                    Transaction::upsert($record, ['id'], ['wallet_id', 'category_id', 'type', 'amount', 'date', 'note', 'updated_at']);
                }
            }
            if (isset($data['bills'])) {
                foreach ($data['bills'] as $record) {
                    $record['user_id'] = $user->id;
                    Bill::upsert($record, ['id'], ['title', 'amount', 'due_date', 'repeat_cycle', 'status', 'updated_at']);
                }
            }
            if (isset($data['umkm_sales'])) {
                foreach ($data['umkm_sales'] as $record) {
                    $record['user_id'] = $user->id;
                    UmkmSale::upsert($record, ['id'], ['customer_name', 'amount', 'date', 'updated_at']);
                }
            }
            if (isset($data['umkm_debts'])) {
                foreach ($data['umkm_debts'] as $record) {
                    $record['user_id'] = $user->id;
                    UmkmDebt::upsert($record, ['id'], ['name', 'type', 'amount', 'due_date', 'is_paid', 'updated_at']);
                }
            }
        });

        return response()->json(['status' => 'success', 'message' => 'Data synced successfully']);
    }

    public function pullSync(Request $request)
    {
        $lastSyncTime = $request->query('last_sync_time');
        $user = $request->user();

        $response = [];

        if ($lastSyncTime) {
            $response['wallets'] = Wallet::where('user_id', $user->id)->where('updated_at', '>', $lastSyncTime)->get();
            $response['categories'] = Category::where('user_id', $user->id)->where('updated_at', '>', $lastSyncTime)->get();
            $response['transactions'] = Transaction::where('user_id', $user->id)->where('updated_at', '>', $lastSyncTime)->get();
            $response['bills'] = Bill::where('user_id', $user->id)->where('updated_at', '>', $lastSyncTime)->get();
            $response['umkm_sales'] = UmkmSale::where('user_id', $user->id)->where('updated_at', '>', $lastSyncTime)->get();
            $response['umkm_debts'] = UmkmDebt::where('user_id', $user->id)->where('updated_at', '>', $lastSyncTime)->get();
        } else {
            // Initial sync, get everything
            $response['wallets'] = Wallet::where('user_id', $user->id)->get();
            $response['categories'] = Category::where('user_id', $user->id)->get();
            $response['transactions'] = Transaction::where('user_id', $user->id)->get();
            $response['bills'] = Bill::where('user_id', $user->id)->get();
            $response['umkm_sales'] = UmkmSale::where('user_id', $user->id)->get();
            $response['umkm_debts'] = UmkmDebt::where('user_id', $user->id)->get();
        }

        return response()->json([
            'status' => 'success',
            'data' => $response,
            'server_time' => now()
        ]);
    }
}
