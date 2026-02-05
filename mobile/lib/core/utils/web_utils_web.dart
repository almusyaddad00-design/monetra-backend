import 'package:web/web.dart' as web;

String? getWebToken() {
  final uri = Uri.parse(web.window.location.href);
  return uri.queryParameters['token'];
}

void cleanWebUrl() {
  web.window.history.replaceState(null, 'Login', '/#/login');
}

void redirectToGoogleAuth() {
  web.window.location.href = 'http://127.0.0.1:8000/auth/google';
}
