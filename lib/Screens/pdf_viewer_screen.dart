import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PDFViewerScreen extends StatelessWidget {
  final Uint8List pdfData;

  const PDFViewerScreen({super.key, required this.pdfData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizza PDF'),
      ),
      body: PdfPreview(
        build: (format) => pdfData,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}
