import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/mr_entry.dart';
import '../constants/data_management_constants.dart';

class MRManagementService {
  final List<MREntry> _mrList = [];

  List<MREntry> get mrList => List.unmodifiable(_mrList);

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
  bool isDuplicateMR(String name, {MREntry? excluding}) {
    return _mrList.any(
      (entry) =>
          entry.name.toLowerCase() == name.toLowerCase() && entry != excluding,
    );
  }

  String addMR({
    required String name,
    required String age,
    required String sex,
    required String phoneNo,
    required String address,
    required String areaName,
    required String accountNumber,
    required String bankName,
    required String ifscCode,
    required String headquarter,
  }) {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final ageError = validateAge(age);
    if (ageError != null) return ageError;

    final phoneError = validatePhoneNumber(phoneNo);
    if (phoneError != null) return phoneError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final areaError = validateAreaName(areaName);
    if (areaError != null) return areaError;

    final accountError = validateAccountNumber(accountNumber);
    if (accountError != null) return accountError;

    final bankError = validateBankName(bankName);
    if (bankError != null) return bankError;

    final ifscError = validateIFSCCode(ifscCode);
    if (ifscError != null) return ifscError;

    final hqError = validateHeadquarter(headquarter);
    if (hqError != null) return hqError;

    final trimmedName = name.trim();
    if (isDuplicateMR(trimmedName)) {
      return 'MR "$trimmedName" already exists';
    }

    _mrList.add(
      MREntry(
        name: trimmedName,
        age: int.parse(age),
        sex: sex,
        phoneNo: phoneNo.trim(),
        address: address.trim(),
        areaName: areaName.trim(),
        accountNumber: accountNumber.trim(),
        bankName: bankName.trim(),
        ifscCode: ifscCode.trim().toUpperCase(),
        headquarter: headquarter,
      ),
    );

    return 'success';
  }

  String editMR({
    required MREntry oldEntry,
    required String name,
    required String age,
    required String sex,
    required String phoneNo,
    required String address,
    required String areaName,
    required String accountNumber,
    required String bankName,
    required String ifscCode,
    required String headquarter,
  }) {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final ageError = validateAge(age);
    if (ageError != null) return ageError;

    final phoneError = validatePhoneNumber(phoneNo);
    if (phoneError != null) return phoneError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final areaError = validateAreaName(areaName);
    if (areaError != null) return areaError;

    final accountError = validateAccountNumber(accountNumber);
    if (accountError != null) return accountError;

    final bankError = validateBankName(bankName);
    if (bankError != null) return bankError;

    final ifscError = validateIFSCCode(ifscCode);
    if (ifscError != null) return ifscError;

    final hqError = validateHeadquarter(headquarter);
    if (hqError != null) return hqError;

    final trimmedName = name.trim();
    if (isDuplicateMR(trimmedName, excluding: oldEntry)) {
      return 'MR "$trimmedName" already exists';
    }

    final index = _mrList.indexOf(oldEntry);
    if (index != -1) {
      _mrList[index] = MREntry(
        name: trimmedName,
        age: int.parse(age),
        sex: sex,
        phoneNo: phoneNo.trim(),
        address: address.trim(),
        areaName: areaName.trim(),
        accountNumber: accountNumber.trim(),
        bankName: bankName.trim(),
        ifscCode: ifscCode.trim().toUpperCase(),
        headquarter: headquarter,
      );
    }

    return 'success';
  }

  void deleteMR(MREntry entry) {
    _mrList.remove(entry);
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
  ) {
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
    final areaController = TextEditingController(
      text: editEntry?.areaName ?? '',
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

    String selectedSex = editEntry?.sex ?? 'Male';
    String? selectedHQ =
        editEntry?.headquarter ??
        (DataManagementConstants.headquarters.isNotEmpty
            ? DataManagementConstants.headquarters.first
            : null);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: areaController,
                          decoration: const InputDecoration(
                            labelText: 'Area *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          validator: (value) => validateAreaName(value ?? ''),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedHQ,
                          decoration: const InputDecoration(
                            labelText: 'Headquarter *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.business),
                          ),
                          items: DataManagementConstants.headquarters
                              .map(
                                (hq) => DropdownMenuItem(
                                  value: hq,
                                  child: Text(hq),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => selectedHQ = val,
                          validator: (value) => validateHeadquarter(value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Banking Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            onPressed: () {
              if (formKey.currentState!.validate() && selectedHQ != null) {
                String result;
                if (editEntry == null) {
                  result = addMR(
                    name: nameController.text,
                    age: ageController.text,
                    sex: selectedSex,
                    phoneNo: phoneController.text,
                    address: addressController.text,
                    areaName: areaController.text,
                    accountNumber: accountController.text,
                    bankName: bankController.text,
                    ifscCode: ifscController.text,
                    headquarter: selectedHQ!,
                  );
                } else {
                  result = editMR(
                    oldEntry: editEntry,
                    name: nameController.text,
                    age: ageController.text,
                    sex: selectedSex,
                    phoneNo: phoneController.text,
                    address: addressController.text,
                    areaName: areaController.text,
                    accountNumber: accountController.text,
                    bankName: bankController.text,
                    ifscCode: ifscController.text,
                    headquarter: selectedHQ!,
                  );
                }

                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
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
