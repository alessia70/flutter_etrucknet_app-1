class Order {
  final int id;
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
  final bool isSideLoadingRequired;
  final bool isCashOnDelivery;
  final bool hasRoadAccessibilityIssues;
  bool? isCompleted;
  bool? isCanceled;
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
    this.isCompleted,
    this.isCanceled,
    this.isSideLoadingRequired = false,
    this.isCashOnDelivery = false,
    this.hasRoadAccessibilityIssues = false,
    this.packagingType,
    this.description,
    this.quantity,
    this.totalWeight,
    this.length,
    this.width,
    this.height,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      customerName: json['customerName'] ?? '',
      customerContact: json['customerContact'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      companyName: json['companyName'] ?? '',
      loadingDate: json['loadingDate'] ?? '',
      loadingLocation: json['loadingLocation'] ?? '',
      loadingProvince: json['loadingProvince'] ?? '',
      loadingCountry: json['loadingCountry'] ?? '',
      isLoadingMandatory: json['isLoadingMandatory'] ?? false,
      isUnloadingMandatory: json['isUnloadingMandatory'] ?? false,
      unloadingDate: json['unloadingDate'] ?? '',
      unloadingLocation: json['unloadingLocation'] ?? '',
      unloadingProvince: json['unloadingProvince'] ?? '',
      unloadingCountry: json['unloadingCountry'] ?? '',
      offerAmount: json['offerAmount']?.toDouble() ?? 0.0,
      activeOffers: json['activeOffers'] ?? 0,
      expiredOffers: json['expiredOffers'] ?? 0,
      correspondenceCount: json['correspondenceCount'] ?? 0,
      estimatedBudget: json['estimatedBudget']?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'],
      isCanceled: json['isCanceled'],
      vehicleType: json['vehicleType'],
      additionalSpecs: json['additionalSpecs'],
      isSideLoadingRequired: json['isSideLoadingRequired'] ?? false,
      isCashOnDelivery: json['isCashOnDelivery'] ?? false,
      hasRoadAccessibilityIssues: json['hasRoadAccessibilityIssues'] ?? false,
      packagingType: json['packagingType'],
      description: json['description'],
      quantity: json['quantity'],
      totalWeight: json['totalWeight']?.toDouble(),
      length: json['length']?.toDouble(),
      width: json['width']?.toDouble(),
      height: json['height']?.toDouble(), 
    );
  }
}
