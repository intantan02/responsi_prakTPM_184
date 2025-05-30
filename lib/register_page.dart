import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> registerUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registrasi Berhasil! Silakan Login')),
    );

    Navigator.pop(context); // Tombol Kembali ke Halaman Login
  }

  void handleRegister() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) return;
    registerUser(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: const Color.fromARGB(132, 14, 190, 73),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Mengisi Username
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),

            // Mengisi Password
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: handleRegister, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(132, 14, 190, 73),
                foregroundColor: Colors.white,
              ),
              child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
