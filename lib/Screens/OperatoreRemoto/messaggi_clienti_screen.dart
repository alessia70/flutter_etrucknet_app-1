import 'package:flutter/material.dart';

class MessaggiClientiScreen extends StatelessWidget {
  const MessaggiClientiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaggi Clienti'),
      ),
      body: Center(
        child: Text('Contenuto della schermata Procedure'),
      ),
    );
  }
}