import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales/config/app_config.dart';
import 'package:sales/models/client.dart';
import 'package:sales/models/product.dart';
import 'package:sales/models/venta.dart';
import 'package:sales/services/venta_service.dart';

class VentaProvider extends ChangeNotifier {
  List<Venta> _ventas = [];
  List<Client> _clientes = [];
  List<Product> _productos = [];

  List<Venta> get ventas => _ventas;
  List<Client> get clientes => _clientes;
  List<Product> get productos => _productos;

  final VentaService _service = VentaService();
  final String _apiUrl = AppConfig.apiUrl;

  Future<void> loadAll() async {
    _ventas = await _service.all();
    notifyListeners();
  }

  Future<void> loadClientes() async {
    var url = Uri.http(_apiUrl, '/client/clients/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      _clientes = jsonResponse.map((j) => Client(
        j['id'],
        j['name'].toString(),
        j['document_number']?.toString() ?? '',
        true,
        j['id'],
      )).toList();
      notifyListeners();
    }
  }

  Future<void> loadProductos() async {
    var url = Uri.http(_apiUrl, '/product/products/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      _productos = jsonResponse.map((j) => Product.fromJson(j)).toList();
      notifyListeners();
    }
  }

  Future<void> loadDropdowns() async {
    await Future.wait([loadClientes(), loadProductos()]);
  }

  Future<void> save(Venta venta) async {
    await _service.save(venta);
    await loadAll();
  }

  Future<void> edit(int id, Venta venta) async {
    await _service.edit(id, venta);
    await loadAll();
  }

  Future<void> delete(int id) async {
    await _service.delete(id);
    await loadAll();
  }

  String getClienteNombre(int clienteId) {
    try {
      return _clientes.firstWhere((c) => c.id == clienteId).name;
    } catch (_) {
      return 'Cliente #$clienteId';
    }
  }

  String getProductoNombre(int productoId) {
    try {
      return _productos.firstWhere((p) => p.id == productoId).name;
    } catch (_) {
      return 'Producto #$productoId';
    }
  }
}