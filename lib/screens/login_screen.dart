import 'package:flutter/material.dart';
import 'package:lia/services/auth_service.dart';
import 'package:lia/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = AuthService();
  String error = '';

  void login() async {
    try {
      await _auth.signIn(emailController.text, passwordController.text);
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: login,
              child: const Text('Iniciar sesión')
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const RegisterScreen()
              )),
              child: const Text('¿No tienes cuenta? Registrate')
            ),
            if (error.isNotEmpty) Text(error, style: const TextStyle(color: Colors.red)),
          ],
        )
      ),
    );
  }
}
