import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifikasiList;

  const NotifikasiPage({Key? key, required this.notifikasiList})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifikasi')),
      body:
          notifikasiList.isEmpty
              ? Center(child: Text('Tidak ada notifikasi.'))
              : ListView.builder(
                itemCount: notifikasiList.length,
                itemBuilder: (context, index) {
                  final notif = notifikasiList[index];
                  final DateTime waktu = DateTime.parse(
                    notif['created_at']['date'],
                  );
                  final bool sudahDibaca = notif['dibaca'] == "1";

                  return ListTile(
                    leading: Icon(
                      sudahDibaca
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: sudahDibaca ? Colors.grey : Colors.blue,
                    ),
                    title: Text(
                      notif['judul'],
                      style: TextStyle(
                        fontWeight:
                            sudahDibaca ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif['pesan']),
                        SizedBox(height: 4),
                        Text(
                          '${waktu.day}-${waktu.month}-${waktu.year} ${waktu.hour}:${waktu.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Tambahkan aksi jika ingin tandai sebagai dibaca atau buka artikel
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notifikasi "${notif['judul']}" diklik',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
