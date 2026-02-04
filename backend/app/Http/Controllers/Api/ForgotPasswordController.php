<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Carbon\Carbon;

class ForgotPasswordController extends Controller
{
    public function sendResetLinkEmail(Request $request)
    {
        $request->validate(['email' => 'required|email']);
        $email = $request->email;

        $user = User::where('email', $email)->first();
        if (!$user) {
            return response()->json(['message' => 'Email tidak ditemukan'], 404);
        }

        // Generate 6-digit OTP for easier mobile usage
        $token = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);

        DB::table('password_reset_tokens')->updateOrInsert(
            ['email' => $email],
            [
                'token' => Hash::make($token),
                'created_at' => Carbon::now()
            ]
        );

        // Send Professional Email
        $messageBody = "Yth. Pengguna Monetra,\n\n"
            . "Kami menerima permintaan untuk mengatur ulang kata sandi akun Anda.\n"
            . "Gunakan kode verifikasi berikut untuk melanjutkan proses reset password:\n\n"
            . "------------------------\n"
            . "KODE OTP: $token\n"
            . "------------------------\n\n"
            . "Kode ini bersifat rahasia dan berlaku selama 60 menit ke depan.\n"
            . "Demi keamanan akun Anda, jangan bagikan kode ini kepada siapapun.\n\n"
            . "Jika Anda tidak merasa melakukan permintaan ini, silakan abaikan email ini.\n\n"
            . "Salam hangat,\n"
            . "Tim Keamanan Monetra Financial";

        Mail::raw($messageBody, function ($message) use ($email) {
            $message->to($email)->subject('[PENTING] Kode Verifikasi Reset Password Monetra');
        });

        return response()->json(['message' => 'Kode reset telah dikirim ke email Anda']);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $reset = DB::table('password_reset_tokens')->where('email', $request->email)->first();

        if (!$reset || !Hash::check($request->token, $reset->token)) {
            return response()->json(['message' => 'Kode reset salah atau sudah kedaluwarsa'], 401);
        }

        if (Carbon::parse($reset->created_at)->addMinutes(60)->isPast()) {
            return response()->json(['message' => 'Kode reset sudah kedaluwarsa'], 401);
        }

        $user = User::where('email', $request->email)->first();
        $user->password = Hash::make($request->password);
        $user->save();

        DB::table('password_reset_tokens')->where('email', $request->email)->delete();

        return response()->json(['message' => 'Password berhasil diperbarui']);
    }
}