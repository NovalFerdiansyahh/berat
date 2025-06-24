import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'constanta.dart';

class HalamanPostArtikel extends StatefulWidget {
  @override
  _HalamanPostArtikelState createState() => _HalamanPostArtikelState();
}

class _HalamanPostArtikelState extends State<HalamanPostArtikel> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _artikelController = TextEditingController();
  String? _selectedKategori;
  String? idUser;

  List<Map<String, dynamic>> kategoriListMap = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKategori();
    fetchUserId();
  }

  Future<void> fetchKategori() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/kategori'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          kategoriListMap =
              data.map<Map<String, dynamic>>((item) {
                return {
                  'id': item['id_kategori'].toString(),
                  'nama': item['nama_kategori'],
                };
              }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data kategori');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserId() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/user'));

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        // Cari user dengan role penulis
        final penulis = users.firstWhere(
          (user) => user['role'] == 'penulis',
          orElse: () => null,
        );

        if (penulis != null) {
          setState(() {
            idUser = penulis['id_user'].toString();
          });
          print('ID User Penulis: $idUser');
        } else {
          print('Tidak ada user dengan role penulis');
        }
      } else {
        print('Gagal ambil user. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _postingArtikel() async {
    final judul = _judulController.text;
    final isi = _artikelController.text;

    if (judul.isEmpty ||
        isi.isEmpty ||
        _selectedKategori == null ||
        _image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Semua field wajib diisi!')));
      return;
    }

    final uri = Uri.parse('$baseUrl/api/artikel');
    final request = http.MultipartRequest('POST', uri);

    request.fields['judul'] = judul;
    request.fields['id_kategori'] = _selectedKategori!.toString();
    request.fields['isi'] = isi;

    if (idUser != null) {
      request.fields['id_user'] = idUser!;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ID User tidak ditemukan')));
      return;
    }

    request.files.add(
      await http.MultipartFile.fromPath('gambar', _image!.path),
    );

    try {
      print("KATEGORI DIPILIH: $_selectedKategori");
      print("Fields:");
      request.fields.forEach((key, value) => print("$key: $value"));

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Artikel berhasil diposting!')));
        Navigator.pop(context, true);
      } else {
        print("Gagal: Status ${response.statusCode}");
        final resStr = await response.stream.bytesToString();
        print("Response body: $resStr");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal posting artikel')));
      }
    } catch (e) {
      print("Error posting: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan saat posting')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.teal),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              _image != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                      Text('Tambahkan Gambar'),
                                    ],
                                  ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _judulController,
                        decoration: InputDecoration(
                          hintText: 'Judul',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedKategori,
                        hint: Text("Pilih Kategori"),
                        items:
                            kategoriListMap.map((kategori) {
                              return DropdownMenuItem<String>(
                                value: kategori['id'], // ini adalah id_kategori
                                child: Text(
                                  kategori['nama'],
                                ), // ini yang ditampilkan
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategori =
                                value; // value berisi id_kategori
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      TextField(
                        controller: _artikelController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'Tulis Artikel',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _postingArtikel,
                          child: Text("POSTING"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[200],
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
