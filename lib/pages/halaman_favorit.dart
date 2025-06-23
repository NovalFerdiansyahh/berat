import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constanta.dart';
import 'dart:convert';

void main(List<String> args) {
  runApp(HalamanFavorit());
}

class HalamanFavorit extends StatelessWidget {
  const HalamanFavorit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Favorit(), debugShowCheckedModeBanner: false);
  }
}

class Favorit extends StatefulWidget {
  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  List<Map<String, dynamic>> Favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final url = Uri.parse('$baseUrl/api/favorit');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          Favorites =
              data
                  .map(
                    (item) => {
                      'idFavorit': item['id_favorit'],
                      'idUser': item['id_user'],
                      'idArtikel': item['id_artikel'],
                      'createdAt': item['created_at'],
                      'updateAt': item['updated_at'],
                      'isBookmarked': item['isBookmarked'] ?? true,
                    },
                  )
                  .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data dari API');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  void toggleBookmark(int index) {
    setState(() {
      if (Favorites[index]['isBookmarked'] == true) {
        Favorites.removeAt(index);
      } else {
        Favorites[index]['isBookmarked'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal[200]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Favorit',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat-Regular',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.only(top: 16.0),
                itemCount: Favorites.length,
                itemBuilder: (context, index) {
                  final item = Favorites[index];
                  return Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(8),
                        //   child: Image.network(
                        //     item['image']!,
                        //     width: 60,
                        //     height: 60,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"${item['title']}"',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              // Text(
                              //   item['source']!,
                              //   style: TextStyle(color: Colors.black54),
                              // ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            (item['isBookmark'] ?? false)
                                ? Icons.bookmark
                                : Icons.bookmark,
                            color:
                                (item['isBookmarked'] ?? false)
                                    ? Colors.teal[200]
                                    : Colors.teal[200],
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
