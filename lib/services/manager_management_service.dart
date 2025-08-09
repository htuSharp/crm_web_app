import 'package:flutter/material.dart';
import '../models/manager_entry.dart';
import '../repositories/manager_repository.dart';
import '../services/mr_management_service.dart';
import '../widgets/multi_select_dropdown.dart';

class ManagerManagementService {
  final List<ManagerEntry> _managerList = [];
  final ManagerRepository _managerRepository = ManagerRepository();
  MRManagementService? _mrService; // Made nullable and lazy-loaded
  bool _isLoading = false;
  String? _error;

  // Lazy getter for MR service to avoid circular dependency
  MRManagementService get _getMRService {
    _mrService ??= MRManagementService();
    return _mrService!;
  }

  List<ManagerEntry> get managerList => List.unmodifiable(_managerList);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load managers from Supabase
  Future<void> loadManagers() async {
    _isLoading = true;
    _error = null;
    try {
      final managers = await _managerRepository.getAllManagers();
      _managerList.clear();
      _managerList.addAll(managers);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search managers in Supabase
  Future<void> searchManagers(String query) async {
    if (query.isEmpty) {
      await loadManagers();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final managers = await _managerRepository.searchManagers(query);
      _managerList.clear();
      _managerList.addAll(managers);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Validation methods
  String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Manager name cannot be empty';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateMRList(List<String> mrList) {
    if (mrList.isEmpty) {
      return 'Please select at least one MR';
    }
    return null;
  }

  // Business logic methods
  Future<bool> isDuplicateManager(
    String name, {
    ManagerEntry? excluding,
  }) async {
    try {
      final managers = await _managerRepository.searchManagers(name);
      return managers.any(
        (entry) =>
            entry.name.toLowerCase() == name.toLowerCase() &&
            entry != excluding,
      );
    } catch (e) {
      return false; // If error, allow operation to proceed
    }
  }

  Future<String> addManager({
    required String name,
    required List<String> mrList,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final mrError = validateMRList(mrList);
    if (mrError != null) return mrError;

    final trimmedName = name.trim();

    if (await isDuplicateManager(trimmedName)) {
      return 'Manager "$trimmedName" already exists';
    }

    try {
      final newManager = ManagerEntry(name: trimmedName, mrList: mrList);

      await _managerRepository.createManager(newManager);
      _managerList.add(newManager);
      return 'success';
    } catch (e) {
      return 'Failed to add manager: ${e.toString()}';
    }
  }

  Future<String> editManager({
    required ManagerEntry oldEntry,
    required String name,
    required List<String> mrList,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final mrError = validateMRList(mrList);
    if (mrError != null) return mrError;

    final trimmedName = name.trim();

    if (await isDuplicateManager(trimmedName, excluding: oldEntry)) {
      return 'Manager "$trimmedName" already exists';
    }

    try {
      final updatedManager = oldEntry.copyWith(
        name: trimmedName,
        mrList: mrList,
      );

      await _managerRepository.updateManager(updatedManager);

      final index = _managerList.indexOf(oldEntry);
      if (index != -1) {
        _managerList[index] = updatedManager;
      }
      return 'success';
    } catch (e) {
      return 'Failed to update manager: ${e.toString()}';
    }
  }

  // Delete manager with database integration
  Future<void> deleteManager(ManagerEntry entry) async {
    try {
      await _managerRepository.deleteManager(entry.id!);
      _managerList.remove(entry);
    } catch (e) {
      throw Exception('Failed to delete manager: ${e.toString()}');
    }
  }

  // Dialog helper methods
  void showAddManagerDialog(BuildContext context, VoidCallback onSuccess) {
    _showManagerDialog(context, onSuccess, null);
  }

  void showEditManagerDialog(
    BuildContext context,
    ManagerEntry entry,
    VoidCallback onSuccess,
  ) {
    _showManagerDialog(context, onSuccess, entry);
  }

  void _showManagerDialog(
    BuildContext context,
    VoidCallback onSuccess,
    ManagerEntry? editEntry,
  ) async {
    // Load MR data for selection
    await _getMRService.loadMRs();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Controllers
    final nameController = TextEditingController(text: editEntry?.name ?? '');

    // Available MRs and selected MRs
    final availableMRs = _getMRService.mrList.map((mr) => mr.name).toList();
    List<String> selectedMRs = List.from(editEntry?.mrList ?? []);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(editEntry == null ? 'Add Manager' : 'Edit Manager'),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Manager Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => validateName(value ?? ''),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // MR Multi-Select
                    MultiSelectDropdown<String>(
                      items: availableMRs,
                      selectedItems: selectedMRs,
                      onSelectionChanged: (values) {
                        setState(() {
                          selectedMRs = values;
                        });
                      },
                      displayText: (option) => option,
                      labelText: 'Select MRs',
                      hintText: 'Choose multiple MRs',
                      prefixIcon: Icons.group,
                      validator: (values) => validateMRList(values ?? []),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String result;
                  if (editEntry == null) {
                    result = await addManager(
                      name: nameController.text,
                      mrList: selectedMRs,
                    );
                  } else {
                    result = await editManager(
                      oldEntry: editEntry,
                      name: nameController.text,
                      mrList: selectedMRs,
                    );
                  }

                  if (result == 'success' && context.mounted) {
                    Navigator.pop(context);
                    onSuccess();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            editEntry == null
                                ? 'Manager added successfully!'
                                : 'Manager updated successfully!',
                          ),
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
              child: Text(editEntry == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
