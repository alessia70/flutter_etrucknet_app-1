class Transport {
  final int id;
  final String carico;
  final String provinciaCarico;
  final DateTime dataInizio;
  final String scarico;
  final String provinciaScarico;
  final DateTime dataFine;
  final bool mercePronta;
  final int esito;
  final int operatoreId;
  final String operatore;
  final int idProposta;

  final String contattoTrasportatore;
  final String luogoCarico;
  final String luogoScarico;
  final DateTime dataCarico;
  final DateTime dataScarico;
  final String status;
  final String tipoTrasporto;

  Transport({
    required this.id,
    required this.carico,
    required this.provinciaCarico,
    required this.dataInizio,
    required this.scarico,
    required this.provinciaScarico,
    required this.dataFine,
    required this.mercePronta,
    required this.esito,
    required this.operatoreId,
    required this.operatore,
    required this.idProposta,
    required this.contattoTrasportatore,
    required this.luogoCarico,
    required this.luogoScarico,
    required this.dataCarico,
    required this.dataScarico,
    required this.status,
    required this.tipoTrasporto,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['ordineId'] ?? 0,
      carico: json['carico'] ?? '',
      provinciaCarico: json['provinciaCarico']?.trim() ?? '',
      dataInizio: _parseDate(json['dataInizio']),
      scarico: json['scarico'] ?? '',
      provinciaScarico: json['provinciaSCarico']?.trim() ?? '',
      dataFine: _parseDate(json['dataFine']),
      mercePronta: json['mercePronta'] ?? false,
      esito: json['esito'] ?? 0,
      operatoreId: json['operatoreId'] ?? 0,
      operatore: json['operatore'] ?? '',
      idProposta: json['idProposta'] ?? 0,
      contattoTrasportatore: json['contattoTrasportatore'] ?? '',
      luogoCarico: json['luogoCarico'] ?? '',
      luogoScarico: json['luogoScarico'] ?? '',
      dataCarico: _parseDate(json['dataCarico']),
      dataScarico: _parseDate(json['dataScarico']),
      status: json['status'] ?? '', 
      tipoTrasporto: json['tipoTrasporto'] ?? '',
    );
  }
  static DateTime _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }
}
