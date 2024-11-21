import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/profile_menu_t_screen.dart';

class TransportoEseguitioDetailPage extends StatelessWidget {
  final int id;
  final String tipoTrasporto;
  final String distanza;
  final String tempo;
  final String localitaRitiro;
  final String dataRitiro;
  final String localitaConsegna;
  final String dataConsegna;
  final List<Map<String, String>> dettagliTrasporto;
  final String mezziAllestimenti;
  final String ulterioriSpecifiche;
  final List<Map<String, String>> dettagliMerce;


  TransportoEseguitioDetailPage({
    required this.id,
    required this.tipoTrasporto,
    required this.distanza,
    required this.tempo,
    required this.localitaRitiro,
    required this.dataRitiro,
    required this.localitaConsegna,
    required this.dataConsegna,
    required this.dettagliTrasporto,
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
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ProfileTrasportatorePage())
              );
            },
          ),
        ],
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
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Tratta',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Dati Trasporto',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('ID: $id', style: TextStyle(fontSize: 16)),
                      Text('Tipologia Trasporto: $tipoTrasporto', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _buildFixedHeightLocationCard('Ritiro', localitaRitiro, dataRitiro),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: _buildFixedHeightLocationCard('Consegna', localitaConsegna, dataConsegna),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  _buildFixedHeightDetailCard('Dati Mezzo', mezziAllestimenti, 150.0),
                  SizedBox(height: 16),
                  _buildFixedHeightDetailCard('Ulteriori Specifiche', ulterioriSpecifiche, 150.0),
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

  Widget _buildFixedHeightLocationCard(String title, String location, String date) {
    double height = _calculateLocationCardHeight(location, date);
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title, Icons.place),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                location,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text(
              'Data: $date',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateLocationCardHeight(String location, String date) {
    double baseHeight = 150.0;
    if (location.length > 30 || date.length > 30) {
      baseHeight += 50;
    }
    return baseHeight;
  }

  Widget _buildFixedHeightDetailCard(String title, String content, double height) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title, Icons.info_outline),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerceTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(80),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(100),
          3: FixedColumnWidth(70),
          4: FixedColumnWidth(70),
        },
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Q.ta Bancali',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Tipo Merce',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Dimensioni',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Altezza',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Peso',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ...dettagliMerce.map((merce) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    merce['qta'] ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    merce['tipo'] ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    merce['dimensioni'] ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    merce['altezza'] ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    merce['peso'] ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  String _calculateTotalWeight() {
    int totalWeight = dettagliMerce.fold(0, (sum, item) => sum + int.parse(item['peso']!));
    return totalWeight.toString();
  }
}
