class SyncLogModel {
  final int? id;
  final String tableName;
  final String recordId;
  final String action; // CREATE, UPDATE, DELETE
  final DateTime timestamp;

  SyncLogModel({
     this.id,
    required this.tableName,
    required this.recordId,
    required this.action,
    required this.timestamp,
  });

  factory SyncLogModel.fromSqlite(Map<String, dynamic> map) {
    return SyncLogModel(
      id: map['id'],
      tableName: map['table_name'],
      recordId: map['record_id'],
      action: map['action'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'table_name': tableName,
      'record_id': recordId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
