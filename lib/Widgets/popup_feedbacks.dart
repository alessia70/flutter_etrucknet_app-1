import 'package:flutter/material.dart';

class FeedbackPopup extends StatefulWidget {
  const FeedbackPopup({super.key});

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
        TextButton(
          onPressed: () {
            if (selectedStars > 0 || feedbackController.text.isNotEmpty) {
              Navigator.of(context).pop();
            } else {
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
