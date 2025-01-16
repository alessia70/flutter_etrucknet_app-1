import 'package:flutter/material.dart';

class CamionDisponibiliAltriVettoriScreen extends StatelessWidget {
  const CamionDisponibiliAltriVettoriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camion Disponibili di Altri Vettori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(context),
            SizedBox(height: 16),
            _buildTruckTable(context),
          ],
        ),
      ),
    );
  }
  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Cerca camion disponibili',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.search),
      ),
    );
  }
  Widget _buildTruckTable(BuildContext context) {
    return Card(
      elevation: 4,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Tipo Mezzo')),
            DataColumn(label: Text('Allestimento')),
            DataColumn(label: Text('Spazio Disponibile')),
            DataColumn(label: Text('Località Carico')),
            DataColumn(label: Text('Località Scarico')),
            DataColumn(label: Text('Data Ritiro')),
            DataColumn(label: Text('')),
            DataColumn(label: Text('')),
          ],
          rows: List<DataRow>.generate( 5,
            (index) => DataRow(cells: [
              DataCell(Text('Tipo ${index + 1}')),
              DataCell(Text('Allestimento ${index + 1}')),
              DataCell(Text('${(index + 1) * 100} cm')),
              DataCell(Text('Località Carico ${index + 1}')),
              DataCell(Text('Località Scarico ${index + 1}')),
              DataCell(Text('01/01/2024')),
              DataCell(
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Aggiungi logica per modificare il camion
                  },
                ),
              ),
              DataCell(
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Aggiungi logica per eliminare il camion
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
