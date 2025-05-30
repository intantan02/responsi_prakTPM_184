import 'package:flutter/material.dart';
import 'package:responsi_184/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'favorite_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(FilmApp(isLoggedIn: isLoggedIn));
}

class FilmApp extends StatelessWidget {
  final bool isLoggedIn;

  const FilmApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi',
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/detail': (context) => DetailPage(),
        '/favorite': (context) => FavoritePage(),
      },
    );
  }
}
