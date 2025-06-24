import 'package:berat/pages/halaman_detail.dart';
import 'package:berat/pages/halaman_utama.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constanta.dart';
import 'halaman_detail.dart';

void main() {
  runApp(
    MaterialApp(home: HalamanPencarian(), debugShowCheckedModeBanner: false),
  );
}

class HalamanPencarian extends StatefulWidget {
  const HalamanPencarian({super.key});

  @override
  State<HalamanPencarian> createState() => _HalamanPencarianState();
}

class _HalamanPencarianState extends State<HalamanPencarian> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _allhistory = [];
  List<String> get _history => _allhistory.take(3).toList();

  List<dynamic> _hasilArtikel = [];
  bool _loading = false;

  Future<void> _cariData(String keyword) async {
    keyword = keyword.trim();
    if (keyword.isEmpty) return;

    setState(() {
      _allhistory.remove(keyword);
      _allhistory.insert(0, keyword);
      _loading = true;
      _hasilArtikel.clear();
    });

    try {
      final uri = Uri.parse(
        'https://37b1-36-73-34-151.ngrok-free.app/api/artikel/search/',
      ).replace(queryParameters: {'keyword': keyword});

      final response = await http.get(uri);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = response.body;

        try {
          final data = json.decode(body);

          if (data is List) {
            setState(() {
              _hasilArtikel = data;
            });
          } else if (data is Map && data.containsKey('data')) {
            setState(() {
              _hasilArtikel = data['data'];
            });
          } else {
            throw Exception("Format data tidak dikenali.");
          }

          _controller.clear();
        } catch (e) {
          print("Gagal decode JSON: $e");
          throw Exception("Format JSON tidak valid.");
        }
      } else {
        throw Exception('Status bukan 200: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _isiDariHistori(String keyword) {
    keyword = keyword.trim();
    if (keyword.isEmpty) return;
    setState(() {
      _controller.text = keyword;
    });
    _cariData(keyword);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.teal[200]),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HalamanUtama()),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Pencarian',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal.shade200),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _cariData,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Cari artikel...',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
                          suffixIcon:
                              _controller.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(Icons.close, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _controller.clear();
                                      });
                                    },
                                  )
                                  : null,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Histori Pencarian:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (_history.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _allhistory.clear();
                      });
                    },
                    child: Text("Hapus Semua"),
                  ),
                ),
              SizedBox(height: 8),
              if (_history.isEmpty)
                Text(
                  'Belum ada histori pencarian.',
                  style: TextStyle(color: Colors.grey),
                )
              else
                Column(
                  children:
                      _history.map((item) {
                        return ListTile(
                          title: Text(item),
                          leading: Icon(Icons.history, color: Colors.teal),
                          onTap: () => _isiDariHistori(item),
                          trailing: IconButton(
                            icon: Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _allhistory.remove(item);
                              });
                            },
                          ),
                        );
                      }).toList(),
                ),
              Divider(height: 24),
              Text(
                "Hasil Pencarian Artikel:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child:
                    _loading
                        ? Center(child: CircularProgressIndicator())
                        : _hasilArtikel.isEmpty
                        ? Center(child: Text('Tidak ada artikel ditemukan.'))
                        : ListView.builder(
                          itemCount: _hasilArtikel.length,
                          itemBuilder: (context, index) {
                            final artikel = _hasilArtikel[index];
                            final gambarPath = artikel['gambar'] ?? '';
                            final gambarUrl =
                                gambarPath.startsWith('http')
                                    ? gambarPath.replaceFirst(
                                      'localhost',
                                      '37b1-36-73-34-151.ngrok-free.app',
                                    )
                                    : 'http://37b1-36-73-34-151.ngrok-free.app$gambarPath';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => HalamanDetail(
                                          idArtikel: artikel.id,
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(8),
                                  leading:
                                      gambarUrl.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              gambarUrl,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.broken_image,
                                                    size: 60,
                                                  ),
                                            ),
                                          )
                                          : Icon(
                                            Icons.image_not_supported,
                                            size: 60,
                                          ),
                                  title: Text(
                                    artikel['judul'] ?? 'Tanpa Judul',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    artikel['isi']?.toString() ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
