import 'api_client.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<void> login(String email, String password) async {
    final data = await apiClient.post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    await apiClient.saveToken(data['token'] as String);
  }

  Future<void> logout() async {
    await apiClient.clearToken();
  }
}
