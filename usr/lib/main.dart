import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'screens/home_screen.dart';
import 'screens/add_password_screen.dart';
import 'screens/view_password_screen.dart';

void main() {
  runApp(const PasswordManagerApp());
}

class PasswordManagerApp extends StatefulWidget {
  const PasswordManagerApp({super.key});

  @override
  State<PasswordManagerApp> createState() => _PasswordManagerAppState();
}

class _PasswordManagerAppState extends State<PasswordManagerApp> {
  bool _isAuthenticated = false;
  String? _masterPasswordHash;

  @override
  void initState() {
    super.initState();
    _loadMasterPassword();
  }

  Future<void> _loadMasterPassword() async {
    final prefs = await SharedPreferences.getInstance();
    _masterPasswordHash = prefs.getString('master_password');
    setState(() {});
  }

  Future<void> _setMasterPassword(String password) async {
    final hash = sha256.convert(utf8.encode(password)).toString();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('master_password', hash);
    _masterPasswordHash = hash;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: _masterPasswordHash == null
          ? _MasterPasswordSetupScreen(onSetPassword: _setMasterPassword)
          : _isAuthenticated
              ? const HomeScreen()
              : _LoginScreen(
                  onAuthenticate: () => setState(() => _isAuthenticated = true),
                  masterPasswordHash: _masterPasswordHash!,
                ),
      routes: {
        '/add': (context) => const AddPasswordScreen(),
        '/view': (context) => const ViewPasswordScreen(),
      },
    );
  }
}

class _MasterPasswordSetupScreen extends StatefulWidget {
  final Function(String) onSetPassword;

  const _MasterPasswordSetupScreen({required this.onSetPassword});

  @override
  State<_MasterPasswordSetupScreen> createState() => _MasterPasswordSetupScreenState();
}

class _MasterPasswordSetupScreenState extends State<_MasterPasswordSetupScreen> {
  final _controller = TextEditingController();
  final _confirmController = TextEditingController();

  void _submit() {
    if (_controller.text.isNotEmpty && _controller.text == _confirmController.text) {
      widget.onSetPassword(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Master Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Master Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmController,
              decoration: const InputDecoration(labelText: 'Confirm Master Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Set Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  final VoidCallback onAuthenticate;
  final String masterPasswordHash;

  const _LoginScreen({required this.onAuthenticate, required this.masterPasswordHash});

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final _controller = TextEditingController();
  String? _error;

  void _login() {
    final hash = sha256.convert(utf8.encode(_controller.text)).toString();
    if (hash == widget.masterPasswordHash) {
      widget.onAuthenticate();
    } else {
      setState(() => _error = 'Incorrect password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Master Password'),
              obscureText: true,
            ),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}