class FatturaRicevuta {
  final String? idFattura;
  final String? ricevutaDa;
  final DateTime data;
  final double importo;
  final String? descrizione;
  final String? infoScadenza;

  FatturaRicevuta({
    required this.idFattura,
    required this.ricevutaDa,
    required this.data,
    required this.importo,
    required this.descrizione,
    required this.infoScadenza,
  });

  factory FatturaRicevuta.fromJson(Map<String, dynamic> json) {
    return FatturaRicevuta(
      idFattura: json['idFattura'] ?? '',
      ricevutaDa: json['ricevutaDa'] ?? 'Non disponibile',
      data: json['dataEmissione'] != null 
          ? DateTime.parse(json['dataEmissione'])
          : DateTime.now(),
      importo: json['importo'] != null 
          ? json['importo'].toDouble() 
          : 0.0,
      descrizione: json['descrizione'],
      infoScadenza: json['dataScadenza'],
    );
  }
}
