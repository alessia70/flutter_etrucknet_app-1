import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late GoogleMapController mapController;

  static const LatLng _pickupLocation = LatLng(45.4642, 9.1900);
  static const LatLng _deliveryLocation = LatLng(41.9028, 12.4964);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _markers.addAll([
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation,
        infoWindow: InfoWindow(title: 'Ritiro', snippet: 'Milano'),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: _deliveryLocation,
        infoWindow: InfoWindow(title: 'Consegna', snippet: 'Roma'),
      ),
    ]);
    _polylines.add(Polyline(
      polylineId: const PolylineId('route'),
      points: [_pickupLocation, _deliveryLocation],
      color: Colors.blue,
      width: 5,
    ));
    mapController.moveCamera(CameraUpdate.newLatLngZoom(_pickupLocation, 6));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli Ordine'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfilePage()
                )
              );
            },
          ),
        ],
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: SizedBox(
                  height: 250,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _pickupLocation,
                      zoom: 6,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.tag, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'ID Ordine: 12345',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.user, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Cliente: Mario Rossi',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.euroSign, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Totale: €150.00',
                            style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.locationArrow, size: 20, color: Colors.orange),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ritiro',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Località: Milano'),
                            const SizedBox(height: 4),
                            Text('Data: 12/10/2024'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.locationArrow, size: 20, color: Colors.orange),
                                const SizedBox(width: 8),
                                const Text(
                                  'Consegna',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Località: Roma'),
                            const SizedBox(height: 4),
                            Text('Data: 15/10/2024'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.truck, size: 20, color: Colors.orange),
                                const SizedBox(width: 8),
                                const Text(
                                  'Dati del mezzo / Allestimenti',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Tipo mezzo: Camion'),
                            const SizedBox(height: 4),
                            Text('Allestimenti: Refrigerato'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.infoCircle, size: 20, color: Colors.orange),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ulteriori specifiche',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Specifiche: Nessuna'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dettagli Merce e Stivaggio',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Q.ta bancali: 5'),
                              Text('Tipo Merce: Elettronica'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Dimensioni: 100x100 cm'),
                              Text('Altezza: 50 cm'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Peso: 200 kg'),
                              Text('Totale Peso Generale: 200 kg'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.info, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Comunicazioni importanti',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Nessuna comunicazione importante.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
