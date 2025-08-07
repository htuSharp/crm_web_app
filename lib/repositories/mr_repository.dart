import '../models/mr_entry.dart';
import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class MRRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Get all MRs
  Future<List<MREntry>> getAllMRs() async {
    final data = await _supabaseService.getAll(SupabaseConfig.mrsTable);
    return data.map((item) => MREntry.fromJson(item)).toList();
  }

  // Get MR by ID
  Future<MREntry?> getMRById(String id) async {
    final data = await _supabaseService.getById(SupabaseConfig.mrsTable, id);
    if (data != null) {
      return MREntry.fromJson(data);
    }
    return null;
  }

  // Create new MR
  Future<MREntry> createMR(MREntry mr) async {
    // Check for duplicates
    final existingMRs = await _supabaseService.search(
      SupabaseConfig.mrsTable,
      'name',
      mr.name,
    );

    if (existingMRs.isNotEmpty) {
      throw Exception('MR with name "${mr.name}" already exists');
    }

    final data = await _supabaseService.insert(
      SupabaseConfig.mrsTable,
      mr.toSupabaseJson(),
    );
    return MREntry.fromJson(data);
  }

  // Update MR
  Future<MREntry> updateMR(MREntry mr) async {
    // Check for duplicates (excluding current MR)
    final existingMRs = await _supabaseService.search(
      SupabaseConfig.mrsTable,
      'name',
      mr.name,
    );

    final duplicates = existingMRs
        .where((item) => item['id'] != mr.id)
        .toList();
    if (duplicates.isNotEmpty) {
      throw Exception('MR with name "${mr.name}" already exists');
    }

    final data = await _supabaseService.update(
      SupabaseConfig.mrsTable,
      mr.id!,
      mr.toSupabaseJson(),
    );
    return MREntry.fromJson(data);
  }

  // Delete MR
  Future<void> deleteMR(String id) async {
    await _supabaseService.delete(SupabaseConfig.mrsTable, id);
  }

  // Search MRs
  Future<List<MREntry>> searchMRs(String query) async {
    final results = await _supabaseService.search(
      SupabaseConfig.mrsTable,
      'name,code,area,mobile',
      query,
    );
    return results.map((item) => MREntry.fromJson(item)).toList();
  }

  // Get MRs by area
  Future<List<MREntry>> getMRsByArea(String area) async {
    final results = await _supabaseService.search(
      SupabaseConfig.mrsTable,
      'area',
      area,
    );
    return results.map((item) => MREntry.fromJson(item)).toList();
  }

  // Get MRs by headquarters
  Future<List<MREntry>> getMRsByHeadquarters(String headquarters) async {
    final results = await _supabaseService.search(
      SupabaseConfig.mrsTable,
      'headquarters',
      headquarters,
    );
    return results.map((item) => MREntry.fromJson(item)).toList();
  }
}
