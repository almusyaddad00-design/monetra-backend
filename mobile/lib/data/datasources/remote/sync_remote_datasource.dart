import '../../../core/network/dio_client.dart';

abstract class SyncRemoteDatasource {
  Future<void> pushSync(Map<String, dynamic> data);
  Future<Map<String, dynamic>> pullSync(String? lastSyncTime);
}

class SyncRemoteDatasourceImpl implements SyncRemoteDatasource {
  final DioClient _dioClient;

  SyncRemoteDatasourceImpl(this._dioClient);

  @override
  Future<void> pushSync(Map<String, dynamic> data) async {
    try {
      await _dioClient.dio.post('/sync/push', data: data);
    } catch (e) {
      throw Exception('Sync Push Failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> pullSync(String? lastSyncTime) async {
    try {
      final response = await _dioClient.dio.get(
        '/sync/pull',
        queryParameters:
            lastSyncTime != null ? {'last_sync_time': lastSyncTime} : {},
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Sync Pull Failed: $e');
    }
  }
}
