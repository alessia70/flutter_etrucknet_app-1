List<T> searchItems<T extends HasToJson>(
  List<T> items,
  String query,
  List<String> searchFields,
) {
  if (query.isEmpty) {
    return List.from(items); 
  }

  return items.where((item) {
    return searchFields.any((field) {
      var value = item.toJson()[field];
      return value != null && value.toString().toLowerCase().contains(query.toLowerCase());
    });
  }).toList();
}

abstract class HasToJson {
  Map<String, dynamic> toJson();
}

