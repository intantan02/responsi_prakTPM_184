import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'film.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String filmId = '';
  bool isFavorite = false;

  Future<Film> fetchFilmDetail(String id) async {
    final url = 'https://681388b3129f6313e2119693.mockapi.io/api/v1/movie/$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Film.fromJson(jsonData);
    } else {
      throw Exception('Gagal memuat data film');
    }
  }

  Future<void> checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favorites.contains(filmId);
    });
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      if (isFavorite) {
        favorites.remove(filmId);
        isFavorite = false;
      } else {
        favorites.add(filmId);
        isFavorite = true;
      }
    });

    await prefs.setStringList('favorites', favorites);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      filmId = args;
      checkFavoriteStatus();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID film tidak ditemukan')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Film'),
        backgroundColor: const Color.fromARGB(132, 130, 211, 217),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: filmId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Film>(
              future: fetchFilmDetail(filmId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Terjadi kesalahan'));
                }

                final film = snapshot.data!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (film.pictureId.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            film.pictureId,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        film.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Sutradara: ${film.director}'),
                      Text('Pemeran: ${film.cast}'),
                      Text('Rilis: ${film.releaseDate}'),
                      Text('Durasi: ${film.duration}'),
                      Text('Bahasa: ${film.language}'),
                      Text('⭐ Rating: ${film.rating}'),
                      Text('Genre: ${film.genre}'),
                      const SizedBox(height: 16),
                      const Text(
                        'Deskripsi:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(film.description),
                    ],
                  ),
                );
              },
            ),
    );
  }
}