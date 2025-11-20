import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  @override
  List<Object?> get props => [id, name, email, createdAt];
}
