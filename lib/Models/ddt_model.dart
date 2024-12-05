class DDTModel {
  final String numero;
  final DateTime data;
  final String mittente;
  final String destinatario;
  final String causale;
  final List<Merce> merci;

  DDTModel({
    required this.numero,
    required this.data,
    required this.mittente,
    required this.destinatario,
    required this.causale,
    required this.merci,
  });
}

class Merce {
  final String descrizione;
  final int quantita;
  final double peso;

  Merce({
    required this.descrizione,
    required this.quantita,
    required this.peso,
  });
}
