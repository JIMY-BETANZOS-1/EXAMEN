import 'package:flutter/material.dart';
import 'package:sales/database/database_helper.dart';
import 'package:sales/models/proveedor.dart';
import 'package:sales/services/proveedor_service.dart';

class ProveedorProvider extends ChangeNotifier {
  List<Proveedor> _proveedores = [];

  List<Proveedor> get proveedores => _proveedores;

  final DatabaseHelper _db = DatabaseHelper();
  final ProveedorService _service = ProveedorService();

  Future<void> loadAll() async {
    final rows = await _db.queryAllProveedores();
    _proveedores = rows.map((row) => Proveedor.fromMap(row)).toList();
    notifyListeners();
  }

  Future<void> save(Proveedor proveedor) async {
    await _db.insertProveedor(proveedor.toMap());
    await loadAll();
  }

  Future<void> edit(int id, Proveedor proveedor) async {
    await _db.updateProveedor(id, {
      'nombre': proveedor.nombre,
      'ruc': proveedor.ruc,
      'telefono': proveedor.telefono,
      'is_synced': 0,
      'server_id': proveedor.serverId,
    });
    await loadAll();
  }

  Future<void> delete(Proveedor proveedor) async {
    if (proveedor.isSynced && proveedor.serverId != null) {
      await _service.delete(proveedor.serverId!);
    }
    await _db.deleteProveedor(proveedor.id);
    await loadAll();
  }

  Proveedor getById(int id) {
    return _proveedores.firstWhere((p) => p.id == id);
  }

  Future<Map<String, int>> sincronizar() async {
    final rows = await _db.queryPendingProveedores();
    final pending = rows.map((row) => Proveedor.fromMap(row)).toList();

    int sincronizados = 0;
    int errores = 0;

    for (final proveedor in pending) {
      if (proveedor.serverId == null) {
        final (result, serverId) = await _service.save(proveedor);
        if (result == ProveedorSyncResult.created && serverId != null) {
          await _db.updateProveedorSynced(proveedor.id, serverId);
          sincronizados++;
        } else {
          errores++;
        }
      } else {
        final result = await _service.edit(proveedor);
        if (result == ProveedorSyncResult.updated) {
          await _db.updateProveedorSynced(proveedor.id, proveedor.serverId!);
          sincronizados++;
        } else {
          errores++;
        }
      }
    }

    await loadAll();
    return {'sincronizados': sincronizados, 'errores': errores};
  }
}