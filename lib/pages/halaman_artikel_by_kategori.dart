import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constanta.dart';

class HalamanArtikelByKategori extends StatefulWidget {
  final String idKategori;
  final String namaKategori;

  HalamanArtikelByKategori({
    required this.idKategori,
    required this.namaKategori,
  });

  @override
  _HalamanArtikelByKategoriState createState() =>
      _HalamanArtikelByKategoriState();
}

class _HalamanArtikelByKategoriState extends State<HalamanArtikelByKategori> {
  List<dynamic> artikelList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArtikelByKategori();
  }

  Future<void> fetchArtikelByKategori() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/artikel/kategori/${widget.idKategori}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        artikelList = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Gagal mengambil artikel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.namaKategori)),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : artikelList.isEmpty
              ? Center(child: Text('Belum ada artikel di kategori ini.'))
              : ListView.builder(
                itemCount: artikelList.length,
                itemBuilder: (context, index) {
                  final artikel = artikelList[index];
                  return ListTile(
                    leading:
                        artikel['gambar'] != null
                            ? Image.network(
                              artikel['gambar'],
                              width: 80,
                              fit: BoxFit.cover,
                            )
                            : null,
                    title: Text(artikel['judul']),
                    subtitle: Text(
                      artikel['isi'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
    );
  }
}
