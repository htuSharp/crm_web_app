import 'package:flutter/material.dart';
import '../models/stockist_entry.dart';
import '../repositories/stockist_repository.dart';

class StockistManagementService {
  final List<StockistEntry> _stockistList = [];
  final StockistRepository _stockistRepository = StockistRepository();
  bool _isLoading = false;
  String? _error;

  List<StockistEntry> get stockistList => List.unmodifiable(_stockistList);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load stockists from Supabase
  Future<void> loadStockists() async {
    _isLoading = true;
    _error = null;
    try {
      final stockists = await _stockistRepository.getAllStockists();
      _stockistList.clear();
      _stockistList.addAll(stockists);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search stockists in Supabase
  Future<void> searchStockists(String query) async {
    if (query.isEmpty) {
      await loadStockists();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final stockists = await _stockistRepository.searchStockists(query);
      _stockistList.clear();
      _stockistList.addAll(stockists);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Common company types
  static const List<String> companyTypes = [
    'Pharmaceutical Distributor',
    'Medical Equipment Supplier',
    'Surgical Instruments Supplier',
    'Generic Medicine Distributor',
    'Ayurvedic Medicine Distributor',
    'Homeopathic Medicine Distributor',
    'Medical Devices Distributor',
    'Laboratory Equipment Supplier',
    'Hospital Supplies Distributor',
    'Pharmacy Chain',
    'Other',
  ];

  // Validation methods
  String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Stockist name cannot be empty';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateCompany(String company) {
    if (company.trim().isEmpty) {
      return 'Company/Business name cannot be empty';
    }
    if (company.trim().length < 2) {
      return 'Company name must be at least 2 characters';
    }
    return null;
  }

  String? validateContact(String contact) {
    if (contact.trim().isEmpty) {
      return 'Contact information cannot be empty';
    }
    if (contact.trim().length < 10) {
      return 'Please provide complete contact information';
    }
    return null;
  }

  String? validateAddress(String address) {
    if (address.trim().isEmpty) {
      return 'Address cannot be empty';
    }
    if (address.trim().length < 10) {
      return 'Please provide a complete address';
    }
    return null;
  }

  String? validateArea(String area) {
    if (area.trim().isEmpty) {
      return 'Area cannot be empty';
    }
    return null;
  }

  String? validateLicenseNumber(String license) {
    if (license.trim().isEmpty) {
      return 'License number cannot be empty';
    }
    if (license.trim().length < 5) {
      return 'Please enter a valid license number';
    }
    return null;
  }

  // Business logic methods
  Future<bool> isDuplicateStockist(
    String name, {
    StockistEntry? excluding,
  }) async {
    try {
      final stockists = await _stockistRepository.searchStockists(name);
      return stockists.any(
        (entry) =>
            entry.name.toLowerCase() == name.toLowerCase() &&
            entry != excluding,
      );
    } catch (e) {
      return false; // If error, allow operation to proceed
    }
  }

  Future<bool> isDuplicateLicense(
    String license, {
    StockistEntry? excluding,
  }) async {
    try {
      final stockists = await _stockistRepository.searchStockists(license);
      return stockists.any(
        (entry) =>
            entry.licenseNumber.toLowerCase() == license.toLowerCase() &&
            entry != excluding,
      );
    } catch (e) {
      return false; // If error, allow operation to proceed
    }
  }

  Future<String> addStockist({
    required String name,
    required String company,
    required String contact,
    required String address,
    required String area,
    required String licenseNumber,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final companyError = validateCompany(company);
    if (companyError != null) return companyError;

    final contactError = validateContact(contact);
    if (contactError != null) return contactError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final licenseError = validateLicenseNumber(licenseNumber);
    if (licenseError != null) return licenseError;

    final trimmedName = name.trim();
    final trimmedLicense = licenseNumber.trim();

    if (await isDuplicateStockist(trimmedName)) {
      return 'Stockist "$trimmedName" already exists';
    }

    if (await isDuplicateLicense(trimmedLicense)) {
      return 'License number "$trimmedLicense" already exists';
    }

    try {
      final newStockist = StockistEntry(
        name: trimmedName,
        company: company.trim(),
        contact: contact.trim(),
        address: address.trim(),
        area: area.trim(),
        licenseNumber: trimmedLicense,
      );

      await _stockistRepository.createStockist(newStockist);
      _stockistList.add(newStockist);
      return 'success';
    } catch (e) {
      return 'Failed to add stockist: ${e.toString()}';
    }
  }

  Future<String> editStockist({
    required StockistEntry oldEntry,
    required String name,
    required String company,
    required String contact,
    required String address,
    required String area,
    required String licenseNumber,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final companyError = validateCompany(company);
    if (companyError != null) return companyError;

    final contactError = validateContact(contact);
    if (contactError != null) return contactError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final licenseError = validateLicenseNumber(licenseNumber);
    if (licenseError != null) return licenseError;

    final trimmedName = name.trim();
    final trimmedLicense = licenseNumber.trim();

    if (await isDuplicateStockist(trimmedName, excluding: oldEntry)) {
      return 'Stockist "$trimmedName" already exists';
    }

    if (await isDuplicateLicense(trimmedLicense, excluding: oldEntry)) {
      return 'License number "$trimmedLicense" already exists';
    }

    try {
      final updatedStockist = oldEntry.copyWith(
        name: trimmedName,
        company: company.trim(),
        contact: contact.trim(),
        address: address.trim(),
        area: area.trim(),
        licenseNumber: trimmedLicense,
      );

      await _stockistRepository.updateStockist(updatedStockist);

      final index = _stockistList.indexOf(oldEntry);
      if (index != -1) {
        _stockistList[index] = updatedStockist;
      }
      return 'success';
    } catch (e) {
      return 'Failed to update stockist: ${e.toString()}';
    }
  }

  // Delete stockist with database integration
  Future<void> deleteStockist(StockistEntry entry) async {
    try {
      await _stockistRepository.deleteStockist(entry.id!);
      _stockistList.remove(entry);
    } catch (e) {
      throw Exception('Failed to delete stockist: ${e.toString()}');
    }
  }

  // Dialog helper methods
  void showAddStockistDialog(BuildContext context, VoidCallback onSuccess) {
    _showStockistDialog(context, onSuccess, null);
  }

  void showEditStockistDialog(
    BuildContext context,
    StockistEntry entry,
    VoidCallback onSuccess,
  ) {
    _showStockistDialog(context, onSuccess, entry);
  }

  void _showStockistDialog(
    BuildContext context,
    VoidCallback onSuccess,
    StockistEntry? editEntry,
  ) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Controllers
    final nameController = TextEditingController(text: editEntry?.name ?? '');
    final companyController = TextEditingController(
      text: editEntry?.company ?? '',
    );
    final contactController = TextEditingController(
      text: editEntry?.contact ?? '',
    );
    final addressController = TextEditingController(
      text: editEntry?.address ?? '',
    );
    final areaController = TextEditingController(text: editEntry?.area ?? '');
    final licenseController = TextEditingController(
      text: editEntry?.licenseNumber ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editEntry == null ? 'Add Stockist' : 'Edit Stockist'),
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
                      labelText: 'Stockist Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => validateName(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company/Business Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: (value) => validateCompany(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Information *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Phone, Email, etc.',
                    ),
                    validator: (value) => validateContact(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: areaController,
                    decoration: const InputDecoration(
                      labelText: 'Service Area *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) => validateArea(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Business Address *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    maxLines: 3,
                    validator: (value) => validateAddress(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'License Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: licenseController,
                    decoration: const InputDecoration(
                      labelText: 'License Number *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.card_membership),
                      hintText: 'Drug License/Trade License No.',
                    ),
                    validator: (value) => validateLicenseNumber(value ?? ''),
                    textCapitalization: TextCapitalization.characters,
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
                  result = await addStockist(
                    name: nameController.text,
                    company: companyController.text,
                    contact: contactController.text,
                    address: addressController.text,
                    area: areaController.text,
                    licenseNumber: licenseController.text,
                  );
                } else {
                  result = await editStockist(
                    oldEntry: editEntry,
                    name: nameController.text,
                    company: companyController.text,
                    contact: contactController.text,
                    address: addressController.text,
                    area: areaController.text,
                    licenseNumber: licenseController.text,
                  );
                }

                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        editEntry == null
                            ? 'Stockist added successfully!'
                            : 'Stockist updated successfully!',
                      ),
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
            child: Text(editEntry == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}
