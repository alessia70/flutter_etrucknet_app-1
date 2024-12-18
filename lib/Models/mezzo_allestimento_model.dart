class TipoMezzoAllestimento {
  final int id;
  final String name;

  TipoMezzoAllestimento({required this.id, required this.name});

  factory TipoMezzoAllestimento.fromJson(Map<String, dynamic> json) {
    return TipoMezzoAllestimento(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
