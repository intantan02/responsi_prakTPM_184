class Film {
  final String id;
  final String title;
  final String releaseDate;
  final String pictureId;
  final String rating;
  final String genre;
  final String createdAt;
  final String description;
  final String director;
  final String cast;
  final String language;
  final String duration;

  Film({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.pictureId,
    required this.rating,
    required this.genre,
    required this.createdAt,
    required this.description,
    required this.director,
    required this.cast,
    required this.language,
    required this.duration,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    String parseListToString(dynamic field) {
      if (field == null) return '';
      if (field is List) {
        return field.map((e) => e.toString()).join(', ');
      }
      return field.toString();
    }

    return Film(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      releaseDate: json['release_date'] ?? '',
      pictureId: json['imgUrl']?.toString().trim() ?? '',
      rating: json['rating'] ?? '',
      genre: parseListToString(json['genre']),
      createdAt: json['created_at'] ?? '',
      description: json['description'] ?? '',
      director: json['director'] ?? '',
      cast: parseListToString(json['cast']),
      language: parseListToString(json['language']),
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'release_date': releaseDate,
      'imgUrl': pictureId,
      'rating': rating,
      'genre': genre,
      'created_at': createdAt,
      'description': description,
      'director': director,
      'cast': cast,
      'language': language,
      'duration': duration,
    };
  }
}