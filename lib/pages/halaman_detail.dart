import 'dart:convert';
import 'package:berat/pages/halaman_utama.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HalamanUtama()),
                          );
                        },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
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
                          ],
                        ),
                        Column(
                          children: [
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
                          ],
                        ),
                        Column(
                          children: [
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
                                          onPressed: () {
                                            final String link = "$baseUrl/artikel/${artikel!.idArtikel}";
                                            Clipboard.setData(ClipboardData(text: link));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Tautan telah disalin"),
                                                duration: Duration(seconds: 2),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.copy),
                                        ),
                                        SizedBox(height: 40),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    final String judul = artikel!.judul;
                                                    final String isi = artikel!.isi.length > 100
                                                        ? artikel!.isi.substring(0, 100) + "..."
                                                        : artikel!.isi;
                                                    final String link = "$baseUrl/artikel/${artikel!.idArtikel}";
                                                    final text = Uri.encodeComponent(
                                                      "Baca berita menarik ini:\n\n$judul\n\n$isi\n\nLink: $link",
                                                    );
                                                    final url = "whatsapp://send?text=$text";

                                                    if (await canLaunchUrl(Uri.parse(url))) {
                                                      await launchUrl(Uri.parse(url));
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text("WhatsApp tidak tersedia")),
                                                      );
                                                    }
                                                  },
                                                  icon: Image.network(
                                                    "https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png",
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ),
                                                Text("WhatsApp", style: TextStyle(fontSize: 12)),
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
                                                Text("Facebook", style: TextStyle(fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Tutup"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.share),
                            ),
                            Text("Share"),
                          ],
                        ),
                      ],
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
