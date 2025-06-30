// Pastikan import sudah sesuai
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:berat/pages/halaman_detail.dart';
import 'package:berat/pages/halaman_post.dart';
import 'package:berat/pages/halaman_notifikasi.dart';
import 'package:berat/pages/halaman_pencarian.dart';
import 'package:berat/pages/halaman_artikel_by_kategori.dart';
import 'package:berat/widgets/berita_card.dart';
import 'constanta.dart';

class HalamanUtamaContent extends StatefulWidget {
  @override
  _HalamanUtamaContentState createState() => _HalamanUtamaContentState();
}

class _HalamanUtamaContentState extends State<HalamanUtamaContent> {
  int jumlahNotifikasi = 0;
  List<dynamic> artikelTerkini = [];
  List<dynamic> trending = [];
  List<dynamic> kategori = [];
  String searchKeyword = '';
  bool isLoading = true;

  String? userId;
  String? role;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    fetchBerita();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('idUser');
    role = prefs.getString('role');

    if (userId != null) {
      final jumlah = await fetchJumlahNotifikasi(userId!);
      setState(() {
        jumlahNotifikasi = jumlah;
      });
    }
  }

  Future<void> fetchBerita() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/berita'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          artikelTerkini = data['terkini'] ?? [];
          trending = data['trending'] ?? [];
          kategori = data['kategori'] ?? [];
          isLoading = false;
        });
      } else {
        print('Gagal mengambil data: ${response.body}');
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
    }
  }

  Future<int> fetchJumlahNotifikasi(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifikasi/unread/$id'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['jumlah'] ?? 0;
      }
    } catch (e) {
      print("Error notifikasi: $e");
    }
    return 0;
  }

  Future<void> tambahDilihat(int idArtikel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/artikel/tambahDilihat/$idArtikel'),
      );
      if (response.statusCode != 200) {
        print('Gagal menambah dilihat: ${response.body}');
      }
    } catch (e) {
      print("Gagal menambah dilihat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTerkini =
        artikelTerkini.where((item) {
          final title = item['judul']?.toString().toLowerCase() ?? '';
          return title.contains(searchKeyword.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.grey),
                  onPressed:
                      userId != null
                          ? () async {
                            final jumlahBaru = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => NotifikasiPage(
                                      idUser: userId!,
                                      onNotificationRead: () async {
                                        final baru =
                                            await fetchJumlahNotifikasi(
                                              userId!,
                                            );
                                        setState(() => jumlahNotifikasi = baru);
                                      },
                                    ),
                              ),
                            );
                          }
                          : null,
                ),
                if (jumlahNotifikasi > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Center(
                        child: Text(
                          '$jumlahNotifikasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HalamanPencarian()),
                );
              },
            ),
          ],
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Terkini",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                                  int.tryParse(item['id_artikel'].toString()) ??
                                  0;
                              final imgUrl =
                                  (item['gambar'] != null &&
                                          item['gambar'] != '')
                                      ? '$baseUrl/uploads/${Uri.parse(item['gambar']).pathSegments.last}'
                                      : 'https://cdn.pixabay.com/photo/2025/05/18/14/05/congratulations-9607355_960_720.png';

                              return GestureDetector(
                                onTap: () async {
                                  await tambahDilihat(id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => HalamanDetail(idArtikel: id),
                                    ),
                                  );
                                },
                                child: BeritaCard(
                                  title: item['judul'],
                                  imageUrl: imgUrl,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Trending",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        if (trending.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              final id =
                                  int.tryParse(
                                    trending[0]['id_artikel'].toString(),
                                  ) ??
                                  0;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HalamanDetail(idArtikel: id),
                                ),
                              );
                            },
                            child: BeritaCard(
                              title: trending[0]['judul'],
                              imageUrl:
                                  (trending[0]['gambar'] != null &&
                                          trending[0]['gambar'] != '')
                                      ? '$baseUrl/uploads/${Uri.parse(trending[0]['gambar']).pathSegments.last}'
                                      : 'https://cdn.pixabay.com/photo/2025/05/18/14/05/congratulations-9607355_960_720.png',
                              isLarge: true,
                            ),
                          ),
                        SizedBox(height: 24),
                        Text(
                          "Kategori",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children:
                              kategori.map((item) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => HalamanArtikelByKategori(
                                              idKategori:
                                                  item['id_kategori']
                                                      .toString(),
                                              namaKategori:
                                                  item['nama_kategori'],
                                            ),
                                      ),
                                    );
                                  },
                                  child: Chip(
                                    label: Text(item['nama_kategori']),
                                    backgroundColor: Colors.teal.shade100,
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      floatingActionButton:
          role != null && role != 'pembaca'
              ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HalamanPostArtikel()),
                  );

                  if (result == true) {
                    await fetchBerita();
                    if (userId != null) {
                      final baru = await fetchJumlahNotifikasi(userId!);
                      setState(() => jumlahNotifikasi = baru);
                    }
                  }
                },
                child: Icon(Icons.add),
              )
              : null,
    );
  }
}
