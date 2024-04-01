import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// import 'package:drift_dev/api/migrations.dart';
import 'package:flutter/foundation.dart';
import 'package:memori_app/db/database.drift.dart';
import 'package:memori_app/db/database_logging.dart';
import 'package:memori_app/db/repositories/app_users_repository.dart';
import 'package:memori_app/db/repositories/cards_repository.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/db/repositories/sync_entities_repository.dart';
import 'package:memori_app/db/repositories/time_zones_repository.dart';
import 'package:memori_app/db/tables/conflicted_rows.dart';
import 'package:memori_app/db/tables/tables.dart';
import 'package:memori_app/db/tables/time_zones_init.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

@DriftDatabase(
  tables: [
    SyncEntities,
    AppUsers,
    TimeZones,
    CardTags,
    DeckSettings,
    DeckTags,
    StudyOptions,
    Decks,
    StudyOptionStates,
    StudyOptionTags,
    Cards,
    DeckImages,
    DeckReviews,
    DeckTagMappings,
    StudyOptionDecks,
    CardHints,
    CardTagMappings,
    ReviewLogs,
    DeckLearnHistories,
    CardScheduleHistories,
    ConflictedRows,
  ],
  daos: [
    AppUsersRepository,
    CardsRepository,
    SyncEntitiesRepository,
    TimeZonesRepository,
    DbRepository,
  ],
)
class AppDb extends $AppDb {
  // static final AppDb _instance = AppDb._internal();

  // AppDb._internal() : super(_openConnection());

  // factory AppDb() {
  //   return _instance;
  // }

  // ignore: matching_super_parameters
  AppDb._internal(super.db);

  static AppDb? _instance;

  factory AppDb({final bool inMemory = false}) {
    _instance ??= AppDb._internal(_openConnection(inMemory: inMemory));
    return _instance!;
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (final m) async {
          // create all tables
          await m.createAll();
        },
        onUpgrade: (final m, final from, final to) async {
          // disable foreign_keys before migrations
          await customStatement('PRAGMA foreign_keys = OFF');

          await transaction(() async {
            // put your migration logic here
          });

          // Assert that the schema is valid after migrations
          if (kDebugMode) {
            final wrongForeignKeys =
                await customSelect('PRAGMA foreign_key_check').get();
            assert(
              wrongForeignKeys.isEmpty,
              '${wrongForeignKeys.map((final e) => e.data)}',
            );
          }
        },
        beforeOpen: (final details) async {
          // Delete and re-create all tables every time your app is opened
          /*if (kDebugMode) {
            final m = Migrator(this);
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
              await m.createTable(table);
            }
          }*/
          if (details.wasCreated) {
            // for (var timeZone in timeZonesInit) {
            //   into(timeZones).insert(timeZone);
            // }
            await batch((final batch) {
              // functions in a batch don't have to be awaited - just
              // await the whole batch afterwards.
              batch.insertAllOnConflictUpdate(timeZones, timeZonesInit);
            });
          }

          await customStatement('PRAGMA foreign_keys = ON');

          // if (kDebugMode) {
          // This check pulls in a fair amount of code that's not needed
          // anywhere else, so we recommend only doing it in debug builds.
          // await validateDatabaseSchema();
          // }
        },
      );
}

QueryExecutor _openConnection({final bool inMemory = false}) {
  // For testing purpose
  if (inMemory) {
    return LazyDatabase(
      () async => NativeDatabase.memory().interceptWith(LogInterceptor()),
    );
  }

  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(
      file,
      // The optional [setup] function can be used to perform a setup just after
      // the database is opened, before drift is fully ready. This can be used to
      // add custom user-defined sql functions or to provide encryption keys in
      // SQLCipher implementations.
      setup: (final db) {},
    ).interceptWith(LogInterceptor());
  });
}
