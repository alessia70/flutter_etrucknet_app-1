class Allestimento {
  final int idtipo_allestimento;
  final String? descrizione;
  final String? descrizioneEnglish;
  final String? descrizioneRumeno;
  final int? coperta;
  final int? scoperta;
  final int? copertascoperta;
  final int? tempcontrollata;
  final int? speciale;
  final Map<String, bool>? allestimento;
  final Map<String, bool>? tipoAllestimento;

  Allestimento({
    required this.idtipo_allestimento,
    required this.descrizione,
    this.descrizioneEnglish,
    this.descrizioneRumeno,
    required this.coperta,
    this.scoperta,
    required this.copertascoperta,
    this.tempcontrollata,
    this.speciale,
    this.allestimento,
    this.tipoAllestimento,
  });

  factory Allestimento.fromJson(Map<String, dynamic> json) {
    return Allestimento(
      idtipo_allestimento: json['idtipo_allestimento'],
      descrizione: json['descrizione'],
      descrizioneEnglish: json['descrizione_en'],
      descrizioneRumeno: json['descrizione_ro'],
      coperta: json['coperta'],
      scoperta: json['scoperta'],
      copertascoperta: json['copertascoperta'],
      tempcontrollata: json['tempcontrollata'],
      speciale: json['speciale'],
      allestimento: (json['allestimento'] != null) 
          ? Map<String, bool>.from(json['allestimento']) 
          : null,
      tipoAllestimento: (json['TipoAllestimento'] != null)
          ? Map<String, bool>.from(json['TipoAllestimento'])
          : null,
    );
  }
}