import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

class LogInterceptor extends QueryInterceptor {
  Future<T> _run<T>(
      final String description, final FutureOr<T> Function() operation,) async {
    final stopwatch = Stopwatch()..start();
    if (kDebugMode) {
      print('Running $description');
    }

    try {
      final result = await operation();
      if (kDebugMode) {
        print(' => succeeded after ${stopwatch.elapsedMilliseconds}ms');
      }
      return result;
    } on Object catch (e) {
      if (kDebugMode) {
        print(' => failed after ${stopwatch.elapsedMilliseconds}ms ($e)');
      }
      rethrow;
    }
  }

  @override
  TransactionExecutor beginTransaction(final QueryExecutor parent) {
    if (kDebugMode) {
      print('begin');
    }
    return super.beginTransaction(parent);
  }

  @override
  Future<void> commitTransaction(final TransactionExecutor inner) => _run('commit', () => inner.send());

  @override
  Future<void> rollbackTransaction(final TransactionExecutor inner) => _run('rollback', () => inner.rollback());

  @override
  Future<void> runBatched(
      final QueryExecutor executor, final BatchedStatements statements,) => _run(
        'batch with $statements', () => executor.runBatched(statements),);

  @override
  Future<int> runInsert(
      final QueryExecutor executor, final String statement, final List<Object?> args,) => _run(
        '$statement with $args', () => executor.runInsert(statement, args),);

  @override
  Future<int> runUpdate(
      final QueryExecutor executor, final String statement, final List<Object?> args,) => _run(
        '$statement with $args', () => executor.runUpdate(statement, args),);

  @override
  Future<int> runDelete(
      final QueryExecutor executor, final String statement, final List<Object?> args,) => _run(
        '$statement with $args', () => executor.runDelete(statement, args),);

  @override
  Future<void> runCustom(
      final QueryExecutor executor, final String statement, final List<Object?> args,) => _run(
        '$statement with $args', () => executor.runCustom(statement, args),);

  @override
  Future<List<Map<String, Object?>>> runSelect(
      final QueryExecutor executor, final String statement, final List<Object?> args,) => _run(
        '$statement with $args', () => executor.runSelect(statement, args),);
}
