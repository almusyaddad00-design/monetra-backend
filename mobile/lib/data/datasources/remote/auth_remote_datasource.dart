import '../../../../core/network/dio_client.dart';
import '../../models/user_model.dart';
import '../../../../core/utils/shared_prefs_service.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(
      String name, String email, String password, String? pin);
  Future<void> logout();
  Future<UserModel> getProfile();
  Future<void> updatePin(String pin);
  Future<void> verifyPin(String pin);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String token, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  final SharedPrefsService _sharedPrefsService;

  AuthRemoteDatasourceImpl(this._dioClient, this._sharedPrefsService);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['access_token'];
      await _sharedPrefsService.saveToken(token);
      return UserModel.fromJson(response.data['user']);
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<UserModel> register(
      String name, String email, String password, String? pin) async {
    try {
      final response = await _dioClient.dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'pin': pin,
      });
      final token = response.data['access_token'];
      await _sharedPrefsService.saveToken(token);
      return UserModel.fromJson(response.data['user']);
    } catch (e) {
      throw Exception('Registration Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.dio.post('/logout');
      await _sharedPrefsService.removeToken();
    } catch (e) {
      // Even if API fails, clear local token
      await _sharedPrefsService.removeToken();
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.dio.get('/user');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<void> updatePin(String pin) async {
    try {
      await _dioClient.dio.post('/update-pin', data: {'pin': pin});
    } catch (e) {
      throw Exception('Failed to update PIN: $e');
    }
  }

  @override
  Future<void> verifyPin(String pin) async {
    try {
      await _dioClient.dio.post('/verify-pin', data: {'pin': pin});
    } catch (e) {
      throw Exception('PIN Incorrect: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dioClient.dio.post('/forgot-password', data: {'email': email});
    } catch (e) {
      throw Exception('Failed to send reset link: $e');
    }
  }

  @override
  Future<void> resetPassword(
      String email, String token, String password) async {
    try {
      await _dioClient.dio.post('/reset-password', data: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': password,
      });
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}
