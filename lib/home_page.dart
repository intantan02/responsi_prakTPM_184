import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'film.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  String _username = '';
  Set<String> _favoriteFilmIds = {};
  List<Film> _films = [];
  List<Film> _filteredFilms = [];
  String _selectedGenre = 'All';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    loadFavoriteFilms();
    fetchFilmData();
  }

  Future<void> loadUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _username = prefs.getString('username') ?? '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat informasi pengguna';
      });
    }
  }

  Future<void> loadFavoriteFilms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_films') ?? [];
      setState(() {
        _favoriteFilmIds = favoriteIds.toSet();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data favorit';
      });
    }
  }

  Future<void> saveFavoriteFilms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_films', _favoriteFilmIds.toList());
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menyimpan data favorit';
      });
    }
  }

  void toggleFavorite(String filmId) {
    setState(() {
      if (_favoriteFilmIds.contains(filmId)) {
        _favoriteFilmIds.remove(filmId);
      } else {
        _favoriteFilmIds.add(filmId);
      }
    });
    saveFavoriteFilms();
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('username');
      await prefs.remove('password');
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal logout';
      });
    }
  }

  Future<void> fetchFilmData() async {
    try {
      final films = await apiService.fetchFilms();
      setState(() {
        _films = films;
        _filteredFilms = films;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data film';
      });
    }
  }

  void filterByGenre(String genre) {
    setState(() {
      _selectedGenre = genre;
      _filteredFilms = genre == 'All'
          ? _films
          : _films.where((film) => film.genre == genre).toList();
    });
  }

  List<String> getGenres() {
    final genres = _films.map((film) => film.genre).toSet().toList();
    genres.sort();
    genres.insert(0, 'All');
    return genres;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, $_username!'),
        backgroundColor: const Color.fromARGB(132, 14, 190, 73),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: logout),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorite');
            },
          ),
        ],
      ),
      body: _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Column(
              children: [
                DropdownButton<String>(
                  value: _selectedGenre,
                  onChanged: (value) {
                    if (value != null) {
                      filterByGenre(value);
                    }
                  },
                  items: getGenres()
                      .map((genre) => DropdownMenuItem(
                            value: genre,
                            child: Text(genre),
                          ))
                      .toList(),
                ),
                Expanded(
                  child: _filteredFilms.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: _filteredFilms.length,
                          itemBuilder: (context, index) {
                            final film = _filteredFilms[index];
                            final isFavorite = _favoriteFilmIds.contains(film.id);

                            return ListTile(
                              leading: Image.network(
                                film.pictureId,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              title: Text(film.title),
                              subtitle: Text(film.genre),
                              trailing: IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  toggleFavorite(film.id);
                                },
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: film.id,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
