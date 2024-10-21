import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/dettagli_ordine.dart';

class OrdersGrid extends StatelessWidget {
  final List<Order> orders;

  const OrdersGrid({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordine ID: ${order.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange, // Colore arancione per l'ID
                  ),
                ),
                // Data con solo il titolo in grassetto
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Data: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Titolo "Data" in nero e bold
                        ),
                      ),
                      TextSpan(
                        text: '${order.date.toLocal().toString().split(' ')[0]}', // Valore della data normale
                        style: const TextStyle(color: Colors.black), // Colore del testo
                      ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Nome Cliente: ${order.customerName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black, // Nome cliente in nero e bold
              ),
            ),
            iconColor: Colors.orange, // Colore dell'icona di espansione
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informazioni sul carico e scarico
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Colonna di sinistra per Carico e Scarico
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Informazioni sul carico
                              const SizedBox(height: 8),
                              Text('Carico:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.loadingDate} a ${order.loadingLocation}, ${order.loadingProvince}, ${order.loadingCountry}'),

                              // Blocco Carico Tassativo
                              if (order.isLoadingMandatory)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Ridotto il padding
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red), // Bordo rosso
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Carico Tassativo', style: TextStyle(color: Colors.red)),
                                ),

                              const SizedBox(height: 16), // Spazio tra Carico e Scarico

                              // Informazioni sullo scarico
                              Text('Scarico:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.unloadingDate} a ${order.unloadingLocation}, ${order.unloadingProvince}, ${order.unloadingCountry}'),

                              // Blocco Scarico Non Tassativo
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Ridotto il padding
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green), // Bordo verde per indicare scarico non tassativo
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Scarico Non Tassativo', style: TextStyle(color: Colors.green)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16), // Spazio tra le colonne

                        // Colonna di destra per Offerta, Corresponsdenze, e Budget Stimato
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Offerte
                              const SizedBox(height: 8),
                              Text('Offerta:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('€${order.offerAmount}'),

                              // Corresponsdenze
                              const SizedBox(height: 8),
                              Text('Corresponsdenze:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.correspondenceCount}'),

                              // Budget stimato
                              const SizedBox(height: 8),
                              Text('Budget Stimato:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('€${order.estimatedBudget}'),

                              const SizedBox(height: 16), // Spazio sopra i bottoni
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.details, color: Colors.orange), // Icona per dettagli
                    tooltip: 'Dettagli', // Tooltip per il bottone
                  ),
                  IconButton(
                    onPressed: () {
                      // Logica per modificare ordine
                    },
                    icon: const Icon(Icons.edit, color: Colors.orange), // Icona per modificare
                    tooltip: 'Modifica', // Tooltip per il bottone
                  ),
                  IconButton(
                    onPressed: () {
                      // Logica per inserire quota trasportatore
                    },
                    icon: const Icon(Icons.attach_money, color: Colors.orange), // Icona per quota trasportatore
                    tooltip: 'Quota Trasportatore', // Tooltip per il bottone
                  ),
                  IconButton(
                    onPressed: () {
                       // Chiedi conferma prima di eliminare
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Conferma Eliminazione'),
                            content: const Text('Sei sicuro di voler eliminare questo ordine?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Annulla'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Chiudi il dialogo
                                },
                              ),
                              TextButton(
                                child: const Text('Elimina'),
                                onPressed: () {
                                  onDeleteOrder(order); // Chiama la funzione di eliminazione
                                  Navigator.of(context).pop(); // Chiudi il dialogo
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.orange), // Icona per eliminare
                    tooltip: 'Elimina', // Tooltip per il bottone
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  void onDeleteOrder(Order order) {
    orders.removeWhere((o) => o.id == order.id);
  }
}
