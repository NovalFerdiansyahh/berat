import 'dart:convert';
import 'package:berat/pages/halaman_register.dart';
import 'package:berat/pages/halaman_utama.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constanta.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> loginUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showSnackBar('Email dan password harus diisi');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/user'));

      if (response.statusCode == 200) {
        final List users = jsonDecode(response.body);

        final user = users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
          orElse: () => null,
        );

        if (user != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('idUser', user['id_user'].toString());
          await prefs.setString('role', user['role'].toString());
          await prefs.setString('idUser', user['id_user'].toString());
          await prefs.setString('nama', user['nama'].toString());
          await prefs.setString('tanggalLahir', user['tanggal_lahir'].toString());
          await prefs.setString('noTelepon', user['no_telepon'].toString());
          await prefs.setString('email', user['email'].toString());
          await prefs.setString('role', user['role'].toString());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HalamanUtama()),
          );
        } else {
          showSnackBar('Email atau password salah');
        }
      } else {
        showSnackBar('Gagal mengambil data dari server');
      }
    } catch (e) {
      showSnackBar('Terjadi kesalahan: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
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
                Text(
                  'Berita Terakurat',
                  style: TextStyle(fontSize: 14, color: Colors.teal[200]),
                ),
                const SizedBox(height: 40),

                Align(alignment: Alignment.centerLeft, child: Text("Username")),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(hintText: 'Sigma'),
                ),
                const SizedBox(height: 10),

                Align(alignment: Alignment.centerLeft, child: Text("Email")),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'Sigma@gmail.com'),
                ),
                const SizedBox(height: 10),

                Align(alignment: Alignment.centerLeft, child: Text("Password")),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: ''),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:
                        isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
