import 'package:flutter_etrucknet_new/DTOs/sign_in_dto.dart';
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

  final credentials = SignInDTO(email: email.trim(), password: password.trim());

  print('URL endpoint: ${AppUrl.loginEndPoint}');
  print('Headers: {"Content-Type": "application/x-www-form-urlencoded"}');
  print('Corpo inviato: ${credentials.toForm()}');

  try {
    final response = await http.post(
      Uri.parse(AppUrl.loginEndPoint),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: credentials.toForm(),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Decodifica la risposta direttamente come JSON
      final responseData = jsonDecode(response.body);

      // Stampa l'intera risposta per il debug
      print('Response data: $responseData');

      // Controlla se lo stato è presente
      if (responseData['token'] != null) {
        final token = responseData['token'];
        final user = responseData['user'];

        print('Token ricevuto: $token');
        print('User: $user');

        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login fallito. Stato: ${responseData['status'] ?? "null"}')),
        );
      }
    } else {
      // Stampa il codice di stato e il corpo della risposta in caso di errore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login fallito. Codice: ${response.statusCode}, Corpo: ${response.body}')),
      );
      print('Errore: Codice: ${response.statusCode}, Corpo: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Errore: ${e.toString()}')),
    );
    print('Eccezione catturata: $e');
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
