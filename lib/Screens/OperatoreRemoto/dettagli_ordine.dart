import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late GoogleMapController mapController;

  // Esempio di coordinate per la mappa
  static const LatLng _center = LatLng(45.4642, 9.1900); // Coordinate di Milano

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli Ordine'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card con la mappa
            Card(
              elevation: 4,
              child: SizedBox(
                height: 250, // Altezza della mappa
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Spazio tra la mappa e i blocchi

            // Blocchi di contenuto
            Expanded(
              child: ListView(
                children: [
                  _buildDetailBlock('Blocco 1', 'Contenuto del blocco 1'),
                  _buildDetailBlock('Blocco 2', 'Contenuto del blocco 2'),
                  _buildDetailBlock('Blocco 3', 'Contenuto del blocco 3'),
                  _buildDetailBlock('Blocco 4', 'Contenuto del blocco 4'),
                  _buildDetailBlock('Blocco 5', 'Contenuto del blocco 5'),
                  _buildDetailBlock('Blocco 6', 'Contenuto del blocco 6'),
                  _buildDetailBlock('Blocco 7', 'Contenuto del blocco 7'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBlock(String title, String content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
