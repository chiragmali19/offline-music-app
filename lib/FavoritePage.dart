import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<String> favorites;

  const FavoritePage({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Songs'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return ListTile(
            title: Text(favorite.split('/').last),
          );
        },
      ),
    );
  }
}
