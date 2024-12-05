import 'package:flutter_etrucknet_new/Models/ddt_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateDDT(DDTModel ddt) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Documento di Trasporto (DDT)', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('Numero: ${ddt.numero}', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Data: ${ddt.data.toLocal().toString().split(' ')[0]}', style: pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 20),
          pw.Text('Mittente: ${ddt.mittente}', style: pw.TextStyle(fontSize: 14)),
          pw.Text('Destinatario: ${ddt.destinatario}', style: pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 20),

          pw.Text('Causale del trasporto: ${ddt.causale}', style: pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 20),
          pw.Text('Merci trasportate:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.TableHelper.fromTextArray(
            context: context,
            data: [
              ['Descrizione', 'Quantità', 'Peso (Kg)'],
              ...ddt.merci.map((merce) => [merce.descrizione, merce.quantita.toString(), merce.peso.toStringAsFixed(2)]),
            ],
          ),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
