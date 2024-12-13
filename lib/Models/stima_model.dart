class Item {
  final int quantity;
  final double weight;
  final double length;
  final double width;
  final double height;
  final String packagingType;
  final String description;
  final String specifications;
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
  final String id;
  final String user; 
  final String pickupLocation;
  final String deliveryLocation;
  final DateTime requestDate;
  final String transportType;
  final double kmTratta;
  final List<Item> items;
  final bool loadedLaterally;
  final bool cashOnDelivery;
  final bool trafficProblems;
  final String additionalInfo;

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
    required this.kmTratta
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
