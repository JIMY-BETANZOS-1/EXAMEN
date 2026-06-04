import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sales/config/app_config.dart';
import 'package:sales/models/venta.dart';

class VentaService {
  final String apiUrl = AppConfig.apiUrl;

  Future<List<Venta>> all() async {
    var url = Uri.http(apiUrl, '/sale/sales/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      return jsonResponse.map((j) => Venta.fromJson(j)).toList();
    } else {
      throw Exception('Error al cargar ventas');
    }
  }

  Future<void> save(Venta venta) async {
    var url = Uri.http(apiUrl, '/sale/sales/');
    var body = {
      'client': venta.clienteId,
      'details': [
        {'product': venta.productoId, 'quantity': 1}
      ]
    };
    var response = await http.post(
      url,
      body: convert.jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Error al guardar venta: ${response.body}');
    }
  }

  Future<void> edit(int id, Venta venta) async {
    // El backend no soporta edición de ventas
  }

  Future<void> delete(int id) async {
    // El backend no soporta eliminación de ventas
  }
}