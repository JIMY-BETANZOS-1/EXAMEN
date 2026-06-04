class Proveedor {
  final int id;
  final String nombre;
  final String ruc;
  final String telefono;
  final bool isSynced;
  final int? serverId;

  Proveedor(this.id, this.nombre, this.ruc, this.telefono,
      {this.isSynced = false, this.serverId});

  factory Proveedor.fromMap(Map<String, dynamic> map) {
    return Proveedor(
      map['id'],
      map['nombre'].toString(),
      map['ruc'].toString(),
      map['telefono'].toString(),
      isSynced: map['is_synced'] == 1,
      serverId: map['server_id'] as int?,
    );
  }

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      json['id'],
      json['nombre'].toString(),
      json['ruc'].toString(),
      json['telefono'].toString(),
      isSynced: true,
      serverId: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != 0) 'id': id,
      'nombre': nombre,
      'ruc': ruc,
      'telefono': telefono,
      'is_synced': isSynced ? 1 : 0,
      'server_id': serverId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'ruc': ruc,
      'telefono': telefono,
    };
  }
}