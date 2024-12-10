import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Provider/user_provider.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Amminiztrazione/fatture_ricevute_committente_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Simulatore/mie_simulazioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Simulatore/simula_costo_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Trasporti/preventivi_assegnati_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Trasporti/preventivi_cancellati_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Trasporti/preventivi_richiesti_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Trasporti/richiedi_preventivo_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/dashboard_committente.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/conferme_subvezioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/richieste_subvezioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/subvezioni_cancellate_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Amministrazione/fatture_emesse_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Amministrazione/fatture_ricevute_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Configurazione/autisti.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Configurazione/camion_disponibili_t.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Configurazione/flotta.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Configurazione/servizi_logistici.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Configurazione/tratte.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/totale_trasporti.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/trasporti_eseguiti.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/dashboard_trasportatore.dart';
import 'package:flutter_etrucknet_new/Provider/estimates_provider.dart';
import 'package:flutter_etrucknet_new/Services/message_provider.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/proposte_trasporti.dart';
import 'Widgets/sign_in_form.dart'; 
import 'Screens/OperatoreRemoto/dashboard.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EstimatesProvider()),
        ChangeNotifierProvider(create: (_) => MessagesProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Etrucknet',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInScreen(),
        '/dashboard_trasportatore': (context) => TrasportatoreDashboardScreen(),
        '/dashboard_committente': (context) => CommittenteDashboardScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/Configurazione/flotta': (context) => FlottaScreen(),
        '/Configurazione/tratte': (context) => TrattePage(),
        '/Configurazione/camion_disponibili_t': (context) => CamionDisponibiliTPage(),
        '/Configurazione/servizi_logistici': (context) => ServiziLogisticiPage(),
        '/Configurazione/autisti': (context) => AutistiPage(),
        '/VenditaTrasporti/proposte_trasporti': (context) => TrasportiPropostiScreen(),
        '/VenditaTrasporti/totale_trasporti': (context) => TotaleTrasportiScreen(),
        '/VenditaTrasporti/trasporti_eseguiti': (context) => CompletedTransportPage(),
        '/AcquistoTrasporti/richieste_subvezioni_page': (context) => RichiesteSubvezioniPage(),
        '/AcquistoTrasporti/conferme_subvezioni_page': (context) => ConfermeSubvezioniPage(),
        '/AcquistoTrasporti/subvezioni_cancellate_page': (context) => SubvezioniCancellatePage(),
        '/Amministrazione/fatture_emesse_page': (context) => FattureEmessePage(),
        '/Amministrazione/fatture_ricevute_page': (context) => FattureRicevutePage(),
        '/Simulatore/simula_costo_page': (context) => StimaCostoScreen(),
        '/Simulatore/mie_simulazioni_page': (context) => MieSimulazioniPage(),
        '/Trasporti/richiedi_preventivo_page': (context) => RichiediPreventivoPage(),
        '/Trasporti/preventivi_richiesti_page': (context) => PreventiviRichiestiPage(),
        '/Trasporti/preventivi_assegnati_page': (context) => PreventiviAssegnatiPage(),
        '/Trasporti/preventivi_cancellati_page': (context) => PreventiviCancellatiPage(),
        '/Amministrazione/fatture_ricevute_committente_page': (context) => FattureRicevuteCommittentePage(),
      },
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SignInForm(),
      ),
    );
  }
}
