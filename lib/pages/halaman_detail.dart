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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.black), )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                   CircleAvatar(foregroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVweX5kUAgN-_FgMV9zJQ4D39l7EEgGd59Pg&s",),),
                   SizedBox( width:10), Text("Lorenz News",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
                        Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                      Text("Comment"),


                      SizedBox(width: 100),
                      IconButton(onPressed: () {}, icon: Icon(Icons.system_update_tv_outlined)),
                      Text("Simpan"),
                      SizedBox(width: 100),

                      
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Salin tautan di bawah untuk membagikan berita ini",style: TextStyle(fontSize: 15,fontWeight: 
                                FontWeight.bold),),
                                icon: IconButton(onPressed: (){}, icon: Icon(Icons.copy),
                                ),
                                
                                content: Column(
                                  
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    // Text("BAGIKAN BERITA !",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text("WhatsApp", style: TextStyle(fontSize: 12))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Facebook_f_logo_%282019%29.svg/960px-Facebook_f_logo_%282019%29.svg.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text("Facebook", style: TextStyle(fontSize: 12))
                                    ],
                                  ),
                                ],
                              ),
                            )

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
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text ("Apa yang akan terjadi",style: TextStyle(fontWeight: FontWeight.bold ),),
              ),
            ),
            Container(
              child: 
              Text("Artikel...")
            ),
            // Padding(padding: padding)
          ],
        ),
      ),
    );
  }
}