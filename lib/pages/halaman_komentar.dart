import 'package:flutter/material.dart';

class HalamanKomentar extends StatefulWidget {
  const HalamanKomentar({super.key});

  @override
  State<HalamanKomentar> createState() => _HalamanKomentarState();
}

class _HalamanKomentarState extends State<HalamanKomentar> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> komentar = [
    {
      "user": "User143",
      "text": "Sangat Memalukan, saya sebagai Madridista sangat kecewa",
      "color": Colors.red,
    },
    {
      "user": "Glory Hunter",
      "text": "yang penting 15 ucl boss",
      "color": Colors.white,
    },
    {"user": "user1", "text": "wkwkwkwkwkw", "color": Colors.teal},
    {"user": "user223", "text": "mengecewakan", "color": Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            // Tombol back
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVweX5kUAgN-_FgMV9zJQ4D39l7EEgGd59Pg&s",
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Lorenz News",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
