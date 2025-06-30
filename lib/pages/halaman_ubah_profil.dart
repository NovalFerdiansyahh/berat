import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constanta.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? selectedImagePath;
  String? existingImageFile;
  String? fotoProfil;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // existingImageFile = prefs.getString('fotoProfil');
      fotoProfil = prefs.getString('fotoProfil');
    });
    final id = prefs.getString('idUser');
    final url = Uri.parse('$baseUrl/api/user/upload/$id');

    var request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('foto_profil', pickedFile.path),
    );

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);

        final fileName = data['foto_profil'];

        if (fileName != null) {
          await prefs.setString('fotoProfil', fileName);

          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Foto berhasil diunggah')),
          );

          setState(() {
            selectedImagePath = pickedFile.path;
          }); 
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah foto')),
        );
      }
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat upload')),
      );
    }
  }



  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('nama') ?? '';
    _birthdateController.text = prefs.getString('tanggalLahir') ?? '';
    _phoneController.text = prefs.getString('noTelepon') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
  }

  Future<void> updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('idUser');

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User belum login')),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/api/user/$id');

    setState(() => isLoading = true);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        '_method': 'PUT',
        'nama': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'tanggal_lahir': _birthdateController.text.trim(),
        'no_telepon': _phoneController.text.trim(),
      },
    );


    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      await prefs.setString('nama', _usernameController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('tanggalLahir', _birthdateController.text.trim());
      await prefs.setString('noTelepon', _phoneController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil')),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profil',
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
              backgroundImage: selectedImagePath != null
                  ? FileImage(File(selectedImagePath!))
                  : (fotoProfil != null
                      ? NetworkImage('$baseUrl/uploads/$fotoProfil') as ImageProvider
                      : null),
              child: selectedImagePath == null && fotoProfil == null
                  ? Icon(Icons.person, size: 48, color: Colors.grey[700])
                  : null,
            ),
            SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: () {
                  pickAndUploadImage(); 
                },
                child: Text(
                  'Unggah foto profil',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                    decoration: TextDecoration.underline, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            SizedBox(height: 32),
            CustomInput(controller: _usernameController, hintText: 'Username'),
            SizedBox(height: 16),
            CustomInput(controller: _birthdateController, hintText: 'Tanggal Lahir (YYYY-MM-DD)'),
            SizedBox(height: 16),
            CustomInput(controller: _phoneController, hintText: 'Nomor Handphone'),
            SizedBox(height: 16),
            CustomInput(controller: _emailController, hintText: 'Email'),
            SizedBox(height: 36),
            ElevatedButton(
              onPressed: isLoading ? null : updateProfile,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Ubah Profil'),
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
