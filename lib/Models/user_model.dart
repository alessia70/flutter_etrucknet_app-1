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
    return UserModel(
      id: form['id'],
      userName: form['userName'],
      email: form['email'],
      emailConfirmed: form['emailConfirmed'],
      phoneNumber: form['phoneNumber'],
      twoFactorEnabled: form['twoFactorEnabled'],
      isAuthenticated: form['isAuthenticated'],
      firstName: form['nome'],
      lastName: form['cognome'],
      fullName: form['nomeCompleto'],
      companyName: form['ragioneSociale'],
      contractId: form['idContratto'],
      firstAccess: form['primoAccesso'],
      status: form['status'],
      acceptContrastCarriers: form['accettazioneContrattoCarriers'],
      acceptContractShippers: form['accettazioneContrattoShippers'],
      acceptContractStandard: form['accettazioneContrattoStandard'],
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
