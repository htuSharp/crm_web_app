import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class HeadquartersRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Get all headquarters
  Future<List<String>> getAllHeadquarters() async {
    final data = await _supabaseService.getAll(
      SupabaseConfig.headquartersTable,
    );
    return data.map((item) => item['name'] as String).toList();
  }

  // Get all headquarters with full data
  Future<List<Map<String, dynamic>>> getAllHeadquartersWithData() async {
    final data = await _supabaseService.getAll(
      SupabaseConfig.headquartersTable,
    );
    return data;
  }

  // Get headquarters by ID
  Future<String?> getHeadquartersById(String id) async {
    final data = await _supabaseService.getById(
      SupabaseConfig.headquartersTable,
      id,
    );
    if (data != null) {
      return data['name'] as String;
    }
    return null;
  }

  // Create new headquarters
  Future<String> createHeadquarters(String headquartersName) async {
    // Check for duplicates
    final existingHeadquarters = await _supabaseService.search(
      SupabaseConfig.headquartersTable,
      'name',
      headquartersName,
    );

    if (existingHeadquarters.isNotEmpty) {
      throw Exception('Headquarters "$headquartersName" already exists');
    }

    final data = await _supabaseService
        .insert(SupabaseConfig.headquartersTable, {
          'name': headquartersName,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
    return data['name'] as String;
  }

  // Update headquarters
  Future<String> updateHeadquarters(String id, String headquartersName) async {
    // Check for duplicates (excluding current headquarters)
    final existingHeadquarters = await _supabaseService.search(
      SupabaseConfig.headquartersTable,
      'name',
      headquartersName,
    );

    final duplicates = existingHeadquarters
        .where((item) => item['id'] != id)
        .toList();
    if (duplicates.isNotEmpty) {
      throw Exception('Headquarters "$headquartersName" already exists');
    }

    final data = await _supabaseService.update(
      SupabaseConfig.headquartersTable,
      id,
      {
        'name': headquartersName,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
    return data['name'] as String;
  }

  // Delete headquarters
  Future<void> deleteHeadquarters(String id) async {
    await _supabaseService.delete(SupabaseConfig.headquartersTable, id);
  }

  // Search headquarters
  Future<List<String>> searchHeadquarters(String query) async {
    final results = await _supabaseService.search(
      SupabaseConfig.headquartersTable,
      'name',
      query,
    );
    return results.map((item) => item['name'] as String).toList();
  }
}
