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
  List<Film> _films = [];
  Set<String> _favoriteIds = {};
  String _selectedGenre = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
    fetchData();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favorite_films')?.toSet() ?? {};
    });
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_films', _favoriteIds.toList());
  }

  Future<void> fetchData() async {
    try {
      final data = await apiService.fetchFilms();
      if (!mounted) return;
      setState(() {
        _films = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    saveFavorites();
  }

  List<Film> get filteredFilms {
    if (_selectedGenre == 'All') return _films;
    return _films.where((f) => f.genre == _selectedGenre).toList();
  }

  List<String> get genres {
    final genreSet = _films.map((f) => f.genre).toSet().toList();
    genreSet.sort();
    genreSet.insert(0, 'All');
    return genreSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Daftar Film", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/favorite'),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGenre,
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (val) => setState(() => _selectedGenre = val!),
                        items: genres
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredFilms.length,
                    itemBuilder: (context, index) {
                      final film = filteredFilms[index];
                      final isFav = _favoriteIds.contains(film.id);
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
                          trailing: IconButton(
                            icon: Icon(
                              isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => toggleFavorite(film.id),
                          ),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: film.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}