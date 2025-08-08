import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/mr_entry.dart';
// Used in multi-select area filtering logic
import '../repositories/mr_repository.dart';
import '../services/headquarters_management_service.dart';
import '../services/area_management_service.dart';
import '../widgets/multi_select_dropdown.dart';

class MRManagementService {
  final List<MREntry> _mrList = [];
  final MRRepository _mrRepository = MRRepository();
  final HeadquartersManagementService _headquartersService =
      HeadquartersManagementService();
  final AreaManagementService _areaService = AreaManagementService();
  bool _isLoading = false;
  String? _error;

  List<MREntry> get mrList => List.unmodifiable(_mrList);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load MRs from Supabase
  Future<void> loadMRs() async {
    _isLoading = true;
    _error = null;
    try {
      final mrs = await _mrRepository.getAllMRs();
      _mrList.clear();
      _mrList.addAll(mrs);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search MRs in Supabase
  Future<void> searchMRs(String query) async {
    if (query.isEmpty) {
      await loadMRs();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final mrs = await _mrRepository.searchMRs(query);
      _mrList.clear();
      _mrList.addAll(mrs);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Validation methods
  String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateAge(String age) {
    if (age.trim().isEmpty) {
      return 'Age cannot be empty';
    }
    final ageInt = int.tryParse(age);
    if (ageInt == null) {
      return 'Please enter a valid age';
    }
    if (ageInt < 18 || ageInt > 65) {
      return 'Age must be between 18 and 65';
    }
    return null;
  }

  String? validatePhoneNumber(String phone) {
    if (phone.trim().isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (phone.trim().length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(phone)) {
      return 'Please enter a valid phone number';
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

  String? validateAreaName(String area) {
    if (area.trim().isEmpty) {
      return 'Area name cannot be empty';
    }
    return null;
  }

  String? validateAccountNumber(String account) {
    if (account.trim().isEmpty) {
      return 'Account number cannot be empty';
    }
    if (account.trim().length < 8) {
      return 'Account number must be at least 8 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(account.trim())) {
      return 'Account number must contain only digits';
    }
    return null;
  }

  String? validateBankName(String bank) {
    if (bank.trim().isEmpty) {
      return 'Bank name cannot be empty';
    }
    return null;
  }

  String? validateIFSCCode(String ifsc) {
    if (ifsc.trim().isEmpty) {
      return 'IFSC code cannot be empty';
    }
    if (!RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(ifsc.trim().toUpperCase())) {
      return 'Please enter a valid IFSC code (e.g., SBIN0123456)';
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
  Future<bool> isDuplicateMR(String name, {MREntry? excluding}) async {
    try {
      final mrs = await _mrRepository.searchMRs(name);
      return mrs.any(
        (entry) =>
            entry.name.toLowerCase() == name.toLowerCase() &&
            entry != excluding,
      );
    } catch (e) {
      return false; // If error, allow operation to proceed
    }
  }

  Future<String> addMR({
    required String name,
    required String age,
    required String sex,
    required String phoneNo,
    required String address,
    required List<String> areaNames,
    required String accountNumber,
    required String bankName,
    required String ifscCode,
    required List<String> headquarters,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final ageError = validateAge(age);
    if (ageError != null) return ageError;

    final phoneError = validatePhoneNumber(phoneNo);
    if (phoneError != null) return phoneError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    if (areaNames.isEmpty) return 'Please select at least one area';
    if (headquarters.isEmpty) return 'Please select at least one headquarters';

    final accountError = validateAccountNumber(accountNumber);
    if (accountError != null) return accountError;

    final bankError = validateBankName(bankName);
    if (bankError != null) return bankError;

    final ifscError = validateIFSCCode(ifscCode);
    if (ifscError != null) return ifscError;

    final trimmedName = name.trim();
    if (await isDuplicateMR(trimmedName)) {
      return 'MR "$trimmedName" already exists';
    }

    try {
      final newMR = MREntry(
        name: trimmedName,
        age: int.parse(age),
        sex: sex,
        phoneNo: phoneNo.trim(),
        address: address.trim(),
        areaNames: areaNames,
        accountNumber: accountNumber.trim(),
        bankName: bankName.trim(),
        ifscCode: ifscCode.trim().toUpperCase(),
        headquarters: headquarters,
      ).withGeneratedId();

      await _mrRepository.createMR(newMR);
      _mrList.add(newMR);
      return 'success';
    } catch (e) {
      return 'Failed to add MR: ${e.toString()}';
    }
  }

  Future<String> editMR({
    required MREntry oldEntry,
    required String name,
    required String age,
    required String sex,
    required String phoneNo,
    required String address,
    required List<String> areaNames,
    required String accountNumber,
    required String bankName,
    required String ifscCode,
    required List<String> headquarters,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final ageError = validateAge(age);
    if (ageError != null) return ageError;

    final phoneError = validatePhoneNumber(phoneNo);
    if (phoneError != null) return phoneError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    if (areaNames.isEmpty) return 'Please select at least one area';
    if (headquarters.isEmpty) return 'Please select at least one headquarters';

    final accountError = validateAccountNumber(accountNumber);
    if (accountError != null) return accountError;

    final bankError = validateBankName(bankName);
    if (bankError != null) return bankError;

    final ifscError = validateIFSCCode(ifscCode);
    if (ifscError != null) return ifscError;

    final trimmedName = name.trim();
    if (await isDuplicateMR(trimmedName, excluding: oldEntry)) {
      return 'MR "$trimmedName" already exists';
    }

    try {
      final updatedMR = oldEntry.copyWith(
        name: trimmedName,
        age: int.parse(age),
        sex: sex,
        phoneNo: phoneNo.trim(),
        address: address.trim(),
        areaNames: areaNames,
        accountNumber: accountNumber.trim(),
        bankName: bankName.trim(),
        ifscCode: ifscCode.trim().toUpperCase(),
        headquarters: headquarters,
      );

      await _mrRepository.updateMR(updatedMR);

      final index = _mrList.indexOf(oldEntry);
      if (index != -1) {
        _mrList[index] = updatedMR;
      }
      return 'success';
    } catch (e) {
      return 'Failed to update MR: ${e.toString()}';
    }
  }

  // Delete MR with database integration
  Future<void> deleteMR(MREntry entry) async {
    try {
      await _mrRepository.deleteMR(entry.id!);
      _mrList.remove(entry);
    } catch (e) {
      throw Exception('Failed to delete MR: ${e.toString()}');
    }
  }

  // Dialog helper method
  void showAddMRDialog(BuildContext context, VoidCallback onSuccess) {
    _showMRDialog(context, onSuccess, null);
  }

  void showEditMRDialog(
    BuildContext context,
    MREntry entry,
    VoidCallback onSuccess,
  ) {
    _showMRDialog(context, onSuccess, entry);
  }

  void _showMRDialog(
    BuildContext context,
    VoidCallback onSuccess,
    MREntry? editEntry,
  ) async {
    // Load data from services
    await _headquartersService.loadHeadquarters();
    await _areaService.loadAreas();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Controllers
    final nameController = TextEditingController(text: editEntry?.name ?? '');
    final ageController = TextEditingController(
      text: editEntry?.age.toString() ?? '',
    );
    final phoneController = TextEditingController(
      text: editEntry?.phoneNo ?? '',
    );
    final addressController = TextEditingController(
      text: editEntry?.address ?? '',
    );
    final accountController = TextEditingController(
      text: editEntry?.accountNumber ?? '',
    );
    final bankController = TextEditingController(
      text: editEntry?.bankName ?? '',
    );
    final ifscController = TextEditingController(
      text: editEntry?.ifscCode ?? '',
    );

    // Selected values and available options
    final availableHeadquarters = _headquartersService.headquartersNames;
    final availableAreas = _areaService.areas;

    String selectedSex = editEntry?.sex ?? 'Male';
    List<String> selectedHeadquarters = editEntry?.headquarters ?? [];
    List<String> selectedAreas = editEntry?.areaNames ?? [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(editEntry == null ? 'Add New MR' : 'Edit MR'),
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
                        labelText: 'Full Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => validateName(value ?? ''),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.cake),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) => validateAge(value ?? ''),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSex,
                            decoration: const InputDecoration(
                              labelText: 'Gender *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.wc),
                            ),
                            items: ['Male', 'Female', 'Other']
                                .map(
                                  (sex) => DropdownMenuItem(
                                    value: sex,
                                    child: Text(sex),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => selectedSex = val ?? 'Male',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => validatePhoneNumber(value ?? ''),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                      ),
                      maxLines: 2,
                      validator: (value) => validateAddress(value ?? ''),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // Headquarters multi-select
                    MultiSelectDropdown<String>(
                      items: availableHeadquarters,
                      selectedItems: selectedHeadquarters,
                      onSelectionChanged: (selected) {
                        setState(() {
                          selectedHeadquarters = selected;
                          // Filter areas based on selected headquarters
                          selectedAreas = selectedAreas.where((area) {
                            return availableAreas.any(
                              (areaEntry) =>
                                  areaEntry.area == area &&
                                  selectedHeadquarters.contains(
                                    areaEntry.headquarter,
                                  ),
                            );
                          }).toList();
                        });
                      },
                      displayText: (hq) => hq,
                      labelText: 'Headquarters',
                      hintText: 'Select headquarters',
                      prefixIcon: Icons.business,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select at least one headquarters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Areas multi-select
                    MultiSelectDropdown<String>(
                      items: selectedHeadquarters.isEmpty
                          ? []
                          : availableAreas
                                .where(
                                  (area) => selectedHeadquarters.contains(
                                    area.headquarter,
                                  ),
                                )
                                .map((area) => area.area)
                                .toList(),
                      selectedItems: selectedAreas,
                      onSelectionChanged: (selected) {
                        setState(() {
                          selectedAreas = selected;
                        });
                      },
                      displayText: (area) => area,
                      labelText: 'Areas',
                      hintText: selectedHeadquarters.isEmpty
                          ? 'Select headquarters first'
                          : 'Select areas',
                      prefixIcon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select at least one area';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      'Banking Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: accountController,
                      decoration: const InputDecoration(
                        labelText: 'Account Number *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_balance),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => validateAccountNumber(value ?? ''),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: bankController,
                      decoration: const InputDecoration(
                        labelText: 'Bank Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_balance),
                      ),
                      validator: (value) => validateBankName(value ?? ''),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: ifscController,
                      decoration: const InputDecoration(
                        labelText: 'IFSC Code *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.code),
                        hintText: 'e.g., SBIN0123456',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) => validateIFSCCode(value ?? ''),
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
                    selectedHeadquarters.isNotEmpty &&
                    selectedAreas.isNotEmpty) {
                  String result;
                  if (editEntry == null) {
                    result = await addMR(
                      name: nameController.text,
                      age: ageController.text,
                      sex: selectedSex,
                      phoneNo: phoneController.text,
                      address: addressController.text,
                      areaNames: selectedAreas,
                      accountNumber: accountController.text,
                      bankName: bankController.text,
                      ifscCode: ifscController.text,
                      headquarters: selectedHeadquarters,
                    );
                  } else {
                    result = await editMR(
                      oldEntry: editEntry,
                      name: nameController.text,
                      age: ageController.text,
                      sex: selectedSex,
                      phoneNo: phoneController.text,
                      address: addressController.text,
                      areaNames: selectedAreas,
                      accountNumber: accountController.text,
                      bankName: bankController.text,
                      ifscCode: ifscController.text,
                      headquarters: selectedHeadquarters,
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
                                ? 'MR added successfully!'
                                : 'MR updated successfully!',
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
