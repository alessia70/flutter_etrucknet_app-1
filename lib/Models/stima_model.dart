class Item {
  final int quantity;
  final double weight; // Peso totale
  final double length; // Lunghezza
  final double width; // Larghezza
  final double height; // Altezza
  final String packagingType; // Tipo di imballo
  final String description; // Descrizione
  final String specifications; // Specifiche

  Item({
    required this.quantity,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.packagingType,
    required this.description,
    required this.specifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'packagingType': packagingType,
      'description': description,
      'specifications': specifications,
    };
  }
}


class Estimate {
  final String id; // ID della stima
  final String user; // Utente che crea la stima
  final String pickupLocation; // Luogo di ritiro
  final String deliveryLocation; // Luogo di consegna
  final DateTime requestDate; // Data della richiesta
  final String transportType; // Tipologia di trasporto
  final List<Item> items; // Lista di articoli
  final bool loadedLaterally; // Merce caricata lateralmente
  final bool cashOnDelivery; // Pagata in contrassegno
  final bool trafficProblems; // Problemi di viabilità
  final String additionalInfo; // Altre informazioni utili

  Estimate({
    required this.id,
    required this.user,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.requestDate,
    required this.transportType,
    required this.items,
    required this.loadedLaterally,
    required this.cashOnDelivery,
    required this.trafficProblems,
    required this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utente': user,
      'carico': pickupLocation,
      'scarico': deliveryLocation,
      'dataRichiesta': requestDate.toIso8601String(),
      'tipologiaTrasporto': transportType,
      'articoli': items.map((item) => item.toJson()).toList(),
      'caricamentoLaterale': loadedLaterally,
      'pagamentoContrassegno': cashOnDelivery,
      'problemiViabilita': trafficProblems,
      'altreInformazioni': additionalInfo,
    };
  }
}
