import 'package:flutter/material.dart';

class SendQuotePage extends StatelessWidget {
  final String orderId; // Order ID received from the previous page
  final TextEditingController shipperController = TextEditingController();

  SendQuotePage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invia Quota Trasportatore'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Handle save action
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
              // Order ID Input
              Text(
                'ID Ordine: $orderId',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                'Cerca Trasportatore',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: shipperController,
                decoration: InputDecoration(
                  labelText: 'Inserisci Nome Trasportatore',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle send action
                      _sendQuote(context);
                    },
                    child: Text('Invia'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Handle cancel action
                      Navigator.of(context).pop();
                    },
                    child: Text('Annulla', style: TextStyle(color: Colors.grey),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendQuote(BuildContext context) {
    // Implement the send quote functionality here
    String shipperName = shipperController.text;

    // For demonstration purposes
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quota Inviata'),
          content: Text('ID Ordine: $orderId\nTrasportatore: $shipperName'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
