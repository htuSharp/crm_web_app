import 'package:flutter/material.dart';
import '../models/area_entry.dart';
import '../repositories/area_repository.dart';
import '../services/headquarters_management_service.dart';

class AreaManagementService {
  final List<AreaEntry> _areas = [];
  final AreaRepository _areaRepository = AreaRepository();
  final HeadquartersManagementService _headquartersService =
      HeadquartersManagementService();
  bool _isLoading = false;
  String? _error;

  List<AreaEntry> get areas => List.unmodifiable(_areas);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load areas from Supabase
  Future<void> loadAreas() async {
    _isLoading = true;
    _error = null;
    try {
      final areas = await _areaRepository.getAllAreas();
      _areas.clear();
      _areas.addAll(areas);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search areas in Supabase
  Future<void> searchAreas(String query) async {
    if (query.isEmpty) {
      await loadAreas();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final areas = await _areaRepository.searchAreas(query);
      _areas.clear();
      _areas.addAll(areas);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Validation methods
  String? validateAreaName(String name) {
    if (name.trim().isEmpty) {
      return 'Area name cannot be empty';
    }
    if (name.trim().length < 2) {
      return 'Area name must be at least 2 characters';
    }
    return null;
  }

  String? validateHeadquarter(String? headquarter) {
    if (headquarter == null || headquarter.isEmpty) {
      return 'Please select a headquarter';
    }
    return null;
  }

  // Business logic methods
  Future<bool> isDuplicateArea(
    String areaName,
    String headquarter, {
    AreaEntry? excluding,
  }) async {
    try {
      final areas = await _areaRepository.getAreasByHeadquarter(headquarter);
      return areas.any(
        (entry) =>
            entry.area.toLowerCase() == areaName.toLowerCase() &&
            entry != excluding,
      );
    } catch (e) {
      return false; // If error, allow operation to proceed
    }
  }

  // Add area with database integration
  Future<String> addArea(String areaName, String headquarter) async {
    final trimmed = areaName.trim();

    // Validate
    final nameError = validateAreaName(trimmed);
    if (nameError != null) return nameError;

    final hqError = validateHeadquarter(headquarter);
    if (hqError != null) return hqError;

    if (await isDuplicateArea(trimmed, headquarter)) {
      return 'Area "$trimmed" already exists for $headquarter';
    }

    try {
      final newArea = AreaEntry(area: trimmed, headquarter: headquarter);
      await _areaRepository.createArea(newArea);
      _areas.add(newArea);
      return 'success';
    } catch (e) {
      return 'Failed to add area: ${e.toString()}';
    }
  }

  // Edit area with database integration
  Future<String> editArea(
    AreaEntry oldEntry,
    String newAreaName,
    String newHeadquarter,
  ) async {
    final trimmed = newAreaName.trim();

    // Validate
    final nameError = validateAreaName(trimmed);
    if (nameError != null) return nameError;

    final hqError = validateHeadquarter(newHeadquarter);
    if (hqError != null) return hqError;

    if (await isDuplicateArea(trimmed, newHeadquarter, excluding: oldEntry)) {
      return 'Area "$trimmed" already exists for $newHeadquarter';
    }

    try {
      final updatedArea = oldEntry.copyWith(
        area: trimmed,
        headquarter: newHeadquarter,
      );
      await _areaRepository.updateArea(updatedArea);

      final index = _areas.indexOf(oldEntry);
      if (index != -1) {
        _areas[index] = updatedArea;
      }
      return 'success';
    } catch (e) {
      return 'Failed to update area: ${e.toString()}';
    }
  }

  // Delete area with database integration
  Future<void> deleteArea(AreaEntry entry) async {
    try {
      await _areaRepository.deleteArea(entry.id);
      _areas.remove(entry);
    } catch (e) {
      throw Exception('Failed to delete area: ${e.toString()}');
    }
  }

  // Dialog helper method
  void showAddAreaDialog(BuildContext context, VoidCallback onSuccess) async {
    // Load headquarters from database
    await _headquartersService.loadHeadquarters();

    final TextEditingController areaController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final availableHeadquarters = _headquartersService.headquartersNames;
    String? selectedHQ = availableHeadquarters.isNotEmpty
        ? availableHeadquarters.first
        : null;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Area'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedHQ,
                decoration: const InputDecoration(
                  labelText: 'Headquarter',
                  border: OutlineInputBorder(),
                ),
                items: availableHeadquarters.isEmpty
                    ? [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('No headquarters available'),
                        ),
                      ]
                    : availableHeadquarters
                          .map(
                            (hq) => DropdownMenuItem<String>(
                              value: hq,
                              child: Text(hq),
                            ),
                          )
                          .toList(),
                onChanged: availableHeadquarters.isEmpty
                    ? null
                    : (val) => selectedHQ = val,
                validator: (value) => validateHeadquarter(value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Area Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateAreaName(value ?? ''),
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedHQ != null) {
                final result = await addArea(areaController.text, selectedHQ!);
                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Area added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void showEditAreaDialog(
    BuildContext context,
    AreaEntry entry,
    VoidCallback onSuccess,
  ) async {
    // Load headquarters from database
    await _headquartersService.loadHeadquarters();

    final TextEditingController areaController = TextEditingController(
      text: entry.area,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final availableHeadquarters = _headquartersService.headquartersNames;
    String? selectedHQ = entry.headquarter;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Area'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedHQ,
                decoration: const InputDecoration(
                  labelText: 'Headquarter',
                  border: OutlineInputBorder(),
                ),
                items: availableHeadquarters.isEmpty
                    ? [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('No headquarters available'),
                        ),
                      ]
                    : availableHeadquarters
                          .map(
                            (hq) => DropdownMenuItem<String>(
                              value: hq,
                              child: Text(hq),
                            ),
                          )
                          .toList(),
                onChanged: availableHeadquarters.isEmpty
                    ? null
                    : (val) => selectedHQ = val,
                validator: (value) => validateHeadquarter(value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Area Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateAreaName(value ?? ''),
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedHQ != null) {
                final result = await editArea(
                  entry,
                  areaController.text,
                  selectedHQ!,
                );
                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Area updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
