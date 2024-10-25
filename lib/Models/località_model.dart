class Localita {
  final String nazione;
  final String regione;
  final String citta;
  final String indirizzo;
  final String cap;

  Localita({
    required this.nazione,
    required this.regione,
    required this.citta,
    required this.indirizzo,
    required this.cap,
  });
}

List<Localita> localitaList = [
  Localita(nazione: "Italia", regione: "Lazio", citta: "Roma", indirizzo: "Via Roma 1", cap: "00100"),
  Localita(nazione: "Italia", regione: "Lombardia", citta: "Milano", indirizzo: "Via Milano 2", cap: "20100"),
];
