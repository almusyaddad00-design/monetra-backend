<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\SyncController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [\App\Http\Controllers\Api\ForgotPasswordController::class, 'sendResetLinkEmail']);
Route::post('/reset-password', [\App\Http\Controllers\Api\ForgotPasswordController::class, 'resetPassword']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Sync Routes
    Route::post('/sync/push', [SyncController::class, 'pushSync']);
    Route::get('/sync/pull', [SyncController::class, 'pullSync']);

    // PIN Routes
    Route::post('/update-pin', [AuthController::class, 'updatePin']);
    Route::post('/verify-pin', [AuthController::class, 'verifyPin']);

    // Standard Resources (Optional if purely sync-based, but good to have)
    Route::apiResource('wallets', \App\Http\Controllers\Api\WalletController::class);
    Route::apiResource('categories', \App\Http\Controllers\Api\CategoryController::class);
    Route::apiResource('transactions', \App\Http\Controllers\Api\TransactionController::class);
    Route::apiResource('bills', \App\Http\Controllers\Api\BillController::class);

    // UMKM Routes
    Route::get('/umkm/sales', [\App\Http\Controllers\Api\UmkmController::class, 'getSales']);
    Route::post('/umkm/sales', [\App\Http\Controllers\Api\UmkmController::class, 'storeSale']);
    Route::get('/umkm/debts', [\App\Http\Controllers\Api\UmkmController::class, 'getDebts']);
    Route::post('/umkm/debts', [\App\Http\Controllers\Api\UmkmController::class, 'storeDebt']);
});
