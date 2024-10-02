import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Widgets/side_menu.dart';

class AvailableTrucksScreen extends StatelessWidget {
  const AvailableTrucksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camion Disponibili'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      drawer: SideMenu(),
      body: const Center(
        child: Text(
          'Contenuto dei Camion Disponibili',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
