import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales/providers/venta_provider.dart';
import 'package:sales/screens/venta/form.dart';

class VentaListScreen extends StatefulWidget {
  const VentaListScreen({super.key});

  @override
  State<VentaListScreen> createState() => _VentaListScreenState();
}

class _VentaListScreenState extends State<VentaListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VentaProvider>().loadAll();
    context.read<VentaProvider>().loadDropdowns();
  }

  @override
  Widget build(BuildContext context) {
    final ventas = context.watch<VentaProvider>().ventas;
    final provider = context.watch<VentaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Ventas'),
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VentaFormScreen()),
          );
          context.read<VentaProvider>().loadAll();
        },
        child: const Icon(Icons.add),
      ),
      body: ventas.isEmpty
          ? const Center(child: Text('No hay ventas registradas'))
          : ListView.builder(
        itemCount: ventas.length,
        itemBuilder: (context, index) {
          final v = ventas[index];
          final clienteNombre = v.clienteNombre ??
              provider.getClienteNombre(v.clienteId);
          final productoNombre = v.productoNombre ??
              provider.getProductoNombre(v.productoId);
          return ListTile(
            leading: const Icon(Icons.receipt, color: Colors.orange),
            title: Text('Fecha: ${v.fecha}  |  Total: S/ ${v.total.toStringAsFixed(2)}'),
            subtitle: Text(
              'Cliente: $clienteNombre\nProducto: $productoNombre',
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}