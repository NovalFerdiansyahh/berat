class Artikel {
  final String idArtikel;
  final String judul;
  final String isi;
  final String? gambar;
  final String createdAt;
  final String sumber; 

  Artikel({
    required this.idArtikel,
    required this.judul,
    required this.isi,
    this.gambar,
    required this.createdAt,
    required this.sumber,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      idArtikel: json['id_artikel'],
      judul: json['judul'],
      isi: json['isi'],
      gambar: json['gambar'],
      createdAt: json['created_at'] is String
          ? json['created_at']
          : json['created_at']['date'],
      sumber: json['nama_user'] ?? 'Tidak diketahui',
    );
  }

  static List<Artikel> fromJsonList(List jsonList) {
    return jsonList.map((json) => Artikel.fromJson(json)).toList();
  }
}
