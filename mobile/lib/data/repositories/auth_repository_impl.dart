import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../../core/utils/shared_prefs_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SharedPrefsService _sharedPrefsService;

  AuthRepositoryImpl(this._remoteDatasource, this._sharedPrefsService);

  @override
  Future<User> login(String email, String password) async {
    return await _remoteDatasource.login(email, password);
  }

  @override
  Future<User> register(
      String name, String email, String password, String? pin) async {
    return await _remoteDatasource.register(name, email, password, pin);
  }

  @override
  Future<void> logout() async {
    await _remoteDatasource.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _sharedPrefsService.getToken() != null;
  }

  @override
  Future<User> getProfile() async {
    return await _remoteDatasource.getProfile();
  }

  @override
  Future<void> setToken(String token) async {
    await _sharedPrefsService.saveToken(token);
  }

  @override
  Future<void> updatePin(String pin) async {
    await _remoteDatasource.updatePin(pin);
  }

  @override
  Future<void> verifyPin(String pin) async {
    await _remoteDatasource.verifyPin(pin);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _remoteDatasource.forgotPassword(email);
  }

  @override
  Future<void> resetPassword(
      String email, String token, String password) async {
    await _remoteDatasource.resetPassword(email, token, password);
  }
}
