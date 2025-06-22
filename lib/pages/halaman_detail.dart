import 'package:berat/pages/halaman_komentar.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: HalamanDetail(),
  ));
}

class HalamanDetail extends StatefulWidget {
  const HalamanDetail({super.key});

  @override
  State<HalamanDetail> createState() => _HalamanDetailState();
}

class _HalamanDetailState extends State<HalamanDetail> {
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
                onPressed: () {},
                icon: Icon(Icons.arrow_back),
                iconSize: 30,color: Colors.teal[200],
              ),
            ),
            
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVweX5kUAgN-_FgMV9zJQ4D39l7EEgGd59Pg&s",
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )
                ],
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


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
               children: [
                    SizedBox(width: 10),
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
                    SizedBox(width: 100),
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
                  SizedBox(width: 100),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Salin tautan di bawah untuk membagikan berita ini",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.copy),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                            },
                                            icon: Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png",
                                              width: 40,
                                              height: 40,
                                            ),
                                            iconSize: 40,
                                          ),
                                          SizedBox(height: 5),
                                          Text("WhatsApp",
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                            },
                                            icon: Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Facebook_f_logo_%282019%29.svg/960px-Facebook_f_logo_%282019%29.svg.png",
                                              width: 40,
                                              height: 40,
                                            ),
                                            iconSize: 40,
                                          ),
                                          SizedBox(height: 5),
                                          Text("Facebook",
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: Text("Tutup"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
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
                "Apa yang akan terjadi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Artikel..."),
            ),
          ],
        ),
      ),
    );
  }
}
