import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'artikel_model.dart';
import 'constanta.dart';
import 'halaman_komentar.dart';

class HalamanDetail extends StatefulWidget {
  const HalamanDetail({super.key});

  @override
  State<HalamanDetail> createState() => _HalamanDetailState();
}

class _HalamanDetailState extends State<HalamanDetail> {
  Artikel? artikel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArtikel();
  }

  Future<void> fetchArtikel() async {
    final response = await http.get(Uri.parse('$baseUrl/api/artikel'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        artikel = Artikel.fromJson(data.first);
        isLoading = false;
      });
    } else {
      throw Exception("Gagal memuat artikel");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading || artikel == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: Colors.teal[200], size: 30),
                      ),
                    ),
                    artikel!.gambar != null
                        ? Image.network(
                            artikel!.gambar!,
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 250,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, size: 100),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Text(artikel!.sumber[0]),
                          ),
                          SizedBox(width: 10),
                          Text(
                            artikel!.sumber,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HalamanKomentar()),
                              );
                            },
                            icon: Icon(Icons.comment),
                          ),
                          Text("Comment"),
                          SizedBox(width: 50),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Berita telah disimpan"),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: Icon(Icons.bookmark),
                          ),
                          Text("Simpan"),
                          SizedBox(width: 50),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    "Salin tautan di bawah untuk membagikan berita ini",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.copy),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Image.network(
                                                  "https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png",
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              Text("WhatsApp", style: TextStyle(fontSize: 12))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Image.network(
                                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Facebook_f_logo_%282019%29.svg/960px-Facebook_f_logo_%282019%29.svg.png",
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              Text("Facebook", style: TextStyle(fontSize: 12))
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Tutup"),
                                    )
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.share_sharp),
                          ),
                          Text("Share"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        artikel!.judul,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(artikel!.isi),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
