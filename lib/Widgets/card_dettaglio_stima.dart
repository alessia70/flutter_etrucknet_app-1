import 'package:flutter/material.dart';
//import 'package:latlong2/latlong.dart';

class CardDettaglioStima extends StatelessWidget {
  final Map<String, dynamic> estimate;

  const CardDettaglioStima({super.key, required this.estimate});

  @override
  Widget build(BuildContext context) {
    /*LatLng caricoCoordinates = LatLng(
      estimate['carico_lat'] ?? 45.5236, // Latitudine predefinita
      estimate['carico_lon'] ?? -122.6750, // Longitudine predefinita
    );

    LatLng scaricoCoordinates = LatLng(
      estimate['scarico_lat'] ?? 45.5236,
      estimate['scarico_lon'] ?? -122.6750,
    );*/

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tratta: ${estimate['carico']} - ${estimate['scarico']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),

              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),

              // Mappa
             /* Container(
                height: 300, // Altezza fissa per la mappa
                child: FlutterMap(
                  options: MapOptions(
                    center: caricoCoordinates, // Centro della mappa
                    zoom: 9, // Livello di zoom
                  ),
                  layers: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: caricoCoordinates,
                          builder: (ctx) => Icon(
                            Icons.location_on,
                            color: Colors.green, // Marker verde per il carico
                            size: 40,
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: scaricoCoordinates,
                          builder: (ctx) => Icon(
                            Icons.location_on,
                            color: Colors.red, // Marker rosso per lo scarico
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),*/

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.location_on, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Distanza:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${estimate['distanza'] ?? 'N/A'} km',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.access_time, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Tempo:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${estimate['tempo'] ?? 'N/A'} h',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
