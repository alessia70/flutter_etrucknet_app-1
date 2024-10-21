import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DettaglioStimaScreen extends StatefulWidget {
  final Map<String, dynamic> estimate;

  const DettaglioStimaScreen({Key? key, required this.estimate}) : super(key: key);

  @override
  _DettaglioStimaScreenState createState() => _DettaglioStimaScreenState();
}

class _DettaglioStimaScreenState extends State<DettaglioStimaScreen> {
  late GoogleMapController mapController;

  static const LatLng _center = LatLng(45.4642, 9.1900);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Stima'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card con la mappa
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

              // Box con ID stima, tipologia e stima effettiva
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
                            'ID Stima: ${widget.estimate['id'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.truck, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Tipologia Trasporto: ${widget.estimate['tipo_trasporto'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.euroSign, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Stima Effettiva: €${widget.estimate['stima_effettiva'] ?? '0.00'}',
                            style: const TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Riga con due colonne: Ritiro a sinistra, Consegna a destra
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
                            Text('Località: ${widget.estimate['ritiro_localita'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Provincia: ${widget.estimate['ritiro_provincia'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Stato: ${widget.estimate['ritiro_stato'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16), // Spazio tra i due box

                  // Box Consegna
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
                            Text('Località: ${widget.estimate['consegna_localita'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Provincia: ${widget.estimate['consegna_provincia'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Stato: ${widget.estimate['consegna_stato'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16), // Spazio tra i box

              // Dati del mezzo / Allestimenti
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
                                  'Dati del Mezzo / Allestimenti',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Tipologia: ${widget.estimate['mezzo_tipo'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Allestimenti: ${widget.estimate['allestimenti'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16), // Spazio tra i due box

                  // Ulteriori specifiche
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
                                  'Ulteriori Specifiche',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Note: ${widget.estimate['note'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Box con dettagli merce e stivaggio
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
                          Icon(FontAwesomeIcons.box, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Dettagli Merce e Stivaggio',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Quantità: ${widget.estimate['quantita'] ?? '0'}'),
                      const SizedBox(height: 4),
                      Text('Descrizione: ${widget.estimate['descrizione'] ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      const Text('Dimensioni:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Misura')),
                          DataColumn(label: Text('Valore')),
                        ],
                        rows: [
                          DataRow(cells: [
                            const DataCell(Text('Lunghezza')),
                            DataCell(Text('${widget.estimate['misura_lunghezza'] ?? 'N/A'} cm')),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('Larghezza')),
                            DataCell(Text('${widget.estimate['misura_larghezza'] ?? 'N/A'} cm')),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('Altezza')),
                            DataCell(Text('${widget.estimate['misura_altezza'] ?? 'N/A'} cm')),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Box Comunicazioni Importanti
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
                      Text(widget.estimate['comunicazioni_importanti'] ?? 'N/A'),
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
