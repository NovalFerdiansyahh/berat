import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _birthdateController = TextEditingController();
    final _phoneController = TextEditingController();
    final _emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            SizedBox(height: 10),
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 48, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Unggah foto profil',
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
            ),
            SizedBox(height: 32),
            CustomInput(controller: _usernameController, hintText: 'Username'),
            SizedBox(height: 16),
            CustomInput(controller: _birthdateController, hintText: 'Tanggal-Lahir'),
            SizedBox(height: 16),
            CustomInput(controller: _phoneController, hintText: 'Nomer HandPhone'),
            SizedBox(height: 16),
            CustomInput(controller: _emailController, hintText: 'Email'),
            SizedBox(height: 36),
            ElevatedButton(
              onPressed: () {},
              child: Text('Ubah Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[200],
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomInput({required this.controller, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
