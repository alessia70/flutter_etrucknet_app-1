import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Widgets/card_dettaglio_stima.dart';

class DettaglioStimaScreen extends StatelessWidget {
  final Map<String, dynamic> estimate;

  const DettaglioStimaScreen({super.key, required this.estimate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettaglio Stima'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CardDettaglioStima(estimate: estimate), 
      ),
    );
  }
}
