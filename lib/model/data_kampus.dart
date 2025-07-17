
class DataKampus {
  final int? id;
  final String nama;
  final String alamat;
  final String telpon;
  final String kategori;
  final double latitude;
  final double longitude;
  final String jurusan;

  DataKampus({
    this.id,
    required this.nama,
    required this.alamat,
    required this.telpon,
    required this.kategori,
    required this.latitude,
    required this.longitude,
    required this.jurusan,
  });

  factory DataKampus.fromJson(Map<String, dynamic> json) {
    return DataKampus(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      telpon: json['telpon'],
      kategori: json['kategori'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      jurusan: json['jurusan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'telpon': telpon,
      'kategori': kategori,
      'latitude': latitude,
      'longitude': longitude,
      'jurusan': jurusan,
    };
  }
}
