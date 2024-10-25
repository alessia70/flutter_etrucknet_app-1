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

  factory UserModel.fromForm(Map<String, dynamic> form) {
    // Mappa la lista di ruoli dal JSON
    var ruoloList = (form['anagraficaRoles'] ?? []) as List;
    List<RuoloModel> ruoli = ruoloList.map((i) => RuoloModel.fromForm(i)).toList();

    return UserModel(
      id: form['user']['id'],
      userName: form['user']['userName'],
      email: form['user']['email'],
      emailConfirmed: form['user']['emailConfirmed'],
      phoneNumber: form['user']['phoneNumber'],
      twoFactorEnabled: form['user']['twoFactorEnabled'],
      isAuthenticated: form['user']['isAuthenticated'] ?? false,
      firstName: form['user']['nome'],
      lastName: form['user']['cognome'],
      fullName: form['user']['nomeCompleto'],
      companyName: form['user']['ragioneSociale'],
      ruoli: ruoli,
      contractId: form['user']['idContratto'],
      firstAccess: form['user']['primoAccesso'],
      status: form['user']['status'],
      acceptContrastCarriers: form['user']['accettazioneContrattoCarriers'],
      acceptContractShippers: form['user']['accettazioneContrattoShippers'],
      acceptContractStandard: form['user']['accettazioneContrattoStandard'],
      token: form['token'],
    );
  }

  Map<String, dynamic> toForm() {
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
      'anagraficaRoles': ruoli.map((role) => role.toForm()).toList(),
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
