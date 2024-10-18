import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

class PDFViewerScreen extends StatelessWidget {
  final String customerName;
  final String route;
  final String possibleEquipments;
  final String requestDate;
  final double distance;
  final List<Item> items;
  final String estimatedCostRange;

  const PDFViewerScreen({
    super.key,
    required this.customerName,
    required this.route,
    required this.possibleEquipments,
    required this.requestDate,
    required this.distance,
    required this.items,
    required this.estimatedCostRange, required Uint8List pdfData,
  });

  // Funzione per generare i dati PDF
  Future<Uint8List> generatePdf() {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('STIMA COSTO DEL TRASPORTO', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Richiesta effettuata da: $customerName'),
              pw.Text('Tratta: $route'),
              pw.Text('Possibili allestimenti: $possibleEquipments'),
              pw.Text('in data: $requestDate'),
              pw.Text('La tratta prevede i seguenti KM: ${distance.toString()}'),
              pw.SizedBox(height: 20),
              pw.Text('Quantita\' Tipo merce Misure Collo Altezza massima Peso Totale', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              for (var item in items) 
                pw.Text('${item.quantity} ${item.type} ${item.dimensions} ${item.height} ${item.totalWeight}'),
              pw.SizedBox(height: 20),
              pw.Text('Stima indicativa del trasporto (IVA esclusa se dovuta) da $estimatedCostRange'),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizza PDF'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: PdfPreview(
          build: (format) => generatePdf(),
          canChangeOrientation: false,
          canChangePageFormat: false,
        ),
      ),
    );
  }
}

class Item {
  final int quantity;
  final String type;
  final String dimensions; // E.g. "240 x 1360 cm"
  final double height; // Altezza massima
  final double totalWeight; // Peso Totale

  Item({
    required this.quantity,
    required this.type,
    required this.dimensions,
    required this.height,
    required this.totalWeight,
  });
}
