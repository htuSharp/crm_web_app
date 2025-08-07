import '../models/area_entry.dart';
import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class AreaRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  Future<List<AreaEntry>> getAllAreas() async {
    try {
      final data = await _supabaseService.getAll(SupabaseConfig.areasTable);
      return data.map((json) => AreaEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch areas: $e');
    }
  }

  Future<AreaEntry?> getAreaById(String id) async {
    try {
      final data = await _supabaseService.getById(
        SupabaseConfig.areasTable,
        id,
      );
      return data != null ? AreaEntry.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to fetch area: $e');
    }
  }

  Future<AreaEntry> createArea(AreaEntry area) async {
    try {
      final data = await _supabaseService.insert(
        SupabaseConfig.areasTable,
        area.toSupabaseJson(),
      );
      return AreaEntry.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create area: $e');
    }
  }

  Future<AreaEntry> updateArea(AreaEntry area) async {
    try {
      final data = await _supabaseService.update(
        SupabaseConfig.areasTable,
        area.id,
        area.toSupabaseJson(),
      );
      return AreaEntry.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update area: $e');
    }
  }

  Future<void> deleteArea(String id) async {
    try {
      await _supabaseService.delete(SupabaseConfig.areasTable, id);
    } catch (e) {
      throw Exception('Failed to delete area: $e');
    }
  }

  Future<List<AreaEntry>> searchAreas(String query) async {
    try {
      final client = _supabaseService.client;
      final response = await client
          .from(SupabaseConfig.areasTable)
          .select()
          .or('area.ilike.%$query%,headquarter.ilike.%$query%');

      return List<Map<String, dynamic>>.from(
        response,
      ).map((json) => AreaEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search areas: $e');
    }
  }

  Future<List<AreaEntry>> getAreasByHeadquarter(String headquarter) async {
    try {
      final client = _supabaseService.client;
      final response = await client
          .from(SupabaseConfig.areasTable)
          .select()
          .eq('headquarter', headquarter);

      return List<Map<String, dynamic>>.from(
        response,
      ).map((json) => AreaEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch areas by headquarter: $e');
    }
  }

  Future<bool> isAreaNameExists(String areaName, {String? excludeId}) async {
    try {
      final client = _supabaseService.client;
      var query = client
          .from(SupabaseConfig.areasTable)
          .select('id')
          .ilike('area', areaName);

      if (excludeId != null) {
        query = query.neq('id', excludeId);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response).isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check area name existence: $e');
    }
  }
}
