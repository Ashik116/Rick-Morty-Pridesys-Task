import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character.dart';

class CharacterProvider with ChangeNotifier {
  List<Character> _characters = [];
  Set<int> _favoriteIds = {};
  Map<int, Character> _overrides = {};
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _errorMessage;

  List<Character> get characters => _characters.map((c) => _overrides[c.id] ?? c).toList();
  List<Character> get favoriteCharacters => characters.where((c) => _favoriteIds.contains(c.id)).toList();
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  CharacterProvider() {
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Favorites
    final favList = prefs.getStringList('favorites') ?? [];
    _favoriteIds = favList.map((id) => int.parse(id)).toSet();

    // Load Overrides
    final overridesJson = prefs.getString('overrides') ?? '{}';
    final Map<String, dynamic> overridesMap = json.decode(overridesJson);
    _overrides = overridesMap.map((key, value) => MapEntry(int.parse(key), Character.fromJson(value)));

    // Load Cached Characters
    final cachedJson = prefs.getString('cached_characters');
    if (cachedJson != null) {
      final List<dynamic> cachedList = json.decode(cachedJson);
      _characters = cachedList.map((json) => Character.fromJson(json)).toList();
    }

    notifyListeners();
    fetchCharacters(refresh: true);
  }

  Future<void> fetchCharacters({bool refresh = false}) async {
    if (_isLoading || (!refresh && !_hasMore)) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character?page=$_currentPage'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final List<Character> newCharacters = results.map((json) => Character.fromJson(json)).toList();

        if (refresh) {
          _characters = newCharacters;
        } else {
          _characters.addAll(newCharacters);
        }

        _currentPage++;
        _hasMore = data['info']['next'] != null;
        
        // Save to cache (only first page for simplicity)
        if (_currentPage == 2) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('cached_characters', json.encode(_characters.map((c) => c.toJson()).toList()));
        }
      } else {
        _errorMessage = 'Failed to load characters';
      }
    } catch (e) {
      _errorMessage = 'No internet connection. Showing cached data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favoriteIds.map((id) => id.toString()).toList());
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);

  Future<void> updateCharacter(Character updatedCharacter) async {
    _overrides[updatedCharacter.id] = updatedCharacter;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> overridesJsonMap = _overrides.map((key, value) => MapEntry(key.toString(), value.toJson()));
    prefs.setString('overrides', json.encode(overridesJsonMap));
  }

  Future<void> resetCharacter(int id) async {
    if (_overrides.containsKey(id)) {
      _overrides.remove(id);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> overridesJsonMap = _overrides.map((key, value) => MapEntry(key.toString(), value.toJson()));
      prefs.setString('overrides', json.encode(overridesJsonMap));
    }
  }
}
