import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constanta.dart';

class HalamanKomentar extends StatefulWidget {
  final int idArtikel;

  const HalamanKomentar({super.key, required this.idArtikel});

  @override
  State<HalamanKomentar> createState() => _HalamanKomentarState();
}

class _HalamanKomentarState extends State<HalamanKomentar> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> komentarList = [];

  String judulArtikel = "";
  String namaUser = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetailArtikel();
  }

  Future<void> fetchDetailArtikel() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/artikel/${widget.idArtikel}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          judulArtikel = data['judul'];
          namaUser = data['nama_user'] ?? 'Tidak diketahui';
          isLoading = false;
        });
      } else {
        print("Gagal memuat artikel");
      }
    } catch (e) {
      print("Error saat fetch artikel: $e");
    }
  }

  Widget komentar(String username, String komentar, Color warna) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: warna,
          ),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "$username\n",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextSpan(
                    text: komentar,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _tambahKomentar() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      komentarList.add({
        "username": "Anda",
        "komentar": _controller.text.trim(),
        "warna": const Color.fromARGB(255, 163, 19, 19),
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(0xffdddddd);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.teal, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 20,
                          child: Text(
                            namaUser.isNotEmpty ? namaUser[0] : "?",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(namaUser, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Text(
                      judulArtikel,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text("Comment", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Divider(height: 1, thickness: 1),
                  Expanded(
                    child: Container(
                      color: backgroundColor,
                      child: ListView.builder(
                        itemCount: komentarList.length,
                        itemBuilder: (context, index) {
                          final item = komentarList[index];
                          return komentar(item['username'], item['komentar'], item['warna']);
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: backgroundColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Comment",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.teal.shade100),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.teal.shade100),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(  
                          onPressed: _tambahKomentar,
                          icon: Icon(Icons.send),
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
