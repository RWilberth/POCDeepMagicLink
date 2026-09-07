import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cliente.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/cliente_service.dart';
import '../login_screen.dart';
import 'cliente_form_screen.dart';

class ClientesListScreen extends StatefulWidget {
  const ClientesListScreen({super.key});

  @override
  State<ClientesListScreen> createState() => _ClientesListScreenState();
}

class _ClientesListScreenState extends State<ClientesListScreen> {
  late final ClienteService _service;
  late Future<List<Cliente>> _future;

  @override
  void initState() {
    super.initState();
    _service = ClienteService(context.read<AuthProvider>().apiClient);
    _future = _load();
  }

  Future<List<Cliente>> _load() async {
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

  Future<void> _openForm({Cliente? cliente}) async {
    final result = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(builder: (_) => ClienteFormScreen(cliente: cliente)),
    );
    if (result == null) return;

    try {
      if (cliente == null) {
        await _service.create(result);
      } else {
        await _service.update(cliente.id!, result);
      }
      _refresh();
    } on UnauthorizedException {
      _handleSessionExpired();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _delete(Cliente cliente) async {
    try {
      await _service.delete(cliente.id!);
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
      appBar: AppBar(title: const Text('Clientes')),
      body: FutureBuilder<List<Cliente>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final clientes = snapshot.data ?? [];
          if (clientes.isEmpty) {
            return const Center(child: Text('No hay clientes registrados'));
          }
          return ListView.separated(
            itemCount: clientes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final c = clientes[index];
              return ListTile(
                title: Text(c.nombre),
                subtitle: Text('${c.email}\n${c.telefono} · ${c.direccion}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _openForm(cliente: c),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(c),
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
