import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class SpecialtyRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Get all specialties
  Future<List<String>> getAllSpecialties() async {
    final data = await _supabaseService.getAll(SupabaseConfig.specialtiesTable);
    return data.map((item) => item['name'] as String).toList();
  }

  // Get all specialties with full data
  Future<List<Map<String, dynamic>>> getAllSpecialtiesWithData() async {
    final data = await _supabaseService.getAll(SupabaseConfig.specialtiesTable);
    return data;
  }

  // Get specialty by ID
  Future<String?> getSpecialtyById(String id) async {
    final data = await _supabaseService.getById(
      SupabaseConfig.specialtiesTable,
      id,
    );
    if (data != null) {
      return data['name'] as String;
    }
    return null;
  }

  // Create new specialty
  Future<String> createSpecialty(String specialtyName) async {
    // Check for duplicates
    final existingSpecialties = await _supabaseService.search(
      SupabaseConfig.specialtiesTable,
      'name',
      specialtyName,
    );

    if (existingSpecialties.isNotEmpty) {
      throw Exception('Specialty "$specialtyName" already exists');
    }

    final data = await _supabaseService
        .insert(SupabaseConfig.specialtiesTable, {
          'name': specialtyName,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
    return data['name'] as String;
  }

  // Update specialty
  Future<String> updateSpecialty(String id, String specialtyName) async {
    // Check for duplicates (excluding current specialty)
    final existingSpecialties = await _supabaseService.search(
      SupabaseConfig.specialtiesTable,
      'name',
      specialtyName,
    );

    final duplicates = existingSpecialties
        .where((item) => item['id'] != id)
        .toList();
    if (duplicates.isNotEmpty) {
      throw Exception('Specialty "$specialtyName" already exists');
    }

    final data = await _supabaseService.update(
      SupabaseConfig.specialtiesTable,
      id,
      {'name': specialtyName, 'updated_at': DateTime.now().toIso8601String()},
    );
    return data['name'] as String;
  }

  // Delete specialty
  Future<void> deleteSpecialty(String id) async {
    await _supabaseService.delete(SupabaseConfig.specialtiesTable, id);
  }

  // Search specialties
  Future<List<String>> searchSpecialties(String query) async {
    final results = await _supabaseService.search(
      SupabaseConfig.specialtiesTable,
      'name',
      query,
    );
    return results.map((item) => item['name'] as String).toList();
  }
}
