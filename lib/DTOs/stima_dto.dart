class Stima {
  final int id;
  final DateTime dataOrdine;
  final String? localitaCarico;
  final String? localitaScarico;
  final double stimaCosto;
  final double stimaMaxCosto;


  Stima({
    required this.id,
    required this.dataOrdine,
    this.localitaCarico,
    this.localitaScarico,
    required this.stimaCosto,
    required this.stimaMaxCosto,
  });

  factory Stima.fromJson(Map<String, dynamic> json) {
    return Stima(
      id: json['id'],
      dataOrdine: DateTime.parse(json['dataOrdine']),
      localitaCarico: json['localitaCarico'],
      localitaScarico: json['localitaScarico'],
      stimaCosto: json['stimaCosto'],
      stimaMaxCosto: json['stimaMaxCosto'],
      // tipoTrasportoId: json['tipoTrasportoId'], // Aggiungi se necessario
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataOrdine': dataOrdine.toIso8601String(),
      'localitaCarico': localitaCarico,
      'localitaScarico': localitaScarico,
      'stimaCosto': stimaCosto,
      'stimaMaxCosto': stimaMaxCosto,
      // 'tipoTrasportoId': tipoTrasportoId, // Aggiungi se necessario
    };
  }
}
