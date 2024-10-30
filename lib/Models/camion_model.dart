class Camion {
  final String tipoMezzo;
  final int spazioDisponibile;
  final String localitaCarico;
  final DateTime dataRitiro;
  final String localitaScarico;

  Camion({
    required this.tipoMezzo,
    required this.spazioDisponibile,
    required this.localitaCarico,
    required this.dataRitiro,
    required this.localitaScarico,
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
      tipoMezzo: json['tipoMezzo'],
      spazioDisponibile: json['spazioDisponibile'],
      localitaCarico: json['localitaCarico'],
      dataRitiro: DateTime.parse(json['dataRitiro']),
      localitaScarico: json['localitaScarico'],
    );
  }
}