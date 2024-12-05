import 'package:flutter/material.dart';

class FeedbackPopup extends StatefulWidget {
  @override
  _FeedbackPopupState createState() => _FeedbackPopupState();
}

class _FeedbackPopupState extends State<FeedbackPopup> {
  int selectedStars = 0;
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Feedback"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < selectedStars ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedStars = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Aggiungi un commento',
                hintText: 'Scrivi qui il tuo feedback...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Bottone Chiudi
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Chiudi"),
        ),
        // Bottone Salva
        TextButton(
          onPressed: () {
            if (selectedStars > 0 || feedbackController.text.isNotEmpty) {
              // Invia il feedback o esegui altra logica
              print("Stelle selezionate: $selectedStars");
              print("Commento: ${feedbackController.text}");

              // Chiudi il dialog dopo il salvataggio
              Navigator.of(context).pop();
            } else {
              // Mostra un messaggio di errore se non è stato inserito nulla
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Per favore, aggiungi un feedback o seleziona le stelle."),
              ));
            }
          },
          child: Text("Salva"),
        ),
      ],
    );
  }
}
