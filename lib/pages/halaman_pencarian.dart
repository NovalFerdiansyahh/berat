import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    if (keyword.trim().isEmpty) return;

    setState(() {
      _allhistory.remove(keyword);
      _allhistory.insert(0, keyword);
      _loading = true;
      _hasilArtikel.clear();
    });

    try {
      final response = await http.get(Uri.parse('url'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _hasilArtikel = data;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan saat mencari')));
    } finally {
      setState(() {
        _loading = false;
      });
    }

    _controller.clear();
  }

  void _isiDariHistori(String keyword) {
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
                      Navigator.pop(context);
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
                            return Card(
                              child: ListTile(
                                title: Text(artikel['judul'] ?? 'Tanpa Judul'),
                                subtitle: Text(
                                  artikel['konten']?.toString().substring(
                                        0,
                                        50,
                                      ) ??
                                      '',
                                ),
                                onTap: () {},
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
