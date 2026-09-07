import '../models/producto.dart';
import 'api_client.dart';

class ProductoService {
  final ApiClient apiClient;

  ProductoService(this.apiClient);

  Future<List<Producto>> getAll() async {
    final data = await apiClient.get('/api/productos');
    return (data as List).map((e) => Producto.fromJson(e)).toList();
  }

  Future<Producto> create(Producto producto) async {
    final data = await apiClient.post('/api/productos', producto.toJson());
    return Producto.fromJson(data);
  }

  Future<Producto> update(int id, Producto producto) async {
    final data = await apiClient.put('/api/productos/$id', producto.toJson());
    return Producto.fromJson(data);
  }

  Future<void> delete(int id) async {
    await apiClient.delete('/api/productos/$id');
  }
}
