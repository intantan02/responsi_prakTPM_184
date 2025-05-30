import 'dart:convert';
import 'package:http/http.dart' as http;
import 'film.dart';

class ApiService {
  static const String _baseUrl = 'https://681388b3129f6313e2119693.mockapi.io/api/v1/movie';

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Film.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data film');
    }
  }

  Future<Film> fetchFilmById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Film.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail film');
    }
  }
}