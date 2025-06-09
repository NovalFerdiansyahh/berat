import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: DetailBerita(),
  ));
}

class DetailBerita extends StatefulWidget {
  const DetailBerita({super.key});

  @override
  State<DetailBerita> createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: IconButton(
                onPressed: () {},icon: Icon(Icons.arrow_back),iconSize: 30,
              ),
            ),
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVweX5kUAgN-_FgMV9zJQ4D39l7EEgGd59Pg&s",
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
