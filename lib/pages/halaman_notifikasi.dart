import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'constanta.dart';

class NotifikasiPage extends StatefulWidget {
  final String idUser;
  final VoidCallback? onNotificationRead;

  const NotifikasiPage({
    Key? key,
    required this.idUser,
    this.onNotificationRead,
  }) : super(key: key);

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
    final url = Uri.parse('$baseUrl/api/notifikasi/user/${widget.idUser}');
    print("Memanggil URL: $url");

    try {
      final response = await http.get(url);
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];

        if (data is List) {
          setState(() {
            notifikasi = data;
            loading = false;
          });
        } else {
          setState(() {
            notifikasi = [data];
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat notifikasi')));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Terjadi kesalahan: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  Future<void> tandaiSudahDibaca(String idNotifikasi) async {
    final url = Uri.parse('$baseUrl/api/notifikasi/baca/$idNotifikasi');

    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        print('Notifikasi ditandai sudah dibaca');
      } else {
        print('Gagal menandai notifikasi: ${response.body}');
      }
    } catch (e) {
      print('Error saat menandai notifikasi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifikasi')),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : notifikasi.isEmpty
              ? Center(child: Text("Tidak ada notifikasi"))
              : RefreshIndicator(
                onRefresh: fetchNotifikasi,
                child: ListView.builder(
                  itemCount: notifikasi.length,
                  itemBuilder: (context, index) {
                    final item = notifikasi[index];
                    final sudahDibaca = item['dibaca'] == '1';

                    // Parsing tanggal yang aman
                    final createdAt = item['created_at'];
                    final waktu =
                        DateTime.tryParse(
                          createdAt is Map
                              ? createdAt['date']
                              : createdAt.toString(),
                        ) ??
                        DateTime.now();

                    return ListTile(
                      leading: Icon(
                        sudahDibaca
                            ? Icons.mark_email_read
                            : Icons.mark_email_unread,
                        color: sudahDibaca ? Colors.grey : Colors.redAccent,
                      ),
                      title: Text(
                        item['judul'] ?? 'Judul tidak tersedia',
                        style: TextStyle(
                          fontWeight:
                              sudahDibaca ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(item['pesan'] ?? 'Pesan kosong'),
                      trailing: Text(DateFormat('dd MMM yyyy').format(waktu)),
                      onTap: () async {
                        if (!sudahDibaca) {
                          await tandaiSudahDibaca(item['id_notifikasi']);
                          setState(() {
                            notifikasi[index]['dibaca'] = '1';
                          });
                          widget.onNotificationRead?.call();
                        }
                      },
                    );
                  },
                ),
              ),
    );
  }
}
