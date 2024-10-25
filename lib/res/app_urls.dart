class AppUrl {
  static var baseUrl = 'https://etrucknetapi.azurewebsites.net';
  static var version = 'v1';

  static var loginEndPoint =  '$baseUrl/$version/Auth/Login';  // Aggiungi baseUrl
  static var registerApiEndPoint =  '$baseUrl/$version/register'; // Aggiungi baseUrl
  static var configurationEndPoint     = "$baseUrl/$version/Configuration"; // Aggiungi baseUrl
  static var anagraficaRatingEndPoint  = "$baseUrl/$version/AnagraficaRating"; // Aggiungi baseUrl
  static var profileEndPoint           = "$baseUrl/$version/profile_data"; // Aggiungi baseUrl
  static var companyEndPoint           = "$baseUrl/$version/company_data"; // Aggiungi baseUrl
  static var camionDisponibiliEndPoint = "$baseUrl/$version/CamionDisponibili"; // Aggiungi baseUrl
  static var fleetEndPoint             = "$baseUrl/$version/Flotta"; // Aggiungi baseUrl
  static var driverEndPoint            = "$baseUrl/$version/driver_data"; // Aggiungi baseUrl
  static var loadsEndPoint             = "$baseUrl/$version/Proposte"; // Aggiungi baseUrl
  static var transportsEndPoint        = "$baseUrl/$version/RdtEseguiti"; // Aggiungi baseUrl
  static var issuedInvoicesEndPoint    = "$baseUrl/$version/FattureEmesse"; // Aggiungi baseUrl
  static var receivedInvoicesEndPoint  = "$baseUrl/$version/FattureRicevute"; // Aggiungi baseUrl
  static var sentOffer                 = "$baseUrl/$version/Offerte"; // Aggiungi baseUrl
}
