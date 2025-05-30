import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favoriteFilms = [];

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('favorites') ?? [];

    List<Map<String, dynamic>> result = [];

    for (String id in ids) {
      final response = await http.get(
        Uri.parse('https://681388b3129f6313e2119693.mockapi.io/api/v1/movie/$id'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        result.add(data);
      }
    }

    setState(() {
      favoriteFilms = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Favorit'),
        backgroundColor: const Color.fromARGB(132, 14, 190, 73),
        foregroundColor: Colors.white,
      ),
      body: favoriteFilms.isEmpty
          ? Center(child: Text('Belum Ada Film Favorit.'))
          : ListView.builder(
              itemCount: favoriteFilms.length,
              itemBuilder: (context, index) {
                final film = favoriteFilms[index];
                return ListTile(
                  leading: Image.network(
                    film['pictureId'],
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text(film['title']),
                  subtitle: Text(film['genre']),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: film['id'],
                    );
                  },
                );
              },
            ),
    );
  }
}
