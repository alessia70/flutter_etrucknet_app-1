import 'package:flutter_etrucknet_new/DTOs/sign_in_dto.dart';
import 'package:flutter_etrucknet_new/res/app_urls.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveToken(String token, int trasportatoreId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setInt('trasportatore_id', trasportatoreId); 
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

  try {
    final response = await http.post(
      Uri.parse(AppUrl.loginEndPoint),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: credentials.toForm(),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final tipoRuolo = responseData['user']['tipoRuolo'] ?? 'Tipo Ruolo Sconosciuto';
      final token = responseData['token'];
      final trasportatoreId = responseData['user']['id'] ?? 0;

      if (token != null) {
        await saveToken(token, trasportatoreId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token non trovato nella risposta.')),
        );
      }

      if (tipoRuolo == 'Azienda Trasporti') {
        Navigator.pushReplacementNamed(context, '/dashboard_trasportatore');
      } else if (tipoRuolo == 'Operatore Remoto' || tipoRuolo == 'Etrucknet') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (tipoRuolo == 'Committente') {
        Navigator.pushReplacementNamed(context, '/dashboard_committente');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tipo ruolo non riconosciuto: $tipoRuolo')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login fallito. Codice: ${response.statusCode}')),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/images/logoEtrucknet.png',
            height: 80,
          ),
          SizedBox(height: 20),
        Container(
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
                'Bentornato!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 250, 113, 1),
                ),
              ),
              SizedBox(height: 20),
              Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Inserisci l\' email',
                ),
              ),
              SizedBox(height: 20),
              Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Inserisci la password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 40),
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _signIn,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color.fromARGB(255, 250, 113, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Color.fromARGB(255, 250, 113, 1), width: 1),
                  ),
                  child: Text(
                    'Accedi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                     ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}