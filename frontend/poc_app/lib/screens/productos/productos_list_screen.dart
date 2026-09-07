import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/producto_service.dart';
import '../login_screen.dart';
import 'producto_form_screen.dart';

class ProductosListScreen extends StatefulWidget {
  const ProductosListScreen({super.key});

  @override
  State<ProductosListScreen> createState() => _ProductosListScreenState();
}

class _ProductosListScreenState extends State<ProductosListScreen> {
  late final ProductoService _service;
  late Future<List<Producto>> _future;

  @override
  void initState() {
    super.initState();
    _service = ProductoService(context.read<AuthProvider>().apiClient);
    _future = _load();
  }

  Future<List<Producto>> _load() async {
    try {
      return await _service.getAll();
    } on UnauthorizedException {
      _handleSessionExpired();
      return [];
    }
  }

  void _handleSessionExpired() {
    context.read<AuthProvider>().sessionExpired();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    });
  }

  void _refresh() {
    setState(() => _future = _load());
  }

  Future<void> _openForm({Producto? producto}) async {
    final result = await Navigator.of(context).push<Producto>(
      MaterialPageRoute(builder: (_) => ProductoFormScreen(producto: producto)),
    );
    if (result == null) return;

    try {
      if (producto == null) {
        await _service.create(result);
      } else {
        await _service.update(producto.id!, result);
      }
      _refresh();
    } on UnauthorizedException {
      _handleSessionExpired();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _delete(Producto producto) async {
    try {
      await _service.delete(producto.id!);
      _refresh();
    } on UnauthorizedException {
      _handleSessionExpired();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<List<Producto>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final productos = snapshot.data ?? [];
          if (productos.isEmpty) {
            return const Center(child: Text('No hay productos registrados'));
          }
          return ListView.separated(
            itemCount: productos.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final p = productos[index];
              return ListTile(
                title: Text(p.nombre),
                subtitle: Text('${p.descripcion}\nPrecio: \$${p.precio.toStringAsFixed(2)} · Stock: ${p.stock}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _openForm(producto: p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(p),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
