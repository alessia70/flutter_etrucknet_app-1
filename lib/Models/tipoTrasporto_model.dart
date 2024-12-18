class TipoTrasporto {
  final int id;
  final String name;

  TipoTrasporto({
    required this.id,
    required this.name,
  });

  factory TipoTrasporto.fromJson(Map<String, dynamic> json) {
    return TipoTrasporto(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
