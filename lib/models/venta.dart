class Venta {
  final int id;
  final String fecha;
  final double total;
  final int clienteId;
  final int productoId;
  final String? clienteNombre;
  final String? productoNombre;

  Venta(this.id, this.fecha, this.total, this.clienteId, this.productoId,
      this.clienteNombre, this.productoNombre);

  factory Venta.fromJson(Map<String, dynamic> json) {
    final details = json['details'] as List<dynamic>?;
    int primerProductoId = 0;
    String? primerProductoNombre;
    if (details != null && details.isNotEmpty) {
      primerProductoId = details[0]['product']['id'] as int? ?? 0;
      primerProductoNombre = details[0]['product']['name']?.toString();
    }
    return Venta(
      json['id'] as int,
      json['created_at']?.toString().substring(0, 10) ?? '',
      double.parse(json['total'].toString()),
      json['client']['id'] as int? ?? 0,
      primerProductoId,
      json['client']['name']?.toString(),
      primerProductoNombre,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client': clienteId,
      'details': [
        {'product': productoId, 'quantity': 1}
      ]
    };
  }
}