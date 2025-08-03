import 'package:flutter/material.dart';
import '../models/area_entry.dart';
import '../constants/data_management_constants.dart';

class AreaManagementService {
  final List<AreaEntry> _areas = [];

  List<AreaEntry> get areas => List.unmodifiable(_areas);

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
  bool isDuplicateArea(
    String areaName,
    String headquarter, {
    AreaEntry? excluding,
  }) {
    return _areas.any(
      (entry) =>
          entry.area.toLowerCase() == areaName.toLowerCase() &&
          entry.headquarter == headquarter &&
          entry != excluding,
    );
  }

  String addArea(String areaName, String headquarter) {
    final trimmed = areaName.trim();

    // Validate
    final nameError = validateAreaName(trimmed);
    if (nameError != null) return nameError;

    final hqError = validateHeadquarter(headquarter);
    if (hqError != null) return hqError;

    if (isDuplicateArea(trimmed, headquarter)) {
      return 'Area "$trimmed" already exists for $headquarter';
    }

    _areas.add(AreaEntry(area: trimmed, headquarter: headquarter));
    return 'success';
  }

  String editArea(
    AreaEntry oldEntry,
    String newAreaName,
    String newHeadquarter,
  ) {
    final trimmed = newAreaName.trim();

    // Validate
    final nameError = validateAreaName(trimmed);
    if (nameError != null) return nameError;

    final hqError = validateHeadquarter(newHeadquarter);
    if (hqError != null) return hqError;

    if (isDuplicateArea(trimmed, newHeadquarter, excluding: oldEntry)) {
      return 'Area "$trimmed" already exists for $newHeadquarter';
    }

    final index = _areas.indexOf(oldEntry);
    if (index != -1) {
      _areas[index] = AreaEntry(area: trimmed, headquarter: newHeadquarter);
    }
    return 'success';
  }

  void deleteArea(AreaEntry entry) {
    _areas.remove(entry);
  }

  // Dialog helper method
  void showAddAreaDialog(BuildContext context, VoidCallback onSuccess) {
    final TextEditingController areaController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? selectedHQ = DataManagementConstants.headquarters.isNotEmpty
        ? DataManagementConstants.headquarters.first
        : null;

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
                items: DataManagementConstants.headquarters
                    .map((hq) => DropdownMenuItem(value: hq, child: Text(hq)))
                    .toList(),
                onChanged: (val) => selectedHQ = val,
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
            onPressed: () {
              if (formKey.currentState!.validate() && selectedHQ != null) {
                final result = addArea(areaController.text, selectedHQ!);
                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Area added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.red,
                    ),
                  );
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
  ) {
    final TextEditingController areaController = TextEditingController(
      text: entry.area,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? selectedHQ = entry.headquarter;

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
                items: DataManagementConstants.headquarters
                    .map((hq) => DropdownMenuItem(value: hq, child: Text(hq)))
                    .toList(),
                onChanged: (val) => selectedHQ = val,
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
            onPressed: () {
              if (formKey.currentState!.validate() && selectedHQ != null) {
                final result = editArea(
                  entry,
                  areaController.text,
                  selectedHQ!,
                );
                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Area updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.red,
                    ),
                  );
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
