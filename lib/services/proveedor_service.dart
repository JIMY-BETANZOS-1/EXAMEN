import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sales/config/app_config.dart';
import 'package:sales/models/proveedor.dart';

enum ProveedorSyncResult { created, updated, duplicate, error }

class ProveedorService {
  final String apiUrl = AppConfig.apiUrl;

  Future<List<Proveedor>> all() async {
    var url = Uri.http(apiUrl, '/supplier/suppliers/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      return jsonResponse.map((j) => Proveedor.fromJson(j)).toList();
    } else {
      throw Exception('Error al cargar proveedores');
    }
  }

  Future<(ProveedorSyncResult, int?)> save(Proveedor proveedor) async {
    var url = Uri.http(apiUrl, '/supplier/suppliers/');
    var response = await http.post(
      url,
      body: convert.jsonEncode(proveedor.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final json = convert.jsonDecode(response.body);
      return (ProveedorSyncResult.created, json['id'] as int);
    }
    if (response.statusCode == 400) return (ProveedorSyncResult.duplicate, null);
    return (ProveedorSyncResult.error, null);
  }

  Future<ProveedorSyncResult> edit(Proveedor proveedor) async {
    var url = Uri.http(apiUrl, '/supplier/suppliers/${proveedor.serverId}/');
    var response = await http.put(
      url,
      body: convert.jsonEncode(proveedor.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) return ProveedorSyncResult.updated;
    return ProveedorSyncResult.error;
  }

  Future<void> delete(int serverId) async {
    var url = Uri.http(apiUrl, '/supplier/suppliers/$serverId/');
    var response = await http.delete(url);
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar proveedor');
    }
  }
}