class TipoMezzoSpecifiche {
  final int id;
  final String descrizione;
  final int tipoGrandezzaId;
  final double valoreMax;
  final double valoreMin;
  final int step;
  final String? descrizioneEn;
  final String? descrizioneRo;
  final List<dynamic> specificheOrdini;
  final List<dynamic> automezzoSpecifiche;

  TipoMezzoSpecifiche({
    required this.id,
    required this.descrizione,
    required this.tipoGrandezzaId,
    required this.valoreMax,
    required this.valoreMin,
    required this.step,
    required this.descrizioneEn,
    required this.descrizioneRo,
    required this.specificheOrdini,
    required this.automezzoSpecifiche,
  });

  factory TipoMezzoSpecifiche.fromJson(Map<String, dynamic> json) {
    return TipoMezzoSpecifiche(
      id: json['id'],
      descrizione: json['descrizione'],
      tipoGrandezzaId: json['tipoGrandezzaId'],
      valoreMax: json['valoreMax'].toDouble(),
      valoreMin: json['valoreMin'].toDouble(),
      step: json['step'],
      descrizioneEn: json['descrizioneEn'],
      descrizioneRo: json['descrizioneRo'],
      specificheOrdini: List<dynamic>.from(json['specificheOrdini'] ?? []),
      automezzoSpecifiche: List<dynamic>.from(json['automezzoSpecifiche'] ?? []),
    );
  }
}
