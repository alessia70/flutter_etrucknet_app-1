import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Repositories/auth_repository.dart';
import 'package:flutter_etrucknet_new/Models/user_model.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Credenziali mancanti')),
    );
    return;
  }

  try {
    // Chiamata all'API di login e ricezione del JSON di risposta
    final UserModel? user = await _authRepository.loginApi({
      'email': email,
      'password': password,
    });

    // Stampa l'oggetto UserModel ricevuto
    print('User model completo: $user');

    if (user != null) {
      // Stampa i ruoli ricevuti
      print('Ruoli ricevuti: ${user.ruoli.map((ruolo) => ruolo.nome).toList()}');

      // Verifica il ruolo dell'utente
      if (user.ruoli.any((ruolo) => ruolo.nome == 'trasportatore')) {
        Navigator.pushReplacementNamed(context, '/dashboard_trasportatore');
      } else if (user.ruoli.any((ruolo) => ruolo.nome == 'operatore_remoto')) {
        Navigator.pushReplacementNamed(context, '/dashboard_operatore');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ruolo utente non valido')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login fallito. Verifica le credenziali')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Errore: ${e.toString()}')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accedi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Inserisci la tua email',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Password',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Inserisci la tua password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Accedi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
