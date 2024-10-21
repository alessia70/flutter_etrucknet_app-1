import 'package:flutter/material.dart';

class MessagesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  void addMessage(Map<String, dynamic> newMessage) {
    _messages.add(newMessage);
    notifyListeners();
  }
}

