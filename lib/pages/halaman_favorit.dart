import 'package:flutter/material.dart';

class HalamanFavorit extends StatefulWidget {
  const HalamanFavorit({super.key});

  @override
  State<HalamanFavorit> createState() => _HalamanFavoritState();
}

class _HalamanFavoritState extends State<HalamanFavorit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("FAVORIT") ,)
    ,body: ListView.builder(itemBuilder: (context, index) => Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
        ),
      ],
    ),),);
  }
}