import 'package:flutter/material.dart';

class CamionDisponibiliGrid extends StatelessWidget {
  final List<Map<String, dynamic>> camion;

  const CamionDisponibiliGrid({Key? key, required this.camion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderCell('Tipo Mezzo', flex: 2),
              _buildHeaderCell('Allestimento', flex: 2),
              _buildHeaderCell('Spazio Disp.', flex: 2),
              _buildHeaderCell('Luogo Carico', flex: 2),
              _buildHeaderCell('Luogo Scarico', flex: 2),
              _buildHeaderCell('Data Ritiro', flex: 2),
            ],
          ),
        ),
        Expanded(
          child: camion.isEmpty
              ? _buildEmptyTable()
              : _buildDataGrid(),
        ),
      ],
    );
  }
  Widget _buildHeaderCell(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget _buildDataGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: camion.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 5, 
      ),
      itemBuilder: (context, index) {
        final truck = camion[index];
        return Card(
          color: Colors.orange.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDataCell(truck['vehicleData'] ?? 'N/A', flex: 2),
              _buildDataCell(truck['allestimento'] ?? 'N/A', flex: 2),
              _buildDataCell('${truck['availableSpace'] ?? 'N/A'}', flex: 2),
              _buildDataCell(truck['localitaCarico'] ?? 'N/A', flex: 2),
              _buildDataCell(truck['localitaScarico'] ?? 'N/A', flex: 2),
              _buildDataCell(truck['loadingDate'] ?? 'N/A', flex: 2),
            ],
          ),
        );
      },
    );
  }
  Widget _buildDataCell(String data, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        data,
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Tabella vuota
  Widget _buildEmptyTable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping, color: Colors.orange, size: 50),
          const SizedBox(height: 16),
          Text(
            'Nessun camion disponibile',
            style: TextStyle(fontSize: 16, color: Colors.orange.shade700),
          ),
        ],
      ),
    );
  }
}
