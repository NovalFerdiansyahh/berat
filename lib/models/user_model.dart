class UserModel {
  final String name;
  final String email;
  final String phone;
  final String birthDate;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '-',
      phone: json['phone'] ?? '-',
      birthDate: json['birth_date'] ?? '-',
    );
  }
}
