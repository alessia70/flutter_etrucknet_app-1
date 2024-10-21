import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_etrucknet_new/Services/message_provider.dart';

class MessaggiGrid extends StatefulWidget {
  const MessaggiGrid({super.key});

  @override
  _MessaggiGridState createState() => _MessaggiGridState();
}

class _MessaggiGridState extends State<MessaggiGrid> {
  final Set<int> _expandedMessages = <int>{};

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<MessagesProvider>(context).messages;

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isExpanded = _expandedMessages.contains(index);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? 300 : 100,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    '${message['id']}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Data ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          message['date'] ?? "N/A",
                        ),
                      ),
                      SizedBox(width: 1),
                      Expanded(
                        child: Text(
                          'Oggetto ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          message['object'] ?? "N/A",
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                    color: Colors.orange,
                  ),
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedMessages.remove(index);
                      } else {
                        _expandedMessages.add(index);
                      }
                    });
                  },
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Tipo Utente', message['user_type']),
                        const SizedBox(height: 8),
                        _buildDetailRow('Tipo Allestimento', message['setup_type']),
                        const SizedBox(height: 8),
                        _buildDetailRow('Nazione', message['country']),
                        const SizedBox(height: 8), 
                        _buildDetailRow('Regione', message['region']),
                        const SizedBox(height: 8),
                        _buildDetailRow('Provincia', message['province']),
                        const SizedBox(height: 8),
                        _buildDetailRow('Corrispondenze', message['correspondences']),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 3),
        Expanded(
          child: Text(
            value ?? "N/A",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
