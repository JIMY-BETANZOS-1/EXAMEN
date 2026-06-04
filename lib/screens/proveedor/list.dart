import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales/providers/proveedor_provider.dart';
import 'package:sales/screens/proveedor/detail.dart';
import 'package:sales/screens/proveedor/form.dart';

class ProveedorListScreen extends StatefulWidget {
  const ProveedorListScreen({super.key});

  @override
  State<ProveedorListScreen> createState() => _ProveedorListScreenState();
}

class _ProveedorListScreenState extends State<ProveedorListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProveedorProvider>().loadAll();
  }

  Future<void> _sincronizar() async {
    final resultado = await context.read<ProveedorProvider>().sincronizar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sincronizados: ${resultado['sincronizados']}  |  Errores: ${resultado['errores']}',
        ),
        backgroundColor:
        resultado['errores']! > 0 ? Colors.orange : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final proveedores = context.watch<ProveedorProvider>().proveedores;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Proveedores'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sincronizar',
            onPressed: _sincronizar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProveedorFormScreen()),
          );
          context.read<ProveedorProvider>().loadAll();
        },
        child: const Icon(Icons.add),
      ),
      body: proveedores.isEmpty
          ? const Center(child: Text('No hay proveedores registrados'))
          : ListView.builder(
        itemCount: proveedores.length,
        itemBuilder: (context, index) {
          final p = proveedores[index];
          return ListTile(
            leading: Icon(
              p.isSynced ? Icons.cloud_done : Icons.cloud_off,
              color: p.isSynced ? Colors.green : Colors.orange,
            ),
            title: Text(p.nombre),
            subtitle: Text('RUC: ${p.ruc} | Tel: ${p.telefono}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: p.isSynced ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                p.isSynced ? 'sincronizado' : 'pendiente',
                style: TextStyle(
                  fontSize: 11,
                  color: p.isSynced ? Colors.green[800] : Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProveedorDetailScreen(proveedorId: p.id),
                ),
              );
              context.read<ProveedorProvider>().loadAll();
            },
          );
        },
      ),
    );
  }
}