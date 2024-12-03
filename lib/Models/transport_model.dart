class Transport {
  final int ordineId;
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

  final String? distanza;
  final String? tempo;
  final String? localitaRitiro;
  final DateTime? dataRitiro;
  final String? localitaConsegna;
  final DateTime? dataConsegna;
  final String? mezziAllestimenti;
  final String? ulterioriSpecifiche;
  final List<Map<String, String>>? dettagliTrasporto;
  final List<Map<String, String>>? dettagliMerce;


  Transport({
    required this.ordineId,
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
    
    this.distanza,
    this.tempo,
    this.localitaRitiro,
    this.dataRitiro,
    this.localitaConsegna,
    this.dataConsegna,
    this.mezziAllestimenti,
    this.ulterioriSpecifiche,
    this.dettagliTrasporto,
    this.dettagliMerce,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      ordineId: json['ordineId'] ?? 0,
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
      
      distanza: json['distanza'],
      tempo: json['tempo'],
      localitaRitiro: json['localitaRitiro'],
      dataRitiro: json['dataRitiro'] != null ? DateTime.parse(json['dataRitiro']) : null,
      localitaConsegna: json['localitaConsegna'],
      dataConsegna: json['dataConsegna'] != null ? DateTime.parse(json['dataConsegna']) : null,
      mezziAllestimenti: json['mezziAllestimenti'],
      ulterioriSpecifiche: json['ulterioriSpecifiche'],
      dettagliTrasporto: (json['dettagliTrasporto'] as List<dynamic>?)
        ?.map((item) => Map<String, String>.from(item as Map))
        .toList(),
      dettagliMerce: (json['dettagliMerce'] as List<dynamic>?)
          ?.map((item) => Map<String, String>.from(item as Map))
          .toList(),
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

  @override
  String toString() {
    return 'Transport(ordineId: $ordineId, operatore: $operatore, dataInizio: $dataInizio, dataFine: $dataFine)';
  }
}
