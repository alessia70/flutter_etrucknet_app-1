class RdtEseguiti {
  final int id;
  final int? ordineId;
  final int? trasportatoreId;
  final DateTime? dataCarico;
  final DateTime? dataScarico;
  final String? committente;
  final String? luogoCarico;
  final String? luogoScarico;
  final double? importoTrasporto;
  final double importoFattura;
  final int? invoiceId;
  final String? fatturaId;
  final DateTime dataFattura;
  final DateTime dataScadenza;
  final int? statoFatturaTrasporto;
  final bool asSolleciti;
  final bool asDdt;
  final DateTime? ddtCreated;
  final bool asFeedback;
  final List<dynamic>? dettagliTrasporto;
  final List<dynamic>? ddts;
  final List<dynamic>? fatturePassive;
  final List<dynamic>? noteCredito;
  final List<dynamic>? pagamenti;
  final List<dynamic>? solleciti;

  RdtEseguiti({
    required this.id,
    this.ordineId,
    this.trasportatoreId,
    this.dataCarico,
    this.dataScarico,
    this.committente,
    this.luogoCarico,
    this.luogoScarico,
    this.importoTrasporto,
    required this.importoFattura,
    this.invoiceId,
    this.fatturaId,
    required this.dataFattura,
    required this.dataScadenza,
    this.statoFatturaTrasporto,
    required this.asSolleciti,
    required this.asDdt,
    this.ddtCreated,
    required this.asFeedback,
    this.dettagliTrasporto,
    this.ddts,
    this.fatturePassive,
    this.noteCredito,
    this.pagamenti,
    this.solleciti,
  });

  factory RdtEseguiti.fromJson(Map<String, dynamic> json) {
    return RdtEseguiti(
      id: json['id'] ?? 0,
      ordineId: json['ordineId'],
      trasportatoreId: json['trasportatoreId'],
      dataCarico: _parseDate(json['dataCarico']),
      committente: json['committente'],
      luogoCarico: json['luogoCarico'],
      luogoScarico: json['luogoScarico'],
      importoTrasporto: (json['importoTrasporto'] ?? 0.0).toDouble(),
      importoFattura: (json['importoFattura'] ?? 0.0).toDouble(),
      invoiceId: json['invoiceId'],
      fatturaId: json['numeroFattura'],
      dataFattura: _parseDate(json['dataFattura']),
      dataScadenza: _parseDate(json['dataScadenzaFattura']),
      statoFatturaTrasporto: json['statoFatturaTrasporto'],
      asSolleciti: json['asSolleciti'] ?? false,
      asDdt: json['asDdt'] ?? false,
      ddtCreated: _parseDate(json['ddtCreated']),
      asFeedback: json['asFeedback'] ?? false,
      ddts: json['ddts'] != null ? List<dynamic>.from(json['ddts']) : [],
      fatturePassive: json['fatturePassive'] != null ? List<dynamic>.from(json['fatturePassive']) : [],
      noteCredito: json['noteCredito'] != null ? List<dynamic>.from(json['noteCredito']) : [],
      pagamenti: json['pagamenti'] != null ? List<dynamic>.from(json['pagamenti']) : [],
      solleciti: json['solleciti'] != null ? List<dynamic>.from(json['solleciti']) : [],
    );
  }

  static DateTime _parseDate(String? dateString) {
    if (dateString == null || dateString == "0001-01-01T00:00:00") {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }
}
