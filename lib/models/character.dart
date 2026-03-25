class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String origin;
  final String location;
  final String image;
  final int episodeCount;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episodeCount,
  });

  Character copyWith({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? origin,
    String? location,
  }) {
    return Character(
      id: id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      image: image,
      episodeCount: episodeCount,
    );
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'] ?? '',
      gender: json['gender'],
      origin: json['origin'] is Map ? json['origin']['name'] : json['origin'],
      location: json['location'] is Map ? json['location']['name'] : json['location'],
      image: json['image'],
      episodeCount: json['episodeCount'] ??
          (json['episode'] != null ? (json['episode'] as List).length : 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
      'episodeCount': episodeCount,
    };
  }
}
