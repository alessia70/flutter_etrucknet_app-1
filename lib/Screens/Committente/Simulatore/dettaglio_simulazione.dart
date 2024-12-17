import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DettaglioSimulazioneScreen extends StatefulWidget {
  final Map<String, dynamic> simulation;

  const DettaglioSimulazioneScreen({Key? key, required this.simulation}) : super(key: key);

  @override
  _DettaglioSimulazioneScreenState createState() => _DettaglioSimulazioneScreenState();
}

class _DettaglioSimulazioneScreenState extends State<DettaglioSimulazioneScreen> {
  late GoogleMapController mapController;

  static const LatLng _center = LatLng(45.4642, 9.1900);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _cancelSimulation() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Simulazione'),
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
                    initialCameraPosition: const CameraPosition(
                      target: _center,
                      zoom: 10,
                    ),
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
                          Icon(FontAwesomeIcons.chartLine, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'ID Simulazione: ${widget.simulation['id'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.cogs, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Tipo Simulazione: ${widget.simulation['tipo_simulazione'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.clock, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Data: ${widget.simulation['data'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
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
                                  'Punto di Partenza',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Località: ${widget.simulation['partenza_localita'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Provincia: ${widget.simulation['partenza_provincia'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Stato: ${widget.simulation['partenza_stato'] ?? 'N/A'}'),
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
                                  'Punto di Arrivo',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Località: ${widget.simulation['arrivo_localita'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Provincia: ${widget.simulation['arrivo_provincia'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Stato: ${widget.simulation['arrivo_stato'] ?? 'N/A'}'),
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
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.infoCircle, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Ulteriori Dettagli',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Descrizione: ${widget.simulation['descrizione'] ?? 'N/A'}'),
                      const SizedBox(height: 4),
                      Text('Risultati: ${widget.simulation['risultati'] ?? 'N/A'}'),
                    ],
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
                          Icon(FontAwesomeIcons.exclamationTriangle, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Comunicazioni Importanti',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(widget.simulation['comunicazioni_importanti'] ?? 'N/A'),
                    ],
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: _cancelSimulation,
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                child: Icon(Icons.close, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
