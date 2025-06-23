import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constanta.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String selectedRole = 'Penulis';
  bool isLoading = false;

  Future<void> registerUser() async {
    final username = usernameController.text;
    final email = emailController.text;
    final phone = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final role = selectedRole.toLowerCase();

    if ([username, email, phone, password, confirmPassword].any((e) => e.isEmpty)) {
      showSnackBar('Semua field wajib diisi');
      return;
    }

    if (password != confirmPassword) {
      showSnackBar('Password tidak sama');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': username,
          'email': email,
          'no_telepon': phone,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        showSnackBar('Registrasi berhasil! Silakan login');
        Navigator.pop(context); // Kembali ke halaman login
      } else {
        print('Gagal daftar: ${response.body}');
        showSnackBar('Gagal daftar. Coba lagi.');
      }
    } catch (e) {
      showSnackBar('Terjadi kesalahan: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'BERAT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal[200],
                letterSpacing: 2,
              ),
            ),
            Text('Berita Terakurat', style: TextStyle(fontSize: 14, color: Colors.teal[200])),
            const SizedBox(height: 40),

            Align(alignment: Alignment.centerLeft, child: Text("Username")),
            TextField(controller: usernameController, decoration: InputDecoration(hintText: 'Sigma')),
            const SizedBox(height: 10),

            Align(alignment: Alignment.centerLeft, child: Text("Email")),
            TextField(controller: emailController, decoration: InputDecoration(hintText: 'Sigma@gmail.com')),
            const SizedBox(height: 10),

            Align(alignment: Alignment.centerLeft, child: Text("Telepon")),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: '+62 000000'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),

            Align(alignment: Alignment.centerLeft, child: Text("Password")),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: '********'),
            ),
            const SizedBox(height: 10),

            Align(alignment: Alignment.centerLeft, child: Text("Confirmation password")),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(hintText: '********'),
            ),
            const SizedBox(height: 20),

            Align(alignment: Alignment.centerLeft, child: Text("Daftar sebagai")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'Penulis',
                  groupValue: selectedRole,
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
                const Text("Penulis"),
                Radio<String>(
                  value: 'Pembaca',
                  groupValue: selectedRole,
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
                const Text("Pembaca"),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text("Daftar"),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
