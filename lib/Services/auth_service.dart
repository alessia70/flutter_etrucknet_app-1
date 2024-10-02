class AuthService {
  // Simula lo stato di autenticazione locale
  bool _loggedIn = false;

  // Simula il login
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // Simula un ritardo (es. per imitare una richiesta di rete)
    await Future.delayed(Duration(seconds: 2));

    // Simula il login con credenziali fittizie
    if (email == 'test@example.com' && password == 'password') {
      _loggedIn = true;
    } else {
      throw Exception('Credenziali non valide');
    }
  }

  // Simula il logout
  Future<void> signOut() async {
    _loggedIn = false;
    await Future.delayed(Duration(seconds: 1));  // Simula un piccolo ritardo per il logout
  }

  // Controlla se l'utente è loggato
  bool isLoggedIn() {
    return _loggedIn;
  }
}
