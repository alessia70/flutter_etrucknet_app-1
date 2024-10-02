import 'package:flutter/material.dart';

class ProcedureScreen extends StatelessWidget {
  const ProcedureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procedure'),
      ),
      body: Center(
        child: Text('Contenuto della schermata Procedure'),
      ),
    );
  }
}