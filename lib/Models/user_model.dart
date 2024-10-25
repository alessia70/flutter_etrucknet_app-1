import 'user_role_model.dart';

class UserModel {
  final int id;
  final String userName;
  final String email;
  final bool? emailConfirmed;
  final String? phoneNumber;
  final bool? twoFactorEnabled;
  bool isAuthenticated;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? companyName;
  final List<RuoloModel> ruoli; // Lista dei ruoli
  final int? contractId;
  final bool? firstAccess;
  final int? status;
  final bool? acceptContrastCarriers;
  final bool? acceptContractShippers;
  final bool? acceptContractStandard;

  String? token;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.ruoli,
    this.emailConfirmed,
    this.phoneNumber,
    this.twoFactorEnabled,
    this.isAuthenticated = false,
    this.firstName,
    this.lastName,
    this.fullName,
    this.companyName,
    this.contractId,
    this.firstAccess,
    this.status,
    this.acceptContrastCarriers,
    this.acceptContractShippers,
    this.acceptContractStandard,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Mappa la lista di ruoli dal JSON
    var ruoloList = (json['anagraficaRoles'] ?? []) as List;
    List<RuoloModel> ruoli = ruoloList.map((i) => RuoloModel.fromJson(i)).toList();

    return UserModel(
      id: json['user']['id'],
      userName: json['user']['userName'],
      email: json['user']['email'],
      emailConfirmed: json['user']['emailConfirmed'],
      phoneNumber: json['user']['phoneNumber'],
      twoFactorEnabled: json['user']['twoFactorEnabled'],
      isAuthenticated: json['user']['isAuthenticated'] ?? false,
      firstName: json['user']['nome'],
      lastName: json['user']['cognome'],
      fullName: json['user']['nomeCompleto'],
      companyName: json['user']['ragioneSociale'],
      ruoli: ruoli,
      contractId: json['user']['idContratto'],
      firstAccess: json['user']['primoAccesso'],
      status: json['user']['status'],
      acceptContrastCarriers: json['user']['accettazioneContrattoCarriers'],
      acceptContractShippers: json['user']['accettazioneContrattoShippers'],
      acceptContractStandard: json['user']['accettazioneContrattoStandard'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'emailConfirmed': emailConfirmed,
      'phoneNumber': phoneNumber,
      'twoFactorEnabled': twoFactorEnabled,
      'isAuthenticated': isAuthenticated,
      'nome': firstName,
      'cognome': lastName,
      'nomeCompleto': fullName,
      'ragioneSociale': companyName,
      'anagraficaRoles': ruoli.map((role) => role.toJson()).toList(),
      'idContratto': contractId,
      'primoAccesso': firstAccess,
      'status': status,
      'accettazioneContrattoCarriers': acceptContrastCarriers,
      'accettazioneContrattoShippers': acceptContractShippers,
      'accettazioneContrattoStandard': acceptContractStandard,
      'token': token,
    };
  }
}
