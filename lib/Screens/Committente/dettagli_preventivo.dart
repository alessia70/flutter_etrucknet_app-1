import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreventivoDetailsPage extends StatefulWidget {
  final Map<String, String> preventivo;
  final String orderStatus;
  final String orderId;

  const PreventivoDetailsPage({
    super.key,
    required this.preventivo,
    required this.orderStatus,
    required this.orderId,
  });

  @override
  _PreventivoDetailsPageState createState() => _PreventivoDetailsPageState();
}

class _PreventivoDetailsPageState extends State<PreventivoDetailsPage> {
  late GoogleMapController mapController;
  late LatLng _pickupLocation;
  late LatLng _deliveryLocation;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    String pickupLat = widget.preventivo['pickupLat'] ?? '0.0';
    String pickupLng = widget.preventivo['pickupLng'] ?? '0.0';
    String deliveryLat = widget.preventivo['deliveryLat'] ?? '0.0';
    String deliveryLng = widget.preventivo['deliveryLng'] ?? '0.0'; 

    _pickupLocation = LatLng(double.parse(pickupLat), double.parse(pickupLng));
    _deliveryLocation = LatLng(double.parse(deliveryLat), double.parse(deliveryLng));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _markers.addAll([
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation,
        infoWindow: InfoWindow(title: 'Ritiro', snippet: widget.preventivo['localitaRitiro'] ?? 'Milano'),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: _deliveryLocation,
        infoWindow: InfoWindow(title: 'Consegna', snippet: widget.preventivo['localitaConsegna'] ?? 'Roma'),
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
    //String title = widget.orderStatus;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli Preventivo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: SideMenuCommittente(),
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
                          Text(
                            'ID Ordine: ${widget.orderId}', 
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.user, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Tipologia Trasporto: ${widget.preventivo['tipo']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                            Text('Località: ${widget.preventivo['localitaRitiro']}'),
                            const SizedBox(height: 4),
                            Text('Data: ${widget.preventivo['dataRitiro']}'),
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
                            Text('Località: ${widget.preventivo['localitaConsegna']}'),
                            const SizedBox(height: 4),
                            Text('Data: ${widget.preventivo['dataConsegna']}'),
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
                            children: [
                              Text('Q.ta bancali: ${widget.preventivo['quantitaBancali']}'),
                              Text('Tipo Merce: ${widget.preventivo['tipoMerce']}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Dimensioni: ${widget.preventivo['dimensioni']}'),
                              Text('Altezza: ${widget.preventivo['altezza']}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Peso: ${widget.preventivo['peso']}'),
                              Text('Totale Peso Generale: ${widget.preventivo['pesoTotale']}'),
                            ],
                          ),
                        ],
                      ),
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
