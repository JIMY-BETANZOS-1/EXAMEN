import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales/models/client.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/venta.dart';
import 'package:sales/providers/venta_provider.dart';

class VentaFormScreen extends StatefulWidget {
  const VentaFormScreen({super.key});

  @override
  State<VentaFormScreen> createState() => _VentaFormScreenState();
}

class _VentaFormScreenState extends State<VentaFormScreen> {
  final _controllerFecha = TextEditingController();
  Client? _selectedCliente;
  Product? _selectedProducto;

  @override
  void initState() {
    super.initState();
    _controllerFecha.text =
        DateTime.now().toIso8601String().substring(0, 10);
    context.read<VentaProvider>().loadDropdowns();
  }

  @override
  void dispose() {
    _controllerFecha.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _controllerFecha.text = picked.toIso8601String().substring(0, 10);
    }
  }

  Future<void> _guardar() async {
    if (_selectedCliente == null || _selectedProducto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona cliente y producto')),
      );
      return;
    }

    final venta = Venta(
      0,
      _controllerFecha.text.trim(),
      0,
      _selectedCliente!.id,
      _selectedProducto!.id,
      _selectedCliente!.name,
      _selectedProducto!.name,
    );

    await context.read<VentaProvider>().save(venta);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final clientes = context.watch<VentaProvider>().clientes;
    final productos = context.watch<VentaProvider>().productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Venta'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fecha
            TextField(
              controller: _controllerFecha,
              readOnly: true,
              onTap: _selectDate,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 12),
            // Dropdown Clientes
            clientes.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<Client>(
              value: _selectedCliente,
              hint: const Text('Seleccionar Cliente'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: clientes
                  .map((c) => DropdownMenuItem<Client>(
                value: c,
                child: Text(c.name),
              ))
                  .toList(),
              onChanged: (c) => setState(() => _selectedCliente = c),
            ),
            const SizedBox(height: 12),
            // Dropdown Productos
            productos.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<Product>(
              value: _selectedProducto,
              hint: const Text('Seleccionar Producto'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: productos
                  .map((p) => DropdownMenuItem<Product>(
                value: p,
                child: Text(p.name),
              ))
                  .toList(),
              onChanged: (p) => setState(() => _selectedProducto = p),
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
                child: const Text(
                  'Crear Venta',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}