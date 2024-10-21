class Order {
  final String id;
  final String customerName;
  final String customerContact;
  final DateTime date;
  final String companyName;
  final String loadingDate;
  final String loadingLocation; // Include luogo
  final String loadingProvince;
  final String loadingCountry;
  final bool isLoadingMandatory;
  final String unloadingDate;
  final String unloadingLocation; // Include luogo
  final String unloadingProvince;
  final String unloadingCountry;
  final double offerAmount;
  final int activeOffers;
  final int expiredOffers;
  final int correspondenceCount;
  final double estimatedBudget;

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
    required this.unloadingDate,
    required this.unloadingLocation,
    required this.unloadingProvince,
    required this.unloadingCountry,
    required this.offerAmount,
    required this.activeOffers,
    required this.expiredOffers,
    required this.correspondenceCount,
    required this.estimatedBudget,
  });
}
