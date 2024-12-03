class Medicine {
  final String nombreComercial;
  final String principioActivo;
  final String titular;
  final String registroSanitario;
  final String formaFarmaceutica;
  final String presentacionComercial;
  final String estadoRegistro;
  final String fechaVencimiento;
  final String modalidad;

  Medicine({
    required this.nombreComercial,
    required this.principioActivo,
    required this.titular,
    required this.registroSanitario,
    required this.formaFarmaceutica,
    required this.presentacionComercial,
    required this.estadoRegistro,
    required this.fechaVencimiento,
    required this.modalidad,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      nombreComercial: json['nombre_comercial'] ?? 'No disponible',
      principioActivo: json['principio_activo'] ?? 'No disponible',
      titular: json['titular'] ?? 'No disponible',
      registroSanitario: json['registro_sanitario'] ?? 'No disponible',
      formaFarmaceutica: json['forma_farmaceutica'] ?? 'No disponible',
      presentacionComercial: json['presentacion_comercial'] ?? 'No disponible',
      estadoRegistro: json['estado_registro'] ?? 'No disponible',
      fechaVencimiento: json['fecha_vencimiento'] ?? 'No disponible',
      modalidad: json['modalidad'] ?? 'No disponible',
    );
  }
}