import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/change_stima_to_order.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/condividi_stima.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/dettagli_stima_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/modifica_stima_page.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/pdf_viewer_screen.dart';
import 'package:flutter_etrucknet_new/Widgets/generate_pdf.dart';
import 'package:provider/provider.dart';
import 'package:flutter_etrucknet_new/Services/estimates_provider.dart';

class DataGridStime extends StatefulWidget {
  const DataGridStime({super.key});

  @override
  _DataGridStimeState createState() => _DataGridStimeState();
}

class _DataGridStimeState extends State<DataGridStime> {
  final Set<int> _expandedEstimates = <int>{};

  @override
  Widget build(BuildContext context) {
    final estimatesProvider = Provider.of<EstimatesProvider>(context);
    final estimates = estimatesProvider.estimates;

    if (estimates.isEmpty) {
      return Center(
        child: Text('Nessuna stima disponibile'),
      );
    }

    return ListView.builder(
      itemCount: estimates.length,
      itemBuilder: (context, index) {
        final estimate = estimates[index];
        final isExpanded = _expandedEstimates.contains(index);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              ListTile(
                title: Text('Stima ${estimate['id']}', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                subtitle: Text('Carico: ${estimate['carico']} - Scarico: ${estimate['scarico']}'),
                trailing: Text('${estimate['stimato']}'),
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedEstimates.remove(index);
                    } else {
                      _expandedEstimates.add(index);
                    }
                  });
                },
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data: ${estimate['data']}'),
                      Text('Tipo di Merce: ${estimate['specifiche'] ?? "N/A"}'),
                      SizedBox(height: 10),
                      _buildActionButtons(estimate),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> estimate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.visibility_outlined, color: const Color.fromARGB(255, 247, 163, 68)),
          onPressed: () { 
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DettaglioStimaScreen(estimate: estimate),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.orange),
          onPressed: () async {
            try {
              Uint8List pdfData = await PDFGenerator.generatePDF(estimate);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewerScreen(
                    pdfData: pdfData,
                    customerName: estimate['cliente'] ?? 'N/A',
                    route: 'da ${estimate['carico']} a ${estimate['scarico']}',
                    possibleEquipments: estimate['specifiche'] ?? 'N/A',
                    requestDate: estimate['dataRichiesta'] ?? 'N/A',
                    distance: estimate['distanza'] ?? 0.0,
                    items: estimate['items'] != null
                        ? (estimate['items'] as List).map<Item>((item) {
                            return Item(
                              quantity: item['quantita'],
                              type: item['tipoMerce'],
                              dimensions: item['dimensioni'],
                              height: item['altezza'],
                              totalWeight: item['pesoTotale'],
                            );
                          }).toList()
                        : [],
                    estimatedCostRange: estimate['costoStimato'] ?? 'N/A',
                  ),
                ),
              );
            } catch (e) {
              print('Si è verificato un errore: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Errore nella generazione del PDF')),
              );
            }
          }, 
        ),
        IconButton(
          icon: Icon(Icons.emoji_transportation_outlined, color: const Color.fromARGB(255, 179, 107, 0)),
          onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeStimaToOrder(
                  stimaMerceList: estimate['merce'] ?? [],
                  stimaTransportType: estimate['transportType'] ?? '',
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.share, color: const Color.fromARGB(255, 40, 158, 24)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CondividiStima(estimate: estimate);
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.draw_rounded, color: const Color.fromARGB(255, 5, 105, 9)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModificaStimaScreen(estimate: estimate), // Passa l'oggetto stima
              ),
            );
          },
        ),
      ],
    );
  }
}
