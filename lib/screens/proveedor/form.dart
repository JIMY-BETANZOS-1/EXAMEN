import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales/models/proveedor.dart';
import 'package:sales/providers/proveedor_provider.dart';

class ProveedorFormScreen extends StatefulWidget {
  final Proveedor? proveedor;

  const ProveedorFormScreen({super.key, this.proveedor});

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends State<ProveedorFormScreen> {
  final _controllerNombre = TextEditingController();
  final _controllerRuc = TextEditingController();
  final _controllerTelefono = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = widget.proveedor;
    if (p != null) {
      _controllerNombre.text = p.nombre;
      _controllerRuc.text = p.ruc;
      _controllerTelefono.text = p.telefono;
    }
  }

  @override
  void dispose() {
    _controllerNombre.dispose();
    _controllerRuc.dispose();
    _controllerTelefono.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_controllerNombre.text.isEmpty ||
        _controllerRuc.text.isEmpty ||
        _controllerTelefono.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son requeridos')),
      );
      return;
    }

    final nuevo = Proveedor(
      widget.proveedor?.id ?? 0,
      _controllerNombre.text.trim(),
      _controllerRuc.text.trim(),
      _controllerTelefono.text.trim(),
      isSynced: false,
      serverId: widget.proveedor?.serverId,
    );

    if (widget.proveedor == null) {
      await context.read<ProveedorProvider>().save(nuevo);
    } else {
      await context.read<ProveedorProvider>().edit(widget.proveedor!.id, nuevo);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.proveedor == null ? 'Nuevo Proveedor' : 'Editar Proveedor'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerNombre,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controllerRuc,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'RUC',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controllerTelefono,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  widget.proveedor == null ? 'Crear' : 'Guardar cambios',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}