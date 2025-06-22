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

  List<String> kategoriList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/kategori'));
      print("Response: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          kategoriList =
              data
                  .map<String>((item) => item['nama_kategori'].toString())
                  .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
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
    request.fields['kategori'] = _selectedKategori!;
    request.fields['isi'] = isi;

    request.files.add(
      await http.MultipartFile.fromPath('gambar', _image!.path),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Artikel berhasil diposting!')));
        Navigator.pop(context); // kembali setelah sukses
      } else {
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
                            kategoriList.map((kategori) {
                              return DropdownMenuItem<String>(
                                value: kategori,
                                child: Text(kategori),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategori = value;
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
