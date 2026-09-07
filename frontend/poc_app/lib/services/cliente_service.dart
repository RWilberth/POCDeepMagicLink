import '../models/cliente.dart';
import 'api_client.dart';

class ClienteService {
  final ApiClient apiClient;

  ClienteService(this.apiClient);

  Future<List<Cliente>> getAll() async {
    final data = await apiClient.get('/api/clientes');
    return (data as List).map((e) => Cliente.fromJson(e)).toList();
  }

  Future<Cliente> create(Cliente cliente) async {
    final data = await apiClient.post('/api/clientes', cliente.toJson());
    return Cliente.fromJson(data);
  }

  Future<Cliente> update(int id, Cliente cliente) async {
    final data = await apiClient.put('/api/clientes/$id', cliente.toJson());
    return Cliente.fromJson(data);
  }

  Future<void> delete(int id) async {
    await apiClient.delete('/api/clientes/$id');
  }
}
