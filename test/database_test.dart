import 'package:drift/drift.dart';
import 'package:memori_app/db/database.dart';
import 'package:memori_app/db/repositories/app_users_repository.dart';
import 'package:memori_app/db/repositories/sync_entities_repository.dart';
import 'package:memori_app/db/repositories/time_zones_repository.dart';
import 'package:memori_app/db/tables/app_users.drift.dart';
import 'package:memori_app/db/tables/sync_entities.drift.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  const uuid = Uuid();
  late AppDb database;
  late AppUsersRepository appUsersRepository;
  late SyncEntitiesRepository syncEntitiesRepository;
  late TimeZonesRepository timeZonesRepository;

  setUp(() {
    database = AppDb(inMemory: true);
    appUsersRepository = AppUsersRepository(database);
    syncEntitiesRepository = SyncEntitiesRepository(database);
    timeZonesRepository = TimeZonesRepository(database);
  });

  test('sync entities can be created', () async {
    // Get timezone
    const timeZoneCode = 'Asia/Kuala_Lumpur';
    final timeZoneCount = await timeZonesRepository.countEntity();
    expect(timeZoneCount != null, true);
    expect(timeZoneCount! > 0, true);
    final timeZone = await timeZonesRepository.getEntity(timeZoneCode);
    expect(timeZone != null, true);

    // Add user
    final userId = uuid.v4().toString();
    final userCompanion = AppUsersCompanion(
      id: Value(userId),
      username: const Value("drift_test1"),
      email: const Value("drift_test1@gmail.com"),
      isEmailVerified: const Value(false),
      dailyResetTime: const Value(2),
      deviceId: Value(userId),
      timezoneId: Value(timeZone!.id),
      lastSyncedAt: Value(
        DateTime.now().toUtc().subtract(
              const Duration(
                minutes: 5,
              ),
            ),
      ),
    );
    appUsersRepository.addEntity(userCompanion);
    AppUser? appUser = await appUsersRepository.getEntity(userId);
    expect(appUser != null, true);
    expect(userCompanion.id.value, appUser!.id);

    // Add sync entity
    final now = DateTime.now();
    final later = now.add(const Duration(minutes: 5));
    final syncEntityId = uuid.v4().toString();
    final syncCompanion = SyncEntitiesCompanion(
      id: Value(syncEntityId),
      createdAt: Value(now),
      lastModified: Value(now),
      deletedAt: Value(now),
      syncedAt: Value(now),
      sortOrder: const Value(0),
      version: const Value(0),
      modifiedByDeviceId: Value(syncEntityId),
      entityType: const Value("Card"),
      userId: Value(appUser.id),
    );
    syncEntitiesRepository.addEntity(syncCompanion);
    SyncEntity? syncEntity =
        await syncEntitiesRepository.getEntity(syncEntityId);
    expect(syncEntity != null, true);
    expect(syncCompanion.id.value, syncEntityId);
    expect(syncCompanion.lastModified.value, now);
    syncEntitiesRepository.updateEntity(
      syncEntity!.copyWith(lastModified: later),
    );
    syncEntity = await syncEntitiesRepository.getEntity(syncEntityId);
    expect(syncEntity != null, true);
    expect(syncEntity!.lastModified, later);
  });

  tearDown(() async {
    await database.close();
  });
}
