import 'package:flutter/material.dart';

class BeritaCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isLarge;

  const BeritaCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isLarge ? double.infinity : 160,
      margin: EdgeInsets.only(right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Berita
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: isLarge ? 200 : 100,
              width: isLarge ? double.infinity : 160,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: isLarge ? 200 : 100,
                    color: Colors.grey,
                    child: Icon(Icons.broken_image),
                  ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
