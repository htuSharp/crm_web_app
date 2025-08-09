import '../models/manager_entry.dart';
import '../services/supabase_service.dart';

class ManagerRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Get all managers
  Future<List<ManagerEntry>> getAllManagers() async {
    final data = await _supabaseService.getAll('managers');
    return data.map((item) => ManagerEntry.fromJson(item)).toList();
  }

  // Get manager by ID
  Future<ManagerEntry?> getManagerById(String id) async {
    final data = await _supabaseService.getById('managers', id);
    if (data != null) {
      return ManagerEntry.fromJson(data);
    }
    return null;
  }

  // Search managers
  Future<List<ManagerEntry>> searchManagers(String query) async {
    final data = await _supabaseService.search('managers', 'name', query);
    return data.map((item) => ManagerEntry.fromJson(item)).toList();
  }

  // Create manager
  Future<ManagerEntry> createManager(ManagerEntry manager) async {
    final managerWithId = manager.withGeneratedId();
    final data = await _supabaseService.insert(
      'managers',
      managerWithId.toSupabaseJson(),
    );
    return ManagerEntry.fromJson(data);
  }

  // Update manager
  Future<ManagerEntry> updateManager(ManagerEntry manager) async {
    final data = await _supabaseService.update(
      'managers',
      manager.id!,
      manager.toSupabaseJson(),
    );
    return ManagerEntry.fromJson(data);
  }

  // Delete manager
  Future<void> deleteManager(String id) async {
    await _supabaseService.delete('managers', id);
  }
}
