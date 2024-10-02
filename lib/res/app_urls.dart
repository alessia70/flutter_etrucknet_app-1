// ignore_for_file: non_constant_identifier_names

class AppUrl {
  static var baseUrl = 'https://etrucknetapi.azurewebsites.net';
  //static var baseUrl = 'http://localhost:5162';
  static var version = 'v1';

  static var loginEndPoint =  '$version/Auth/Login'; ///  /swagger/v1/swagger.json
  /// static var loginEndPoint =  '$baseUrl/api/login';
  ///  https://dummyjson.com/auth/login
  static var registerApiEndPoint =  '$version/register';
  ///  Etrucknet
  //static var BaseUrl                   = "https://portal.etrucknet.com/";
  static var configurationEndPoint     = "$version/Configuration";
  static var anagraficaRatingEndPoint  = "$version/AnagraficaRating";
  static var profileEndPoint           = "$version/profile_data";
  static var companyEndPoint           = "$version/company_data";
  static var camionDisponibiliEndPoint = "$version/CamionDisponibili";
  static var fleetEndPoint             = "$version/Flotta";
  static var driverEndPoint            = "$version/driver_data";
  static var loadsEndPoint             = "$version/Proposte";
  static var transportsEndPoint        = "$version/RdtEseguiti";
  static var issuedInvoicesEndPoint    = "$version/FattureEmesse";
  static var receivedInvoicesEndPoint  = "$version/FattureRicevute";
  static var sentOffer                 = "$version/Offerte";
}
