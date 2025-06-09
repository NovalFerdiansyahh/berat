import 'package:berat/widgets/berita_card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
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
    // try {
    //   final response = await http.get(
    //     Uri.parse('http://10.0.2.2:8080/api/home'),
    //   );
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     setState(() {
    //       artikelTerkini = data['terkini'];
    //       trending = data['trending'];
    //       kategori = data['kategori'];
    //       isLoading = false;
    //     });
    //   } else {
    //     throw Exception('Gagal mengambil data');
    //   }
    // } catch (e) {
    //   print("Error: $e");
    // }
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

    return Scaffold(
      body: SafeArea(
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔍 Search Bar
                        TextField(
                          onChanged: onSearch,
                          decoration: InputDecoration(
                            hintText: 'Search Here',
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        SizedBox(height: 24),
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
                              return BeritaCard(
                                title: item['judul'],
                                imageUrl: item['gambar'],
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
                          BeritaCard(
                            title: trending[0]['judul'],
                            imageUrl: trending[0]['gambar'],
                            isLarge: true,
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
                                return Chip(label: Text(item['nama_kategori']));
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorit"),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
