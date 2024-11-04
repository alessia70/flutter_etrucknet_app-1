import 'package:flutter/material.dart';

class TransportDetailPage extends StatelessWidget {
  final String id;
  final String tipoTrasporto;
  final String distanza;
  final String tempo;
  final String localitaRitiro;
  final String dataRitiro;
  final String localitaConsegna;
  final String dataConsegna;
  final String mezziAllestimenti;
  final String ulterioriSpecifiche;
  final List<Map<String, String>> dettagliMerce;

  TransportDetailPage({
    required this.id,
    required this.tipoTrasporto,
    required this.distanza,
    required this.tempo,
    required this.localitaRitiro,
    required this.dataRitiro,
    required this.localitaConsegna,
    required this.dataConsegna,
    required this.mezziAllestimenti,
    required this.ulterioriSpecifiche,
    required this.dettagliMerce,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli Trasporto'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Tratta', Icons.location_on),
                      SizedBox(height: 10),
                      Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: Center(child: Text('Mappa - implementa qui')),
                      ),
                      SizedBox(height: 10),
                      Text('Distanza: $distanza', style: TextStyle(fontSize: 16)),
                      Text('Tempo: $tempo', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Dati Trasporto', Icons.info),
                      SizedBox(height: 10),
                      Text('ID: $id', style: TextStyle(fontSize: 16)),
                      Text('Tipologia Trasporto: $tipoTrasporto', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildLocationCard('Ritiro', localitaRitiro, dataRitiro),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildLocationCard('Consegna', localitaConsegna, dataConsegna),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDetailCard('Dati Mezzo', mezziAllestimenti),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailCard('Ulteriori Specifiche', ulterioriSpecifiche),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Dettagli Merce e Stivaggio', Icons.local_shipping),
                      SizedBox(height: 10),
                      Text('Totale Generale Peso: ${_calculateTotalWeight()} Kg', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      _buildMerceTable(),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLocationCard(String title, String location, String date) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title, Icons.place),
            SizedBox(height: 10),
            Text('Località: $location', style: TextStyle(fontSize: 16)),
            Text('Data: $date', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String content) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title, Icons.info_outline),
            SizedBox(height: 10),
            Text(content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildMerceTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: {
        0: FixedColumnWidth(80),
        1: FixedColumnWidth(100),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(70),
        4: FixedColumnWidth(70),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Q.ta Bancali', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Tipo Merce', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Dimensioni', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Altezza', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Peso', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        ...dettagliMerce.map((merce) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(merce['qta']!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(merce['tipo']!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(merce['dimensioni']!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(merce['altezza']!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(merce['peso']!),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  String _calculateTotalWeight() {
    int totalWeight = dettagliMerce.fold(0, (sum, item) => sum + int.parse(item['peso']!));
    return totalWeight.toString();
  }
}
