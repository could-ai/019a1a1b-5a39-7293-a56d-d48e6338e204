import 'package:flutter/material.dart';
import '../models/password_entry.dart';

class ViewPasswordScreen extends StatefulWidget {
  const ViewPasswordScreen({super.key});

  @override
  State<ViewPasswordScreen> createState() => _ViewPasswordScreenState();
}

class _ViewPasswordScreenState extends State<ViewPasswordScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final entry = ModalRoute.of(context)!.settings.arguments as PasswordEntry;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Username/Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(entry.username),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Password:', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ],
            ),
            Text(_obscurePassword ? '*' * entry.password.length : entry.password),
            if (entry.notes != null) ...[
              const SizedBox(height: 16),
              const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(entry.notes!),
            ],
          ],
        ),
      ),
    );
  }
}