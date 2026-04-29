class TransaccionModel {
  final String? id;
  final String concepto;
  final String tipo; // 'ingreso' o 'egreso'
  final double monto;
  final String fecha;

  TransaccionModel({
    this.id,
    required this.concepto,
    required this.tipo,
    required this.monto,
    required this.fecha,
  });

  factory TransaccionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return TransaccionModel(
      id: id ?? json['id'],
      concepto: json['concepto'] ?? '',
      tipo: json['tipo'] ?? 'ingreso',
      monto: (json['monto'] ?? 0).toDouble(),
      fecha: json['fecha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'concepto': concepto,
      'tipo': tipo,
      'monto': monto,
      'fecha': fecha,
    };
  }
}