import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<CharacterProvider>().fetchCharacters();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Characters',
            style: TextStyle( fontSize: 24,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                context.read<CharacterProvider>().fetchCharacters(refresh: true),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Consumer<CharacterProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.characters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.characters.isEmpty && !provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No characters found'),
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(provider.errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () => provider.fetchCharacters(refresh: true),
                      child: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            );
          }

          return Column(
            children: [
              if (provider.errorMessage != null)
                Container(
                  color: Colors.amber.withOpacity(0.3),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child:
                      Text(provider.errorMessage!, textAlign: TextAlign.center),
                ),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount:
                      provider.characters.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.characters.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final character = provider.characters[index];
                    return CharacterCard(character: character);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
