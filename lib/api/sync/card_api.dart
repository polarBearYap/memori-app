import 'dart:convert';

import 'package:memori_app/api/sync/base_api.dart';
import 'package:memori_app/api/sync/models/card_schedule_request.dart';
import 'package:memori_app/api/sync/models/card_schedule_response.dart';

class CardApi extends BaseApi {
  Future<CardScheduleResponse?> scheduleCard({
    required final CardScheduleRequest request,
  }) async {
    final response = await performRequest(
      (final dio) => dio.post(
        '/api/schedulecard',
        data: jsonEncode(request),
      ),
    );

    if (response != null &&
        response.statusCode != null &&
        response.statusCode == 200) {
      return CardScheduleResponse.fromJson(response.data);
    }

    return null;
  }
}
