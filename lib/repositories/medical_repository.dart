import '../models/medical_entry.dart';
import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class MedicalRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Get all medicals
  Future<List<MedicalEntry>> getAllMedicals() async {
    final data = await _supabaseService.getAll(SupabaseConfig.medicalsTable);
    return data.map((item) => MedicalEntry.fromJson(item)).toList();
  }

  // Get medical by ID
  Future<MedicalEntry?> getMedicalById(String id) async {
    final data = await _supabaseService.getById(
      SupabaseConfig.medicalsTable,
      id,
    );
    if (data != null) {
      return MedicalEntry.fromJson(data);
    }
    return null;
  }

  // Create new medical
  Future<MedicalEntry> createMedical(MedicalEntry medical) async {
    // Check for duplicates
    final existingMedicals = await _supabaseService.search(
      SupabaseConfig.medicalsTable,
      'name',
      medical.name,
    );

    if (existingMedicals.isNotEmpty) {
      throw Exception('Medical with name "${medical.name}" already exists');
    }

    final data = await _supabaseService.insert(
      SupabaseConfig.medicalsTable,
      medical.toSupabaseJson(),
    );
    return MedicalEntry.fromJson(data);
  }

  // Update medical
  Future<MedicalEntry> updateMedical(MedicalEntry medical) async {
    // Check for duplicates (excluding current medical)
    final existingMedicals = await _supabaseService.search(
      SupabaseConfig.medicalsTable,
      'name',
      medical.name,
    );

    final duplicates = existingMedicals
        .where((item) => item['id'] != medical.id)
        .toList();
    if (duplicates.isNotEmpty) {
      throw Exception('Medical with name "${medical.name}" already exists');
    }

    final data = await _supabaseService.update(
      SupabaseConfig.medicalsTable,
      medical.id!,
      medical.toSupabaseJson(),
    );
    return MedicalEntry.fromJson(data);
  }

  // Delete medical
  Future<void> deleteMedical(String id) async {
    await _supabaseService.delete(SupabaseConfig.medicalsTable, id);
  }

  // Search medicals
  Future<List<MedicalEntry>> searchMedicals(String query) async {
    final results = await _supabaseService.search(
      SupabaseConfig.medicalsTable,
      'name,contact_person,phone_no,area,address',
      query,
    );
    return results.map((item) => MedicalEntry.fromJson(item)).toList();
  }

  // Get medicals by area
  Future<List<MedicalEntry>> getMedicalsByArea(String area) async {
    final results = await _supabaseService.search(
      SupabaseConfig.medicalsTable,
      'area',
      area,
    );
    return results.map((item) => MedicalEntry.fromJson(item)).toList();
  }

  // Get medicals by headquarters
  Future<List<MedicalEntry>> getMedicalsByHeadquarters(
    String headquarters,
  ) async {
    final results = await _supabaseService.search(
      SupabaseConfig.medicalsTable,
      'headquarter',
      headquarters,
    );
    return results.map((item) => MedicalEntry.fromJson(item)).toList();
  }

  // Get medicals by attached doctor
  Future<List<MedicalEntry>> getMedicalsByDoctor(String doctorName) async {
    final results = await _supabaseService.search(
      SupabaseConfig.medicalsTable,
      'attached_doctor',
      doctorName,
    );
    return results.map((item) => MedicalEntry.fromJson(item)).toList();
  }
}
