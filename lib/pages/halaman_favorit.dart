import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(HalamanFavorit());
}

class HalamanFavorit extends StatelessWidget {
  const HalamanFavorit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Favorit(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 class Favorit extends StatefulWidget {
  @override
  State<Favorit> createState() => _FavoritState();
  
}

class _FavoritState extends State<Favorit> {
  List<Map<String, dynamic>> Favorites = [
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVweX5kUAgN-_FgMV9zJQ4D39l7EEgGd59Pg&s',
      'title': 'asensio',
      'source': 'rmnews',
      'isBookmarked': true,
    },
     {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVweX5kUAgN-_FgMV9zJQ4D39l7EEgGd59Pg&s',
      'title': 'asensio',
      'source': 'rmnews',
      'isBookmarked': true,
    },
     {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVweX5kUAgN-_FgMV9zJQ4D39l7EEgGd59Pg&s',
      'title': 'asensio',
      'source': 'rmnews',
      'isBookmarked': true,
    },
  ];

  void toggleBookmark(int index) {
    setState(() {
      if (Favorites[index]['isBookmarked']== true) {
        Favorites.removeAt(index);
      } else{
      Favorites[index]['isBookmarked'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading :IconButton( 
          icon: Icon(Icons.arrow_back,color: Colors.teal[400],),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Favorit',
        style: TextStyle(color: Colors.black,
        fontFamily: 'Montserrat-Regular',
        fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 16.0),
        itemCount: Favorites.length,
        itemBuilder: (context, index){
          final item = Favorites[index];
          return Card(
            color: Colors.grey[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['image']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${item['title']}"',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          item['source']!,
                          style: TextStyle(color: Colors.black54),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    (item['isBookmark'] ?? false) 
                    ? Icons.bookmark
                    :Icons.bookmark,
                    color: (item['isBookmarked']?? false)
                    ?Colors.teal[400]
                    :Colors.teal[400]
                    ),
                  onPressed: () => toggleBookmark(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

