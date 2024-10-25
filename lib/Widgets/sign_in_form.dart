import 'package:flutter_etrucknet_new/Models/user_model.dart';
import 'package:flutter_etrucknet_new/res/app_urls.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
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

  final credentials = {
    'Email': email.trim(),
    'Password': password.trim(),
  };

  print('Login endpoint: ${AppUrl.loginEndPoint}');

  try {
    final response = await http.post(
      Uri.parse(AppUrl.loginEndPoint),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: jsonEncode(credentials),
    );

    print('Email: $email'); // Controlla che l'email sia corretta
    print('Password: $password'); // Controlla che la password sia corretta

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(jsonDecode(response.body));
      print('User model completo: $user');

      if (user.ruoli.isNotEmpty) {
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
          const SnackBar(content: Text('Nessun ruolo associato all\'utente')),
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
            Text('Email', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Inserisci la tua email',
              ),
            ),
            SizedBox(height: 20),
            Text('Password', style: TextStyle(fontSize: 16)),
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
