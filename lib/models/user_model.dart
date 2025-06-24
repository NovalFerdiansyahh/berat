class UserModel {
  final String nama;
  final String email;
  final String noTelepon;
  final String tanggalLahir;
  final String role;

  UserModel({
    required this.nama,
    required this.email,
    required this.noTelepon,
    required this.tanggalLahir,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nama: json['nama'] ?? '-',
      email: json['email'] ?? '-',
      noTelepon: json['no_telepon'] ?? '-',
      tanggalLahir: json['tanggal_lahir'] ?? '-',
      role: json['role'] ?? '-',
    );
  }
}
