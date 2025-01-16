import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:country_picker/country_picker.dart';

Future<List<Location>> getLocations(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    return locations;
  } catch (e) {
    log("Errore durante il recupero delle località: $e");
    return [];
  }
}

void showCountryPickerDialog(BuildContext context, Function(Country) onSelect) {
  showCountryPicker(
    context: context,
    onSelect: onSelect,
  );
}
