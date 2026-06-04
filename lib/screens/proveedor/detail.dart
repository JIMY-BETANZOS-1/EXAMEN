import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales/providers/proveedor_provider.dart';
import 'package:sales/screens/proveedor/form.dart';

class ProveedorDetailScreen extends StatelessWidget {
  final int proveedorId;

  const ProveedorDetailScreen({super.key, required this.proveedorId});

  @override
  Widget build(BuildContext context) {
    final proveedor = context.watch<ProveedorProvider>().getById(proveedorId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Proveedor'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fila('ID', proveedor.id.toString()),
            _fila('Nombre', proveedor.nombre),
            _fila('RUC', proveedor.ruc),
            _fila('Teléfono', proveedor.telefono),
            _fila('Estado', proveedor.isSynced ? 'Sincronizado ✅' : 'Pendiente ⏳'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProveedorFormScreen(proveedor: proveedor),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirmar'),
                          content: Text('¿Eliminar a "${proveedor.nombre}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (confirmar == true && context.mounted) {
                        await context.read<ProveedorProvider>().delete(proveedor);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}