import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/dashboard_trasportatore.dart';
import 'package:flutter_etrucknet_new/Services/estimates_provider.dart';
import 'package:flutter_etrucknet_new/Services/message_provider.dart';
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
        '/dashboard': (context) => DashboardScreen(),
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
