import 'package:memori_app/db/dtos/pagination.dart';
import 'package:memori_app/db/tables/sync_entities.drift.dart';

class PaginatedSyncEntityDto {
  final PaginationResult pagination;
  final List<SyncEntity> items;

  PaginatedSyncEntityDto({
    required this.pagination,
    required this.items,
  });
}
