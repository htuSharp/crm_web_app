import 'dart:async';
import 'package:flutter/material.dart';
import '../models/mr_entry.dart';
import '../constants/data_management_constants.dart';
import '../widgets/pagination_widget.dart';

class MRManagementSection extends StatefulWidget {
  final List<MREntry> mrList;
  final Function(MREntry) onAdd;
  final Function(MREntry, MREntry) onEdit;
  final Function(MREntry) onDelete;
  final String? recentlyAdded;

  const MRManagementSection({
    super.key,
    required this.mrList,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.recentlyAdded,
  });

  @override
  State<MRManagementSection> createState() => _MRManagementSectionState();
}

class _MRManagementSectionState extends State<MRManagementSection> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  String _searchQuery = '';
  int _currentPage = 1;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _showAddMRDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final areaController = TextEditingController();
    final accountController = TextEditingController();
    final bankController = TextEditingController();
    final ifscController = TextEditingController();

    String? selectedHQ = DataManagementConstants.headquarters.isNotEmpty
        ? DataManagementConstants.headquarters.first
        : null;
    String selectedSex = 'Male';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add new MR', style: DataManagementStyles.titleStyle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: DataManagementStyles.inputStyle,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageController,
                style: DataManagementStyles.inputStyle,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedSex,
                items: ['Male', 'Female', 'Other']
                    .map(
                      (sex) => DropdownMenuItem(value: sex, child: Text(sex)),
                    )
                    .toList(),
                onChanged: (val) => selectedSex = val ?? 'Male',
                decoration: const InputDecoration(
                  labelText: 'Sex',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                style: DataManagementStyles.inputStyle,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone No',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                style: DataManagementStyles.inputStyle,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: areaController,
                style: DataManagementStyles.inputStyle,
                decoration: const InputDecoration(
                  labelText: 'Area Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedHQ,
                items: DataManagementConstants.headquarters
                    .map((hq) => DropdownMenuItem(value: hq, child: Text(hq)))
                    .toList(),
                onChanged: (val) => selectedHQ = val,
                decoration: const InputDecoration(
                  labelText: 'Select Headquarter',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: accountController,
                style: DataManagementStyles.inputStyle,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bankController,
                style: DataManagementStyles.inputStyle,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ifscController,
                style: DataManagementStyles.inputStyle,
                decoration: const InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: DataManagementStyles.buttonStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && selectedHQ != null) {
                final mrEntry = MREntry(
                  name: nameController.text,
                  age: int.tryParse(ageController.text) ?? 0,
                  sex: selectedSex,
                  phoneNo: phoneController.text,
                  address: addressController.text,
                  areaName: areaController.text,
                  accountNumber: accountController.text,
                  bankName: bankController.text,
                  ifscCode: ifscController.text,
                  headquarter: selectedHQ!,
                );
                widget.onAdd(mrEntry);
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: DataManagementStyles.buttonStyle),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(MREntry entry) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Confirm Delete',
          style: DataManagementStyles.titleStyle,
        ),
        content: const Text(
          'Are you sure you want to delete this MR?',
          style: DataManagementStyles.contentStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: DataManagementStyles.buttonStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete(entry);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Delete',
              style: DataManagementStyles.buttonStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.mrList
        .where(
          (entry) =>
              entry.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              entry.areaName.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    final totalEntries = filteredList.length;
    final start = (_currentPage - 1) * DataManagementConstants.entriesPerPage;
    final end = (start + DataManagementConstants.entriesPerPage).clamp(
      0,
      totalEntries,
    );
    final pageList = filteredList.sublist(start, end);

    return Expanded(
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: DataManagementStyles.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MR Management',
                style: DataManagementStyles.titleStyle,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: DataManagementStyles.inputStyle,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: DataManagementStyles.iconSize,
                        ),
                        hintText: 'Search MR...',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: DataManagementStyles.inputPadding,
                      ),
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(
                          DataManagementConstants.debounceDelay,
                          () {
                            setState(() {
                              _searchQuery = value;
                              _currentPage = 1;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: DataManagementStyles.buttonPadding,
                      textStyle: DataManagementStyles.buttonStyle,
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add MR'),
                    onPressed: _showAddMRDialog,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Table header
              Container(
                color: Colors.grey[200],
                padding: DataManagementStyles.inputPadding,
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Name',
                        style: DataManagementStyles.titleStyle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Area',
                        style: DataManagementStyles.titleStyle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Headquarters',
                        style: DataManagementStyles.titleStyle,
                      ),
                    ),
                    SizedBox(width: 48), // For actions
                  ],
                ),
              ),
              Expanded(
                child: pageList.isEmpty
                    ? const Center(
                        child: Text(
                          'No items found.',
                          style: DataManagementStyles.hintStyle,
                        ),
                      )
                    : ListView.separated(
                        controller: _listScrollController,
                        itemCount: pageList.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Colors.grey),
                        itemBuilder: (context, idx) {
                          final entry = pageList[idx];
                          final isNew = entry.name == widget.recentlyAdded;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                              color: isNew ? Colors.yellow[100] : null,
                              borderRadius:
                                  DataManagementStyles.defaultBorderRadius,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        DataManagementStyles.listItemPadding,
                                    child: Text(
                                      entry.name,
                                      style: DataManagementStyles.contentStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        DataManagementStyles.listItemPadding,
                                    child: Text(
                                      entry.areaName,
                                      style: DataManagementStyles.contentStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        DataManagementStyles.listItemPadding,
                                    child: Text(
                                      entry.headquarter,
                                      style: DataManagementStyles.contentStyle,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: DataManagementStyles.iconSize,
                                  ),
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    // TODO: Implement edit functionality
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: DataManagementStyles.iconSize,
                                  ),
                                  tooltip: 'Delete',
                                  onPressed: () => _showDeleteDialog(entry),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              if (totalEntries > DataManagementConstants.entriesPerPage)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: PaginationWidget(
                    currentPage: _currentPage,
                    totalEntries: totalEntries,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
