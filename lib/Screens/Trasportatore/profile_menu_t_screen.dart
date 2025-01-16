import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/user_model.dart';
import 'package:flutter_etrucknet_new/Services/api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTrasportatorePage extends StatefulWidget {
  const ProfileTrasportatorePage({super.key});

  @override
  _ProfileTrasportatorePageState createState() => _ProfileTrasportatorePageState();
}

class _ProfileTrasportatorePageState extends State<ProfileTrasportatorePage> {
  late ApiService apiService;
  late Future<UserModel?> _userFuture;
  String? token;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _userFuture = apiService.fetchUserData(token!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.orange,
            onPressed: () {
              // Funzionalità per modificare il profilo
            },
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore nel caricare i dati.'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nessun dato disponibile.'));
          } else {
            UserModel user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informazioni Personali',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Nome:'),
              subtitle: Text(user.firstName ?? 'N/A'),
            ),
            ListTile(
              title: const Text('Cognome:'),
              subtitle: Text(user.lastName  ?? 'N/A'),
            ),
            ListTile(
              title: const Text('Nome Completo:'),
              subtitle: Text(user.fullName ?? 'N/A'),
            ),
            ListTile(
              title: const Text('Email:'),
              subtitle: Text(user.email),
            ),
            ListTile(
              title: const Text('Telefono:'),
              subtitle: const Text('+39 123 456 7890'),
            ),
            ListTile(
              title: const Text('Azienda:'),
              subtitle: Text(user.companyName ?? 'N/A'),
            ),
            const Divider(),
            const Text(
              'Impostazioni Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Cambia Password'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Implementa la funzionalità per cambiare la password
              },
            ),
            ListTile(
              title: const Text('Esci'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                // Implementa la funzionalità di logout
              },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}