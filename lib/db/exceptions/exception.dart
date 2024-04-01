import 'package:drift/drift.dart';

class EntityNotFoundException<T extends Table> implements Exception {
  final String message;

  EntityNotFoundException({
    this.message = "Entity not found",
  });

  @override
  String toString() => 'Entity ${T.runtimeType.toString()} not found: $message';
}

class EntityAlreadyExistException<T extends Table> implements Exception {
  final String message;

  EntityAlreadyExistException({
    this.message = "Entity already exist",
  });

  @override
  String toString() =>
      'Entity ${T.runtimeType.toString()} already exist: $message';
}

class TransactionException<T extends Table> implements Exception {
  final String message;

  TransactionException({
    this.message = "Trasaction failed",
  });

  @override
  String toString() => 'Entity ${T.runtimeType.toString()} not found: $message';
}
