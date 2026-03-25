import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';

class EditCharacterScreen extends StatefulWidget {
  final Character character;
  const EditCharacterScreen({super.key, required this.character});

  @override
  State<EditCharacterScreen> createState() => _EditCharacterScreenState();
}

class _EditCharacterScreenState extends State<EditCharacterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  late TextEditingController _speciesController;
  late TextEditingController _typeController;
  late TextEditingController _genderController;
  late TextEditingController _originController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.character.name);
    _statusController = TextEditingController(text: widget.character.status);
    _speciesController = TextEditingController(text: widget.character.species);
    _typeController = TextEditingController(text: widget.character.type);
    _genderController = TextEditingController(text: widget.character.gender);
    _originController = TextEditingController(text: widget.character.origin);
    _locationController =
        TextEditingController(text: widget.character.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _originController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Character'),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<CharacterProvider>()
                  .resetCharacter(widget.character.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to API data',
          ),
          IconButton(
            onPressed: () {
              final updated = widget.character.copyWith(
                name: _nameController.text,
                status: _statusController.text,
                species: _speciesController.text,
                type: _typeController.text,
                gender: _genderController.text,
                origin: _originController.text,
                location: _locationController.text,
              );
              context.read<CharacterProvider>().updateCharacter(updated);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status')),
            TextField(
                controller: _speciesController,
                decoration: const InputDecoration(labelText: 'Species')),
            TextField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type')),
            TextField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender')),
            TextField(
                controller: _originController,
                decoration: const InputDecoration(labelText: 'Origin')),
            TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location')),
          ],
        ),
      ),
    );
  }
}
