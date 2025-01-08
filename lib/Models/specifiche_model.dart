class Specifica {
  final int? idtipo_specifica;
  final String descrizione;
  final String? descrizioneEnglish;
  final String? descrizioneRumeno;
  final int? coperta;
  final int? scoperta;
  final int? copertascoperta;
  final int? tempcontrollata;
  final int? speciale;
  final Map<String, bool>? specifica;
  final Map<String, bool>? tipoSpecifica;

  Specifica({
    required this.idtipo_specifica,
    required this.descrizione,
    this.descrizioneEnglish,
    this.descrizioneRumeno,
    required this.coperta,
    this.scoperta,
    required this.copertascoperta,
    this.tempcontrollata,
    this.speciale,
    this.specifica,
    this.tipoSpecifica,
  });

  factory Specifica.fromJson(Map<String, dynamic> json) {
    return Specifica(
      idtipo_specifica: json['id'],
      descrizione: json['descrizione'],
      descrizioneEnglish: json['descrizione_en'],
      descrizioneRumeno: json['descrizione_ro'],
      coperta: json['coperta'],
      scoperta: json['scoperta'],
      copertascoperta: json['copertascoperta'],
      tempcontrollata: json['tempcontrollata'],
      speciale: json['speciale'],
      specifica: (json['specifica'] != null) 
          ? Map<String, bool>.from(json['specifica']) 
          : null,
      tipoSpecifica: (json['TipoSpecifica'] != null)
          ? Map<String, bool>.from(json['TipoSpecifica'])
          : null,
    );
  }
}