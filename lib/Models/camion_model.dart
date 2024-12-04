class Camion {
  final int? id;
  final String tipoMezzo;
  final String spazioDisponibile;
  final String? localitaCarico;
  final DateTime dataRitiro;
  final String? localitaScarico;
  final bool isRecurring;
  final Map<String, bool>? giorniDisponibili;

  Camion({
    this.id,
    required this.tipoMezzo,
    required this.spazioDisponibile,
    this.localitaCarico,
    required this.dataRitiro,
    this.localitaScarico,
    this.isRecurring = false,
    this.giorniDisponibili,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipoMezzo': tipoMezzo,
      'spazioDisponibile': spazioDisponibile,
      'localitaCarico': localitaCarico,
      'dataRitiro': dataRitiro.toIso8601String(),
      'localitaScarico': localitaScarico,
    };
  }
  factory Camion.fromJson(Map<String, dynamic> json) {
    return Camion(
      id: json['id'] as int? ?? 0,
      tipoMezzo: json['tipoMezzo'] ?? 'Non specificato',
      spazioDisponibile: json['spazioDisponibile']  ?? 0,
      localitaCarico: json['carico'] as String?,
      dataRitiro: DateTime.parse(json['dataRitiro'] ?? 'N/A'),
      localitaScarico: json['scarico'] as String?,
    );
  }
}
