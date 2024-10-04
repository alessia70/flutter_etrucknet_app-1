import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

class PDFGenerator {
  static Future<Uint8List> generatePDF(Map<String, dynamic> estimate) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Dettagli Stima', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('ID: ${estimate['id']}'),
                pw.Text('Carico: ${estimate['carico']}'),
                pw.Text('Scarico: ${estimate['scarico']}'),
                pw.Text('Stimato: ${estimate['stimato']}'),
                pw.Text('Data: ${estimate['data']}'),
                pw.Text('Tipo di Merce: ${estimate['specifiche'] ?? "N/A"}'),
              ],
            ),
          );
        },
      ),
    );
    return await pdf.save(); 
  }
}
