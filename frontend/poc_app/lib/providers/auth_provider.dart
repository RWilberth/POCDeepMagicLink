import 'package:flutter/foundation.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient apiClient;
  late final AuthService _authService;

  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _errorMessage;

  AuthProvider(this.apiClient) {
    _authService = AuthService(apiClient);
    _init();
  }

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _init() async {
    await apiClient.loadToken();
    _isAuthenticated = apiClient.hasToken;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _errorMessage = null;
    try {
      await _authService.login(email, password);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } on UnauthorizedException {
      _errorMessage = 'Correo o contraseña incorrectos';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'No se pudo conectar con el servidor';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  void sessionExpired() {
    _isAuthenticated = false;
    apiClient.clearToken();
    notifyListeners();
  }
}
