import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._internal();
    return _instance!;
  }

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  // Generic CRUD operations
  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    try {
      final response = await client.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch data from $tableName: $e');
    }
  }

  Future<Map<String, dynamic>?> getById(String tableName, String id) async {
    try {
      final response = await client
          .from(tableName)
          .select()
          .eq('id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch record from $tableName: $e');
    }
  }

  Future<Map<String, dynamic>> insert(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client
          .from(tableName)
          .insert(data)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to insert into $tableName: $e');
    }
  }

  Future<Map<String, dynamic>> update(
    String tableName,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client
          .from(tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to update record in $tableName: $e');
    }
  }

  Future<void> delete(String tableName, String id) async {
    try {
      await client.from(tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete record from $tableName: $e');
    }
  }

  // Search functionality
  Future<List<Map<String, dynamic>>> search(
    String tableName,
    String column,
    String query,
  ) async {
    try {
      final response = await client
          .from(tableName)
          .select()
          .ilike(column, '%$query%');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to search in $tableName: $e');
    }
  }

  // Batch operations
  Future<List<Map<String, dynamic>>> insertBatch(
    String tableName,
    List<Map<String, dynamic>> dataList,
  ) async {
    try {
      final response = await client.from(tableName).insert(dataList).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to batch insert into $tableName: $e');
    }
  }
}
