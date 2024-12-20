class MercePericolosa {
  final int id;
  final String descrizioneIt;
  final String descrizioneEn;
  final String descrizioneRo;

  MercePericolosa({
    required this.id,
    required this.descrizioneIt,
    required this.descrizioneEn,
    required this.descrizioneRo,
  });

  factory MercePericolosa.fromJson(Map<String, dynamic> json) {
    return MercePericolosa(
      id: json['id'],
      descrizioneIt: json['descrizioneIt'] ?? 'Descrizione non disponibile',
      descrizioneEn: json['descrizioneEn'] ?? 'No English description',
      descrizioneRo: json['descrizioneRo'] ?? 'No Romanian description',
    );
  }

  List<MercePericolosa> mercePericolosaList = [
    MercePericolosa(id: 1, descrizioneIt: 'Materie ed oggetti esplosivi', descrizioneEn: 'Explosives', descrizioneRo: 'Materiale si substante explozive'),
    MercePericolosa(id: 2, descrizioneIt: 'Gas', descrizioneEn: 'Gas', descrizioneRo: 'Gaz'),
    MercePericolosa(id: 3, descrizioneIt: 'Materie liquide infiammabili', descrizioneEn: 'Flammable liquids', descrizioneRo: 'Lichide inflamabile'),
    MercePericolosa(id: 4, descrizioneIt: 'Materie solide infiammabili', descrizioneEn: 'Flammable solids', descrizioneRo: 'Solide inflamabile'),
    MercePericolosa(id: 5, descrizioneIt: 'Materie soggette ad infiammazione spontanea', descrizioneEn: 'Substances liable to spontaneous combustion', descrizioneRo: 'Substante predispuse la aprindere spontana'),
    MercePericolosa(id: 6, descrizioneIt: 'Materie che a contatto con l\'acqua sviluppano gas infiammabili', descrizioneEn: 'Substances which in contact with water emit flammable gases', descrizioneRo: 'Materialele în contact cu apa dezvolta gaze inflamabile'),
    MercePericolosa(id: 7, descrizioneIt: 'Materie comburenti', descrizioneEn: 'Reactive materials', descrizioneRo: 'Substante oxidante'),
    MercePericolosa(id: 8, descrizioneIt: 'Perossidi organici', descrizioneEn: 'Organic peroxides', descrizioneRo: 'Peroxizi organici'),
    MercePericolosa(id: 9, descrizioneIt: 'Materie tossiche', descrizioneEn: 'Toxic substances', descrizioneRo: 'Substante toxice'),
    MercePericolosa(id: 10, descrizioneIt: 'Materie infettive', descrizioneEn: 'Infectious', descrizioneRo: 'Substante infectioase'),
    MercePericolosa(id: 11, descrizioneIt: 'Materie radioattive', descrizioneEn: 'Radioactive materials', descrizioneRo: 'Materiale radioactive'),
    MercePericolosa(id: 12, descrizioneIt: 'Materie corrosive', descrizioneEn: 'Corrosive', descrizioneRo: 'Substante corozive'),
    MercePericolosa(id: 13, descrizioneIt: 'Materie ed oggetti pericolosi diversi', descrizioneEn: 'Miscellaneous dangerous substances and objects', descrizioneRo: 'Alte materiale si obiecte periculoase'),
  ];
}
