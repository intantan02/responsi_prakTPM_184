import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'film.dart';
import 'api_service.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final ApiService apiService = ApiService();
  List<Film> favoriteFilms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavoriteFilms();
  }

  Future<void> loadFavoriteFilms() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('favorite_films') ?? [];

    try {
      final futures = ids.map((id) => apiService.fetchFilmById(id));
      final results = await Future.wait(futures);
      if (!mounted) return;
      setState(() {
        favoriteFilms = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Film Favorit", style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteFilms.isEmpty
              ? Center(child: Text("Belum ada film favorit"))
              : ListView.builder(
                  itemCount: favoriteFilms.length,
                  itemBuilder: (context, index) {
                    final film = favoriteFilms[index];
                    return Card(
                      elevation: 3,
                      margin:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: film.pictureId.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  film.pictureId,
                                  width: 60,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                              )
                            : const Icon(Icons.image_not_supported, size: 60),
                        title: Text(
                          film.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(film.genre),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: film.id,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}