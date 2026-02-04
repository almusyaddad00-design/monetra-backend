import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(
      String name, String email, String password, String? pin);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<User> getProfile();
  Future<void> setToken(String token);
  Future<void> updatePin(String pin);
  Future<void> verifyPin(String pin);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String token, String password);
}
