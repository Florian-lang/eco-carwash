final class User {

  static const String _IRI = '/api/users';

  final int? id;
  final String email;
  final String password;
  final List<String> roles;
  final List<String> prices;
  final int appreciation;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.roles,
    required this.prices,
    required this.appreciation
  });

factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        roles: List<String>.from(json['roles']),
        prices: List<String>.from(json['prices']),
        appreciation: json['appreciation']
    );
  }

  String get iri => '$_IRI/$id';
}