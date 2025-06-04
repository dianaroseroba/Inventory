class InventoryItemModel {
  final String id;
  final String userId;
  final String tipo; // "Eje" o "Lámina"
  final DateTime fecha;

  // Campos comunes
  final int cantidad;

  // Solo para Eje
  final String? calidad;
  final double? diametro;
  final double? largoEje;

  // Solo para Lámina
  final String? tipoMaterial;
  final double? largoLamina;
  final double? ancho;
  final double? calibre;

  InventoryItemModel({
    required this.id,
    required this.userId,
    required this.tipo,
    required this.fecha,
    required this.cantidad,
    this.calidad,
    this.diametro,
    this.largoEje,
    this.tipoMaterial,
    this.largoLamina,
    this.ancho,
    this.calibre,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['\$id'] ?? '',
      userId: json['userId'],
      tipo: json['tipo'],
      fecha: DateTime.parse(json['fecha']),
      cantidad: json['cantidad'],
      calidad: json['calidad'],
      diametro: (json['diametro'] as num?)?.toDouble(),
      largoEje: (json['largoEje'] as num?)?.toDouble(),
      tipoMaterial: json['tipoMaterial'],
      largoLamina: (json['largoLamina'] as num?)?.toDouble(),
      ancho: (json['ancho'] as num?)?.toDouble(),
      calibre: (json['calibre'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tipo': tipo, // "Eje" o "Lámina"
      'fecha': fecha.toIso8601String(),
      'cantidad': cantidad,
      'calidad': calidad,
      'diametro': diametro,
      'largoEje': largoEje,
      'tipoMaterial': tipoMaterial,
      'largoLamina': largoLamina,
      'ancho': ancho,
      'calibre': calibre,
    };
  }

  InventoryItemModel copyWith({
    String? id,
    String? userId,
    String? tipo,
    DateTime? fecha,
    int? cantidad,
    String? calidad,
    double? diametro,
    double? largoEje,
    String? tipoMaterial,
    double? largoLamina,
    double? ancho,
    double? calibre,
  }) {
    return InventoryItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      cantidad: cantidad ?? this.cantidad,
      calidad: calidad ?? this.calidad,
      diametro: diametro ?? this.diametro,
      largoEje: largoEje ?? this.largoEje,
      tipoMaterial: tipoMaterial ?? this.tipoMaterial,
      largoLamina: largoLamina ?? this.largoLamina,
      ancho: ancho ?? this.ancho,
      calibre: calibre ?? this.calibre,
    );
  }
}
