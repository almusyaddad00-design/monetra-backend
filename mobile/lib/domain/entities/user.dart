class User {
  final String id;
  final String name;
  final String email;
  final String? pin;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.pin,
  });
}
