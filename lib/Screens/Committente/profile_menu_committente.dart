import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/user_model.dart';
import 'package:flutter_etrucknet_new/Services/api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCommittentePage extends StatefulWidget {
  const ProfileCommittentePage({Key? key}) : super(key: key);

  @override
  _ProfileCommittentePageState createState() => _ProfileCommittentePageState();
}

class _ProfileCommittentePageState extends State<ProfileCommittentePage> {
  late ApiService apiService;
  Future<UserModel?>? _userFuture; // Variabile nullable, inizializzata quando il token è disponibile
  String? token;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadToken();
  }

  // Metodo per caricare il token
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token'); // Carica il token dai SharedPreferences
    if (token == null) {
      // Se non c'è un token, mostra un messaggio di errore o esegui un redirect
      print("Token non disponibile");
      Navigator.pushReplacementNamed(context, '/login'); // Redirige alla pagina di login
    } else {
      // Se c'è un token, carica i dati dell'utente
      setState(() {
        _userFuture = apiService.fetchUserData(token!); // Inizializza _userFuture con i dati utente
      });
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
      body: _userFuture == null
          ? Center(child: SpinKitCircle(color: Colors.orange)) // Mostra un caricamento fino a quando _userFuture non è inizializzato
          : FutureBuilder<UserModel?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(color: Colors.orange), // Spinner durante il caricamento
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Errore nel caricare i dati: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text('Nessun dato disponibile.'),
                  );
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
                          subtitle: Text(user.lastName ?? 'N/A'),
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
                          subtitle: Text(user.phoneNumber ?? 'N/A'),
                        ),
                        ListTile(
                          title: const Text('Azienda:'),
                          subtitle: Text(user.companyName ?? 'N/A'),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          title: const Text('Cambia Password'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            // Aggiungi la funzionalità per cambiare la password
                          },
                        ),
                        ListTile(
                          title: const Text('Esci'),
                          trailing: const Icon(Icons.logout),
                          onTap: () {
                            // Aggiungi la funzionalità di logout
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
