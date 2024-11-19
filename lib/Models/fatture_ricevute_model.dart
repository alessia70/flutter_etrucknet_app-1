class FatturaRicevuta {
  final int id;
  final String ricevutaDa;
  final DateTime data;
  final double importo;
  final String descrizione;
  final String infoScadenza;

  FatturaRicevuta({
    required this.id,
    required this.ricevutaDa,
    required this.data,
    required this.importo,
    required this.descrizione,
    required this.infoScadenza,
  });

  factory FatturaRicevuta.fromJson(Map<String, dynamic> json) {
    return FatturaRicevuta(
      id: json['id'],
      ricevutaDa: json['ricevutaDa'],
      data: DateTime.parse(json['data']),
      importo: json['importo'].toDouble(),
      descrizione: json['descrizione'],
      infoScadenza: json['infoScadenza'],
    );
  }
}
