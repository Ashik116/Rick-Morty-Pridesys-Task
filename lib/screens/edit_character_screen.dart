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

  final _formKey = GlobalKey<FormState>();

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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
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
      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(content: Text('Character updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111422),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Edit Character', style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1C2237),
                  title: const Text('Reset Changes?', style: TextStyle(color: Colors.white)),
                  content: const Text('This will revert all local edits to the original API data.', style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        context.read<CharacterProvider>().resetCharacter(widget.character.id);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Exit screen
                      },
                      child: const Text('Reset', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.restore, color: Colors.white),
            tooltip: 'Reset to API data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('BASIC INFORMATION'),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'Name', Icons.person),
              _buildTextField(_statusController, 'Status', Icons.info_outline),
              _buildTextField(_speciesController, 'Species', Icons.fingerprint),
              _buildTextField(_typeController, 'Type', Icons.category_outlined),
              _buildTextField(_genderController, 'Gender', Icons.wc),
              
              const SizedBox(height: 24),
              _buildSectionTitle('LOCATION INFORMATION'),
              const SizedBox(height: 16),
              _buildTextField(_originController, 'Origin', Icons.public),
              _buildTextField(_locationController, 'Location', Icons.location_on_outlined),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF8E92A8),
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF8E92A8)),
          prefixIcon: Icon(icon, color: const Color(0xFF8E92A8)),
          filled: true,
          fillColor: const Color(0xFF1C2237),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
