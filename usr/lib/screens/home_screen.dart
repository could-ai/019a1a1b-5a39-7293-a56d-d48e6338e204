import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/password_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PasswordEntry> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final passwords = await DatabaseHelper().getPasswords();
    setState(() => _passwords = passwords);
  }

  void _deletePassword(int id) async {
    await DatabaseHelper().deletePassword(id);
    _loadPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
      ),
      body: _passwords.isEmpty
          ? const Center(child: Text('No passwords saved yet'))
          : ListView.builder(
              itemCount: _passwords.length,
              itemBuilder: (context, index) {
                final entry = _passwords[index];
                return ListTile(
                  title: Text(entry.title),
                  subtitle: Text(entry.username),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/view',
                            arguments: entry,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePassword(entry.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((_) => _loadPasswords());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}