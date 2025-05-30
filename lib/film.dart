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
    return Film(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      releaseDate: json['release_date'] ?? '',
      pictureId: json['pictureId'] ?? '',
      rating: json['rating'] ?? '',
      genre: json['genre'] ?? '',
      createdAt: json['created_at'] ?? '',
      description: json['description'] ?? '',
      director: json['director'] ?? '',
      cast: json['cast'] ?? '',
      language: json['language'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'release_date': releaseDate,
      'pictureId': pictureId,
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
