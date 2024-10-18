class Order {
  final String id;
  final String customerName;
  final String customerContact;
  final DateTime date;
  final String companyName;
  final String loadingDate;
  final String loadingLocation;
  final String loadingProvince;
  final String loadingCountry;
  final bool isLoadingMandatory;
  final bool isUnloadingMandatory;
  final String unloadingDate;
  final String unloadingLocation;
  final String unloadingProvince;
  final String unloadingCountry;
  final double offerAmount;
  final int activeOffers;
  final int expiredOffers;
  final int correspondenceCount;
  final double estimatedBudget;

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
    required this.isUnloadingMandatory,
    required this.unloadingDate,
    required this.unloadingLocation,
    required this.unloadingProvince,
    required this.unloadingCountry,
    required this.offerAmount,
    required this.activeOffers,
    required this.expiredOffers,
    required this.correspondenceCount,
    required this.estimatedBudget,

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
  });
}
