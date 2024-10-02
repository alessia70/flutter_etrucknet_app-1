import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Widgets/side_menu.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bacheca'),
        backgroundColor: Colors.orange,
      ),
      drawer: SideMenu(),
      body: Center(
        child: Text(
          'Benvenuto nella Bacheca!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
