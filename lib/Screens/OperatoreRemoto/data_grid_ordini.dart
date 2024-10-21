import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/dettagli_ordine.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/modifica_ordine_page.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/quota_trasportatore_page.dart';

class OrdersGrid extends StatefulWidget {
  final List<Order> orders;

  const OrdersGrid({Key? key, required this.orders}) : super(key: key);

  @override
  _OrdersGridState createState() => _OrdersGridState();
}

class _OrdersGridState extends State<OrdersGrid> {
  late List<Order> orders;

  @override
  void initState() {
    super.initState();
    // Copia la lista degli ordini
    orders = widget.orders;
  }

  @override
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
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
                    color: Colors.orange,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Data: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${order.date.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(color: Colors.black),
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
                color: Colors.black,
              ),
            ),
            iconColor: Colors.orange,
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
                              const SizedBox(height: 8),
                              Text('Carico:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.loadingDate} a ${order.loadingLocation}, ${order.loadingProvince}, ${order.loadingCountry}'),
                              if (order.isLoadingMandatory)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Carico Tassativo', style: TextStyle(color: Colors.red)),
                                ),
                              const SizedBox(height: 16),

                              Text('Scarico:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.unloadingDate} a ${order.unloadingLocation}, ${order.unloadingProvince}, ${order.unloadingCountry}'),

                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Scarico Non Tassativo', style: TextStyle(color: Colors.green)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text('Offerta:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('€${order.offerAmount}'),
                              const SizedBox(height: 8),
                              Text('Corresponsdenze:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.correspondenceCount}'),
                              const SizedBox(height: 8),
                              Text('Budget Stimato:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('€${order.estimatedBudget}'),
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
                    icon: const Icon(Icons.details, color: Colors.orange),
                    tooltip: 'Dettagli',
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditOrderForm(order: order),
                        ),
                      ).then((updatedOrder) {
                        if (updatedOrder != null) {
                          setState(() {
                            // Aggiorna l'ordine nella lista se necessario
                          });
                        }
                      });
                    },
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    tooltip: 'Modifica',
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendQuotePage(orderId: order.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.attach_money, color: Colors.orange),
                    tooltip: 'Quota Trasportatore',
                  ),
                  IconButton(
                    onPressed: () {
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
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
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Elimina'),
                                onPressed: () {
                                  setState(() {
                                    onDeleteOrder(order);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.orange),
                    tooltip: 'Elimina',
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
