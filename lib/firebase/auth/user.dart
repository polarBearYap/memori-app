import 'package:equatable/equatable.dart';

class MemoriUser extends Equatable {
  const MemoriUser({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  final String? email;

  final String id;

  final String? name;

  final String? photo;

  static const empty = MemoriUser(id: '');

  bool get isEmpty => this == MemoriUser.empty;

  bool get isNotEmpty => this != MemoriUser.empty;

  @override
  List<Object?> get props => [email, id, name, photo];
}
