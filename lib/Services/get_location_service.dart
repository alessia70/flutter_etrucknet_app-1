import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:country_picker/country_picker.dart';

// Funzione per ottenere le località da un indirizzo
Future<List<Location>> getLocations(String address) async {
  try {
    // Ottieni le località a partire dall'indirizzo fornito
    List<Location> locations = await locationFromAddress(address);
    return locations;
  } catch (e) {
    print("Errore durante il recupero delle località: $e");
    return [];
  }
}

// Funzione per mostrare il selettore di paesi
void showCountryPickerDialog(BuildContext context, Function(Country) onSelect) {
  showCountryPicker(
    context: context,
    onSelect: onSelect,
  );
}
