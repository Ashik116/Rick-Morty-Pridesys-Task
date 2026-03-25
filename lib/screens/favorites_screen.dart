import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<CharacterProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favoriteCharacters;
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final character = favorites[index];
              return CharacterCard(character: character);
            },
          );
        },
      ),
    );
  }
}
