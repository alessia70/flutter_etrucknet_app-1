List<T> searchItems<T extends HasToJson>(
  List<T> items,
  String query,
  List<String> searchFields,
) {
  if (query.isEmpty) {
    return List.from(items); // Restituisce tutti gli elementi se la query è vuota
  }

  return items.where((item) {
    return searchFields.any((field) {
      var value = item.toJson()[field]; // Assicurati che toJson() sia definito
      return value != null && value.toString().toLowerCase().contains(query.toLowerCase());
    });
  }).toList();
}

abstract class HasToJson {
  Map<String, dynamic> toJson();
}

