import 'package:flutter/material.dart';

class AnagraficheScreen extends StatelessWidget {
  const AnagraficheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anagrafiche'),
      ),
      body: Center(
        child: Text('Contenuto della schermata Anagrafiche'),
      ),
    );
  }
}
