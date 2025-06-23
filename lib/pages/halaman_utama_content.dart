import 'dart:math';

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

  Future<void> tambahDilihat(int idArtikel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/artikel/tambahDilihat/$idArtikel'),
      );
      if (response.statusCode == 200) {
        print('Dilihat +1 untuk artikel $idArtikel');
      } else {
        print('Gagal menambah dilihat: ${response.body}');
      }
    } catch (e) {
      print("Error saat tambah dilihat: $e");
    }
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
                        final id =
                            int.tryParse(item['id_artikel'].toString()) ?? 0;
                        return GestureDetector(
                          onTap: () async {
                            await tambahDilihat(id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HalamanDetail(idArtikel: id),
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
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Trending",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (trending.isNotEmpty)
                    SizedBox(
                      height:
                          250, // tinggi item BeritaCard (ubah sesuai kebutuhan)
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: min(
                          5,
                          trending.length,
                        ), // batasi maksimum 5 item
                        itemBuilder: (context, index) {
                          final item = trending[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: BeritaCard(
                                title: item['judul'],
                                imageUrl:
                                    item['gambar'] != null &&
                                            item['gambar'] != ''
                                        ? '$baseUrl/uploads/${Uri.parse(item['gambar']).pathSegments.last}'
                                        : 'https://cdn.pixabay.com/photo/2025/05/18/14/05/congratulations-9607355_960_720.png',
                                isLarge: true,
                              ),
                            ),
                          );
                        },
                      ),
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
