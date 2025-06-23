import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constanta.dart';

class NotifikasiPage extends StatefulWidget {
  final String idUser;
  const NotifikasiPage({Key? key, required this.idUser}) : super(key: key);

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List<dynamic> notifikasi = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifikasi();
  }

  Future<void> fetchNotifikasi() async {
    final url = Uri.parse('$baseUrl${widget.idUser}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        notifikasi = jsonDecode(response.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
      print('Gagal memuat notifikasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifikasi')),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: notifikasi.length,
                itemBuilder: (context, index) {
                  final item = notifikasi[index];
                  final waktu = DateTime.parse(item['created_at']['date']);
                  final sudahDibaca = item['dibaca'] == '1';

                  return ListTile(
                    leading: Icon(
                      sudahDibaca
                          ? Icons.mark_email_read
                          : Icons.mark_email_unread,
                      color: sudahDibaca ? Colors.grey : Colors.redAccent,
                    ),
                    title: Text(
                      item['judul'],
                      style: TextStyle(
                        fontWeight:
                            sudahDibaca ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(item['pesan']),
                    trailing: Text("${waktu.day}/${waktu.month}/${waktu.year}"),
                  );
                },
              ),
    );
  }
}
