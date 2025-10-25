class PasswordEntry {
  int? id;
  String title;
  String username;
  String password;
  String? notes;

  PasswordEntry({
    this.id,
    required this.title,
    required this.username,
    required this.password,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'notes': notes,
    };
  }

  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
      notes: map['notes'],
    );
  }
}