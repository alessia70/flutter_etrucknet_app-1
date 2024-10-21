class Order {
  final String id;
  final String customerName;
  final String customerContact;
  final DateTime date;
  final String companyName;
  final String loadingDate;
<<<<<<< HEAD
  final String loadingLocation; // Include luogo
  final String loadingProvince;
  final String loadingCountry;
  final bool isLoadingMandatory;
  final String unloadingDate;
  final String unloadingLocation; // Include luogo
=======
  final String loadingLocation;
  final String loadingProvince;
  final String loadingCountry;
  final bool isLoadingMandatory;
  final bool isUnloadingMandatory;
  final String unloadingDate;
  final String unloadingLocation;
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
  final String unloadingProvince;
  final String unloadingCountry;
  final double offerAmount;
  final int activeOffers;
  final int expiredOffers;
  final int correspondenceCount;
  final double estimatedBudget;

<<<<<<< HEAD
=======
  final String? vehicleType;
  final String? additionalSpecs;

  // Campi con valore predefinito
  final bool isSideLoadingRequired;
  final bool isCashOnDelivery;
  final bool hasRoadAccessibilityIssues;

  // Dettagli della merce
  final String? packagingType;
  final String? description;
  final int? quantity;
  final double? totalWeight;
  final double? length;
  final double? width;
  final double? height;

>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
  Order({
    required this.id,
    required this.customerName,
    required this.customerContact,
    required this.date,
    required this.companyName,
    required this.loadingDate,
    required this.loadingLocation,
    required this.loadingProvince,
    required this.loadingCountry,
    required this.isLoadingMandatory,
<<<<<<< HEAD
=======
    required this.isUnloadingMandatory,
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
    required this.unloadingDate,
    required this.unloadingLocation,
    required this.unloadingProvince,
    required this.unloadingCountry,
    required this.offerAmount,
    required this.activeOffers,
    required this.expiredOffers,
    required this.correspondenceCount,
    required this.estimatedBudget,
<<<<<<< HEAD
=======

    this.vehicleType,
    this.additionalSpecs,

    // Imposta valori predefiniti
    this.isSideLoadingRequired = false,  // Default a false
    this.isCashOnDelivery = false,  // Default a false
    this.hasRoadAccessibilityIssues = false,  // Default a false

    // Dettagli merce
    this.packagingType,
    this.description,
    this.quantity,
    this.totalWeight,
    this.length,
    this.width,
    this.height,
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
  });
}
