import '../models/doctor_entry.dart';
import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class DoctorRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Fetch all doctors
  Future<List<DoctorEntry>> getAllDoctors() async {
    try {
      final data = await _supabaseService.getAll(SupabaseConfig.doctorsTable);
      return data.map((json) => DoctorEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch doctors: $e');
    }
  }

  // Fetch doctor by ID
  Future<DoctorEntry?> getDoctorById(String id) async {
    try {
      final data = await _supabaseService.getById(
        SupabaseConfig.doctorsTable,
        id,
      );
      return data != null ? DoctorEntry.fromJson(data) : null;
    } catch (e) {
      throw Exception('Failed to fetch doctor: $e');
    }
  }

  // Create new doctor
  Future<DoctorEntry> createDoctor(DoctorEntry doctor) async {
    try {
      final data = await _supabaseService.insert(
        SupabaseConfig.doctorsTable,
        doctor.toSupabaseJson(),
      );
      return DoctorEntry.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create doctor: $e');
    }
  }

  // Update existing doctor
  Future<DoctorEntry> updateDoctor(DoctorEntry doctor) async {
    try {
      final data = await _supabaseService.update(
        SupabaseConfig.doctorsTable,
        doctor.id,
        doctor.toSupabaseJson(),
      );
      return DoctorEntry.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update doctor: $e');
    }
  }

  // Delete doctor
  Future<void> deleteDoctor(String id) async {
    try {
      await _supabaseService.delete(SupabaseConfig.doctorsTable, id);
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }

  // Search doctors
  Future<List<DoctorEntry>> searchDoctors(String query) async {
    try {
      final client = _supabaseService.client;
      final response = await client
          .from(SupabaseConfig.doctorsTable)
          .select()
          .or(
            'name.ilike.%$query%,'
            'specialty.ilike.%$query%,'
            'area.ilike.%$query%,'
            'phone_no.ilike.%$query%',
          );

      return List<Map<String, dynamic>>.from(
        response,
      ).map((json) => DoctorEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }

  // Get doctors by specialty
  Future<List<DoctorEntry>> getDoctorsBySpecialty(String specialty) async {
    try {
      final client = _supabaseService.client;
      final response = await client
          .from(SupabaseConfig.doctorsTable)
          .select()
          .eq('specialty', specialty);

      return List<Map<String, dynamic>>.from(
        response,
      ).map((json) => DoctorEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch doctors by specialty: $e');
    }
  }

  // Get doctors by area
  Future<List<DoctorEntry>> getDoctorsByArea(String area) async {
    try {
      final client = _supabaseService.client;
      final response = await client
          .from(SupabaseConfig.doctorsTable)
          .select()
          .eq('area', area);

      return List<Map<String, dynamic>>.from(
        response,
      ).map((json) => DoctorEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch doctors by area: $e');
    }
  }

  // Check if doctor name already exists (for validation)
  Future<bool> isDoctorNameExists(String name, {String? excludeId}) async {
    try {
      final client = _supabaseService.client;
      var query = client
          .from(SupabaseConfig.doctorsTable)
          .select('id')
          .ilike('name', name);

      if (excludeId != null) {
        query = query.neq('id', excludeId);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response).isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check doctor name existence: $e');
    }
  }
}
