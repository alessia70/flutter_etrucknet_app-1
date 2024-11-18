class FatturaEmessa {
  final int id;
  final String idFattura;
  final String ragioneSociale;
  final String iban;
  final double importo;
  final DateTime dataScadenza;
  final DateTime dataFattura;
  final int stato;

  FatturaEmessa({
    required this.id,
    required this.idFattura,
    required this.ragioneSociale,
    required this.iban,
    required this.importo,
    required this.dataScadenza,
    required this.dataFattura,
    required this.stato,
  });

  factory FatturaEmessa.fromJson(Map<String, dynamic> json) {
    return FatturaEmessa(
      id: json['id'],
      idFattura: json['idFattura'],
      ragioneSociale: json['ragioneSociale'],
      iban: json['iban'] ?? '',
      importo: (json['importo'] is num) ? (json['importo'] as num).toDouble() : 0.0,
      dataScadenza: DateTime.parse(json['dataScadenza']),
      dataFattura: DateTime.parse(json['dataFattura']),
      stato: json['stato'],
    );
  }
}
