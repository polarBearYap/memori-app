import 'package:memori_app/db/dtos/pagination.dart';
import 'package:memori_app/db/tables/sync_entities.drift.dart';

class PaginatedConflictedRowDto {
  final PaginationResult pagination;
  final List<SyncEntity> items;

  PaginatedConflictedRowDto({
    required this.pagination,
    required this.items,
  });
}
