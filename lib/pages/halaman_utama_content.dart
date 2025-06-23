import 'package:berat/pages/halaman_detail.dart';
import 'package:berat/widgets/berita_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constanta.dart';

class HalamanUtamaContent extends StatefulWidget {
  @override
  _HalamanUtamaContentState createState() => _HalamanUtamaContentState();
}

class _HalamanUtamaContentState extends State<HalamanUtamaContent> {
  List<dynamic> artikelTerkini = [];
  List<dynamic> trending = [];
  List<dynamic> kategori = [];
  String searchKeyword = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/berita'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          artikelTerkini = data['terkini'];
          trending = data['trending'];
          kategori = data['kategori'];
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void tambahView(int idArtikel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/artikel/tambahDilihat/$idArtikel'),
    );

    if (response.statusCode == 200) {
      print('View ditambah');
    } else {
      print('Gagal menambah view: ${response.statusCode}');
      print(response.body);
    }
  }

  void onSearch(String keyword) {
    setState(() {
      searchKeyword = keyword.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTerkini =
        artikelTerkini.where((item) {
          final title = item['judul'].toString().toLowerCase();
          return title.contains(searchKeyword);
        }).toList();

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Terkini",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredTerkini.length,
                      itemBuilder: (context, index) {
                        final item = filteredTerkini[index];
                        return GestureDetector(
                          onTap: () {
                            final id = int.tryParse(item['id_artikel'].toString()) ?? 0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HalamanDetail(idArtikel: id),
                              ),
                            );
                          },

                          child: BeritaCard(
                            title: item['judul'],
                            imageUrl:
                                item['gambar'] != null
                                    ? '$baseUrl/uploads/${Uri.parse(item['gambar']).pathSegments.last}'
                                    : 'https://cdn.pixabay.com/photo/2025/05/18/14/05/congratulations-9607355_960_720.png',
                          ),
                        );
                      },
                    ),
<<<<<<< HEAD
                    SizedBox(height: 8),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredTerkini.length,
                        itemBuilder: (context, index) {
                          final item = filteredTerkini[index];
                          return GestureDetector(
                            onTap: () {
                              tambahView(int.parse(item['id_artikel']));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HalamanDetail(),
                                ),
                              );
                            },
                            child: BeritaCard(
                              title: item['judul'],
                              imageUrl:
                                  item['gambar'] != null
                                      ? '$baseUrl/uploads/${Uri.parse(item['gambar']).pathSegments.last}'
                                      : 'https://cdn.pixabay.com/photo/2025/05/18/14/05/congratulations-9607355_960_720.png',
                            ),
                          );
                        },
                      ),
=======
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Trending",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (trending.isNotEmpty)
                    BeritaCard(
                      title: trending[0]['judul'],
                      imageUrl:
                          trending[0]['gambar'] != null &&
                                  trending[0]['gambar'] != ''
                              ? '$baseUrl/uploads/${Uri.parse(trending[0]['gambar']).pathSegments.last}'
                              : 'https://cdn.pixabay.com/photo/2025/05/18/14/05/congratulations-9607355_960_720.png',
                      isLarge: true,
>>>>>>> 11bc3ac04bf6a2985174bf3c58566e25bb7a155d
                    ),
                  SizedBox(height: 24),
                  Text(
                    "Kategori",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children:
                        kategori
                            .map(
                              (item) =>
                                  Chip(label: Text(item['nama_kategori'])),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
