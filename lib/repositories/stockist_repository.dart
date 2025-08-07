import '../models/stockist_entry.dart';
import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class StockistRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Get all stockists
  Future<List<StockistEntry>> getAllStockists() async {
    final data = await _supabaseService.getAll(SupabaseConfig.stockistsTable);
    return data.map((item) => StockistEntry.fromJson(item)).toList();
  }

  // Get stockist by ID
  Future<StockistEntry?> getStockistById(String id) async {
    final data = await _supabaseService.getById(
      SupabaseConfig.stockistsTable,
      id,
    );
    if (data != null) {
      return StockistEntry.fromJson(data);
    }
    return null;
  }

  // Create new stockist
  Future<StockistEntry> createStockist(StockistEntry stockist) async {
    // Check for duplicates
    final existingStockists = await _supabaseService.search(
      SupabaseConfig.stockistsTable,
      'name,license_number',
      stockist.name,
    );

    if (existingStockists.isNotEmpty) {
      throw Exception('Stockist with name "${stockist.name}" already exists');
    }

    final data = await _supabaseService.insert(
      SupabaseConfig.stockistsTable,
      stockist.toSupabaseJson(),
    );
    return StockistEntry.fromJson(data);
  }

  // Update stockist
  Future<StockistEntry> updateStockist(StockistEntry stockist) async {
    // Check for duplicates (excluding current stockist)
    final existingStockists = await _supabaseService.search(
      SupabaseConfig.stockistsTable,
      'name,license_number',
      stockist.name,
    );

    final duplicates = existingStockists
        .where((item) => item['id'] != stockist.id)
        .toList();
    if (duplicates.isNotEmpty) {
      throw Exception('Stockist with name "${stockist.name}" already exists');
    }

    final data = await _supabaseService.update(
      SupabaseConfig.stockistsTable,
      stockist.id!,
      stockist.toSupabaseJson(),
    );
    return StockistEntry.fromJson(data);
  }

  // Delete stockist
  Future<void> deleteStockist(String id) async {
    await _supabaseService.delete(SupabaseConfig.stockistsTable, id);
  }

  // Search stockists
  Future<List<StockistEntry>> searchStockists(String query) async {
    final results = await _supabaseService.search(
      SupabaseConfig.stockistsTable,
      'name,company,contact,address,area,license_number',
      query,
    );
    return results.map((item) => StockistEntry.fromJson(item)).toList();
  }

  // Get stockists by area
  Future<List<StockistEntry>> getStockistsByArea(String area) async {
    final results = await _supabaseService.search(
      SupabaseConfig.stockistsTable,
      'area',
      area,
    );
    return results.map((item) => StockistEntry.fromJson(item)).toList();
  }

  // Get stockists by company
  Future<List<StockistEntry>> getStockistsByCompany(String company) async {
    final results = await _supabaseService.search(
      SupabaseConfig.stockistsTable,
      'company',
      company,
    );
    return results.map((item) => StockistEntry.fromJson(item)).toList();
  }
}
