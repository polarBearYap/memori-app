import 'package:memori_app/api/sync/base_api.dart';

class HeartbeatApi extends BaseApi {
  Future<bool> isBackendHeartBeating() async {
    final response = await performRequest(
      (final dio) => dio.get(
        '/api/heartbeat',
      ),
    );
    if (response != null &&
        response.statusCode != null &&
        response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
