import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';
import 'edit_character_screen.dart';

class CharacterDetailScreen extends StatelessWidget {
  final int characterId;
  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterProvider>(
      builder: (context, provider, child) {
        // provider.characters already includes local overrides (Requirement 2.4)
        final character =
            provider.characters.firstWhere((c) => c.id == characterId);
        final isFavorite = provider.isFavorite(characterId);

        return Scaffold(
          backgroundColor: const Color(0xFFFFFFFF), // Deeper navy background
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            title: Text(
              character.name,
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () => provider.toggleFavorite(characterId),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
              ),

            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  character.image,
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 400,
                      width: double.infinity,
                      color: Colors.grey[900],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFF6750A4),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: const BoxDecoration(color: Color(0xFF111422)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 100.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              character.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditCharacterScreen(character: character),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: character.status.toLowerCase() == 'alive'
                                ? Colors.green
                                : (character.status.toLowerCase() == 'dead'
                                    ? Colors.red
                                    : Colors.grey),
                            size: 10,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            character.status,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: character.status.toLowerCase() == 'alive'
                                  ? Colors.green
                                  : (character.status.toLowerCase() == 'dead'
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Info Container (Species, Gender, Type)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2237),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(label: 'Species', value: character.species),
                            const SizedBox(height: 12),
                            _InfoRow(label: 'Gender', value: character.gender),
                            if (character.type.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _InfoRow(label: 'Type', value: character.type),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _SectionHeader(title: 'ORIGIN'),
                      _DetailTile(title: character.origin),
                      const SizedBox(height: 24),
                      _SectionHeader(title: 'LAST KNOWN LOCATION'),
                      _DetailTile(title: character.location),
                      const SizedBox(height: 24),
                      _SectionHeader(
                          title: 'EPISODES (${character.episodeCount})'),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8E92A8), fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF8E92A8),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String title;
  const _DetailTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2237),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.public, color: Color(0xFF8BC34A), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF90CAF9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF5C627A), size: 20),
        ],
      ),
    );
  }
}
