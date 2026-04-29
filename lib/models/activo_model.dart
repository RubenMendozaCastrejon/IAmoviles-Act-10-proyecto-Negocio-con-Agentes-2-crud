class ActivoModel {
  final String? id;
  final String nombre;
  final String tipo;
  final double valor;
  final String descripcion;

  ActivoModel({
    this.id,
    required this.nombre,
    required this.tipo,
    required this.valor,
    required this.descripcion,
  });

  factory ActivoModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ActivoModel(
      id: id ?? json['id'],
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      descripcion: json['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'valor': valor,
      'descripcion': descripcion,
    };
  }
}