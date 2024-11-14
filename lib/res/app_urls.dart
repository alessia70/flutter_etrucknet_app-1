class AppUrl {
  static var baseUrl = 'https://etrucknetapi.azurewebsites.net';
  static var version = 'v1';

  static var loginEndPoint =  '$baseUrl/$version/Auth/Login';
  static var registerApiEndPoint =  '$baseUrl/$version/register';
  static var configurationEndPoint     = "$baseUrl/$version/Configuration";
  static var anagraficaRatingEndPoint  = "$baseUrl/$version/AnagraficaRating"; 
  static var profileEndPoint           = "$baseUrl/$version/profile_data"; 
  static var companyEndPoint           = "$baseUrl/$version/company_data";
  static var camionDisponibiliEndPoint = "$baseUrl/$version/CamionDisponibili";
  static var fleetEndPoint             = "$baseUrl/$version/Flotta";
  static var driverEndPoint            = "$baseUrl/$version/driver_data";
  static var loadsEndPoint             = "$baseUrl/$version/Proposte";
  static var transportsEndPoint        = "$baseUrl/$version/RdtEseguiti";
  static var issuedInvoicesEndPoint    = "$baseUrl/$version/FattureEmesse";
  static var receivedInvoicesEndPoint  = "$baseUrl/$version/FattureRicevute";
  static var sentOffer                 = "$baseUrl/$version/Offerte";
}
