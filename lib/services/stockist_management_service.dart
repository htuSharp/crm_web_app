import 'package:flutter/material.dart';
import '../models/stockist_entry.dart';
import '../services/headquarters_management_service.dart';
import '../services/area_management_service.dart';
import '../repositories/stockist_repository.dart';
import '../utils/gst_validator.dart';

class StockistManagementService {
  final List<StockistEntry> _stockistList = [];
  final StockistRepository _stockistRepository = StockistRepository();
  bool _isLoading = false;
  String? _error;

  // Dependencies for dropdowns
  final HeadquartersManagementService _headquartersService =
      HeadquartersManagementService();
  final AreaManagementService _areaService = AreaManagementService();

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

  String? validateGSTNumber(String gstNumber) {
    return GSTValidator.validateGSTNumber(gstNumber);
  }

  String? validateLicense20B(String license) {
    // Optional field
    if (license.trim().isEmpty) {
      return null;
    }
    if (license.trim().length < 5) {
      return 'Please enter a valid 20B license number';
    }
    return null;
  }

  String? validateLicense21B(String license) {
    // Optional field
    if (license.trim().isEmpty) {
      return null;
    }
    if (license.trim().length < 5) {
      return 'Please enter a valid 21B license number';
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

  Future<String> addStockist({
    required String name,
    required String company,
    required String contact,
    required String address,
    required String headquarter,
    required String gstNumber,
    String? license20B,
    String? license21B,
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

    final gstError = validateGSTNumber(gstNumber);
    if (gstError != null) return gstError;

    final license20BError = validateLicense20B(license20B ?? '');
    if (license20BError != null) return license20BError;

    final license21BError = validateLicense21B(license21B ?? '');
    if (license21BError != null) return license21BError;

    final trimmedName = name.trim();
    final trimmedGST = gstNumber.trim().toUpperCase();

    if (await isDuplicateStockist(trimmedName)) {
      return 'Stockist "$trimmedName" already exists';
    }

    try {
      final newStockist = StockistEntry(
        name: trimmedName,
        company: company.trim(),
        contact: contact.trim(),
        address: address.trim(),
        headquarter: headquarter,
        gstNumber: trimmedGST,
        license20B: license20B?.trim() ?? '',
        license21B: license21B?.trim() ?? '',
      ).withGeneratedId();

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
    required String headquarter,
    required String gstNumber,
    String? license20B,
    String? license21B,
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

    final gstError = validateGSTNumber(gstNumber);
    if (gstError != null) return gstError;

    final license20BError = validateLicense20B(license20B ?? '');
    if (license20BError != null) return license20BError;

    final license21BError = validateLicense21B(license21B ?? '');
    if (license21BError != null) return license21BError;

    final trimmedName = name.trim();
    final trimmedGST = gstNumber.trim().toUpperCase();

    if (await isDuplicateStockist(trimmedName, excluding: oldEntry)) {
      return 'Stockist "$trimmedName" already exists';
    }

    try {
      final updatedStockist = oldEntry.copyWith(
        name: trimmedName,
        company: company.trim(),
        contact: contact.trim(),
        address: address.trim(),
        headquarter: headquarter,
        gstNumber: trimmedGST,
        license20B: license20B?.trim() ?? '',
        license21B: license21B?.trim() ?? '',
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
  ) async {
    // Load data from services
    await _headquartersService.loadHeadquarters();
    await _areaService.loadAreas();

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
    final gstController = TextEditingController(
      text: editEntry?.gstNumber ?? '',
    );
    final license20BController = TextEditingController(
      text: editEntry?.license20B ?? '',
    );
    final license21BController = TextEditingController(
      text: editEntry?.license21B ?? '',
    );

    // Selected values and available options
    final availableHeadquarters = _headquartersService.headquartersNames;

    String? selectedHeadquarter = editEntry?.headquarter;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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

                    // Headquarters dropdown
                    DropdownButtonFormField<String>(
                      value: selectedHeadquarter,
                      decoration: const InputDecoration(
                        labelText: 'Headquarters',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: availableHeadquarters.map((hq) {
                        return DropdownMenuItem<String>(
                          value: hq,
                          child: Text(hq),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHeadquarter = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select headquarters';
                        }
                        return null;
                      },
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
                    TextFormField(
                      controller: gstController,
                      decoration: const InputDecoration(
                        labelText: 'GST Number *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.receipt_long),
                        hintText: '15-digit GST number',
                      ),
                      validator: (value) => validateGSTNumber(value ?? ''),
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (value) {
                        if (value.length == 15) {
                          // Auto-format GST number
                          final formatted = GSTValidator.formatGST(value);
                          if (formatted != value) {
                            gstController.text = formatted;
                            gstController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(offset: formatted.length),
                                );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      'License Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: license20BController,
                      decoration: const InputDecoration(
                        labelText: '20B License Number (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.card_membership),
                        hintText: 'Drug License 20B',
                      ),
                      validator: (value) => validateLicense20B(value ?? ''),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: license21BController,
                      decoration: const InputDecoration(
                        labelText: '21B License Number (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.card_membership),
                        hintText: 'Drug License 21B',
                      ),
                      validator: (value) => validateLicense21B(value ?? ''),
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
                if (formKey.currentState!.validate() &&
                    selectedHeadquarter != null) {
                  String result;
                  if (editEntry == null) {
                    result = await addStockist(
                      name: nameController.text,
                      company: companyController.text,
                      contact: contactController.text,
                      address: addressController.text,
                      headquarter: selectedHeadquarter!,
                      gstNumber: gstController.text,
                      license20B: license20BController.text.isEmpty
                          ? null
                          : license20BController.text,
                      license21B: license21BController.text.isEmpty
                          ? null
                          : license21BController.text,
                    );
                  } else {
                    result = await editStockist(
                      oldEntry: editEntry,
                      name: nameController.text,
                      company: companyController.text,
                      contact: contactController.text,
                      address: addressController.text,
                      headquarter: selectedHeadquarter!,
                      gstNumber: gstController.text,
                      license20B: license20BController.text.isEmpty
                          ? null
                          : license20BController.text,
                      license21B: license21BController.text.isEmpty
                          ? null
                          : license21BController.text,
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
                                ? 'Stockist added successfully!'
                                : 'Stockist updated successfully!',
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
