import 'package:ripped/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// PostgREST-backed [SyncRemote]. RLS limits every call to the signed-in
/// user's rows; the server trigger stamps user_id and synced_at.
class SupabaseSyncRemote implements SyncRemote {
  new(this._client);

  final SupabaseClient _client;

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) =>
      _client.from(table).upsert(rows, onConflict: 'id');

  @override
  Future<List<Map<String, Object?>>> pull(
    String table, {
    required String? since,
    required int limit,
  }) async {
    var query = _client.from(table).select();
    if (since != null) query = query.gt('synced_at', since);
    final rows = await query.order('synced_at').limit(limit);
    return rows.cast<Map<String, Object?>>();
  }
}
