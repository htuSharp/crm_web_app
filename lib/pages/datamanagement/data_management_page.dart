import 'package:flutter/material.dart';
import '../../widgets/category_tabs_widget.dart';
import '../../services/area_management_service.dart';
import '../../services/mr_management_service.dart';
import '../../services/medical_management_service.dart';
import '../../services/doctor_management_service.dart';
import '../../services/stockist_management_service.dart';
import '../../services/specialty_management_service.dart';
import '../../services/headquarters_management_service.dart';

class DataManagementPage extends StatefulWidget {
  const DataManagementPage({super.key});

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage>
    with TickerProviderStateMixin {
  String selectedCategory = 'Specialties';

  // Service instances
  final AreaManagementService _areaService = AreaManagementService();
  final MRManagementService _mrService = MRManagementService();
  final MedicalManagementService _medicalService = MedicalManagementService();
  final DoctorManagementService _doctorService = DoctorManagementService();
  final StockistManagementService _stockistService =
      StockistManagementService();
  final SpecialtyManagementService _specialtyService =
      SpecialtyManagementService();
  final HeadquartersManagementService _headquartersService =
      HeadquartersManagementService();

  // Search controllers for each section
  final TextEditingController _specialtySearchController =
      TextEditingController();
  final TextEditingController _headquartersSearchController =
      TextEditingController();
  final TextEditingController _areaSearchController = TextEditingController();
  final TextEditingController _mrSearchController = TextEditingController();
  final TextEditingController _medicalSearchController =
      TextEditingController();
  final TextEditingController _doctorSearchController = TextEditingController();
  final TextEditingController _stockistSearchController =
      TextEditingController();

  // Search query strings
  String _specialtySearchQuery = '';
  String _headquartersSearchQuery = '';
  String _areaSearchQuery = '';
  String _mrSearchQuery = '';
  String _medicalSearchQuery = '';
  String _doctorSearchQuery = '';
  String _stockistSearchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _specialtySearchController.dispose();
    _headquartersSearchController.dispose();
    _areaSearchController.dispose();
    _mrSearchController.dispose();
    _medicalSearchController.dispose();
    _doctorSearchController.dispose();
    _stockistSearchController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _refreshCurrentSection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (selectedCategory) {
      case 'Specialties':
        content = _buildSpecialtySection();
        break;
      case 'Headquarters':
        content = _buildHeadquartersSection();
        break;
      case 'Areas':
        content = _buildAreaSection();
        break;
      case 'MR':
        content = _buildMRSection();
        break;
      case 'Medicals':
        content = _buildMedicalSection();
        break;
      case 'Doctors':
        content = _buildDoctorSection();
        break;
      case 'Stockist':
        content = _buildStockistSection();
        break;
      default:
        content = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryTabsWidget(
            selectedCategory: selectedCategory,
            onCategoryChanged: _onCategoryChanged,
          ),
          content,
        ],
      ),
    );
  }

  Widget _buildSpecialtySection() {
    // Filter specialties based on search query
    final filteredSpecialties = _specialtyService.specialtyList.where((
      specialty,
    ) {
      return specialty.toLowerCase().contains(
        _specialtySearchQuery.toLowerCase(),
      );
    }).toList();

    return Expanded(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.medical_services, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    'Specialties',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _specialtySearchController,
                      onChanged: (value) {
                        setState(() {
                          _specialtySearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search specialties...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _specialtySearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _specialtySearchController.clear();
                                  setState(() {
                                    _specialtySearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _specialtyService.showAddSpecialtyDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: filteredSpecialties.isEmpty
                ? Center(
                    child: Text(
                      _specialtySearchQuery.isNotEmpty
                          ? 'No specialties found matching "$_specialtySearchQuery"'
                          : 'No specialties added yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredSpecialties.length,
                    itemBuilder: (context, index) {
                      final specialty = filteredSpecialties[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.medical_services),
                          title: Text(specialty),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _specialtyService.showEditSpecialtyDialog(
                                      context,
                                      specialty,
                                      _refreshCurrentSection,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  'specialty',
                                  specialty,
                                  () {
                                    _specialtyService.deleteSpecialty(
                                      specialty,
                                    );
                                    _refreshCurrentSection();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadquartersSection() {
    // Filter headquarters based on search query
    final filteredHeadquarters = _headquartersService.headquartersList.where((
      headquarters,
    ) {
      return headquarters.toLowerCase().contains(
        _headquartersSearchQuery.toLowerCase(),
      );
    }).toList();

    return Expanded(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.location_city, color: Colors.green),
                  const SizedBox(width: 12),
                  const Text(
                    'Headquarters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _headquartersSearchController,
                      onChanged: (value) {
                        setState(() {
                          _headquartersSearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search headquarters...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _headquartersSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _headquartersSearchController.clear();
                                  setState(() {
                                    _headquartersSearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _headquartersService.showAddHeadquartersDialog(
                          context,
                          _refreshCurrentSection,
                        ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredHeadquarters.isEmpty
                ? Center(
                    child: Text(
                      _headquartersSearchQuery.isNotEmpty
                          ? 'No headquarters found matching "$_headquartersSearchQuery"'
                          : 'No headquarters added yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredHeadquarters.length,
                    itemBuilder: (context, index) {
                      final headquarters = filteredHeadquarters[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.location_city),
                          title: Text(headquarters),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _headquartersService
                                    .showEditHeadquartersDialog(
                                      context,
                                      headquarters,
                                      _refreshCurrentSection,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  'headquarters',
                                  headquarters,
                                  () {
                                    _headquartersService.deleteHeadquarters(
                                      headquarters,
                                    );
                                    _refreshCurrentSection();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaSection() {
    // Filter areas based on search query
    final filteredAreas = _areaService.areas.where((area) {
      return area.area.toLowerCase().contains(_areaSearchQuery.toLowerCase()) ||
          area.headquarter.toLowerCase().contains(
            _areaSearchQuery.toLowerCase(),
          );
    }).toList();

    return Expanded(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.map, color: Colors.orange),
                  const SizedBox(width: 12),
                  const Text(
                    'Areas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _areaSearchController,
                      onChanged: (value) {
                        setState(() {
                          _areaSearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search areas, headquarters...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _areaSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _areaSearchController.clear();
                                  setState(() {
                                    _areaSearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _areaService.showAddAreaDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredAreas.isEmpty
                ? Center(
                    child: Text(
                      _areaSearchQuery.isNotEmpty
                          ? 'No areas found matching "$_areaSearchQuery"'
                          : 'No areas added yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredAreas.length,
                    itemBuilder: (context, index) {
                      final area = filteredAreas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.map),
                          title: Text(area.area),
                          subtitle: Text('HQ: ${area.headquarter}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _areaService.showEditAreaDialog(
                                      context,
                                      area,
                                      _refreshCurrentSection,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  'area',
                                  area.area,
                                  () {
                                    _areaService.deleteArea(area);
                                    _refreshCurrentSection();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMRSection() {
    // Filter MRs based on search query
    final filteredMRs = _mrService.mrList.where((mr) {
      return mr.name.toLowerCase().contains(_mrSearchQuery.toLowerCase()) ||
          mr.phoneNo.toLowerCase().contains(_mrSearchQuery.toLowerCase()) ||
          mr.areaName.toLowerCase().contains(_mrSearchQuery.toLowerCase()) ||
          mr.headquarter.toLowerCase().contains(_mrSearchQuery.toLowerCase());
    }).toList();

    return Expanded(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.purple),
                  const SizedBox(width: 12),
                  const Text(
                    'MR',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _mrSearchController,
                      onChanged: (value) {
                        setState(() {
                          _mrSearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search MRs by name, phone, area...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _mrSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _mrSearchController.clear();
                                  setState(() {
                                    _mrSearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _mrService.showAddMRDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredMRs.isEmpty
                ? Center(
                    child: Text(
                      _mrSearchQuery.isNotEmpty
                          ? 'No medical representatives found matching "$_mrSearchQuery"'
                          : 'No medical representatives added yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredMRs.length,
                    itemBuilder: (context, index) {
                      final mr = filteredMRs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(mr.name),
                          subtitle: Text('${mr.phoneNo} • ${mr.areaName}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _mrService.showEditMRDialog(
                                  context,
                                  mr,
                                  _refreshCurrentSection,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  'MR',
                                  mr.name,
                                  () {
                                    _mrService.deleteMR(mr);
                                    _refreshCurrentSection();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalSection() {
    // Filter medical facilities based on search query
    final filteredMedicals = _medicalService.medicalsList.where((medical) {
      return medical.name.toLowerCase().contains(
            _medicalSearchQuery.toLowerCase(),
          ) ||
          medical.headquarter.toLowerCase().contains(
            _medicalSearchQuery.toLowerCase(),
          ) ||
          medical.area.toLowerCase().contains(
            _medicalSearchQuery.toLowerCase(),
          ) ||
          medical.contactPerson.toLowerCase().contains(
            _medicalSearchQuery.toLowerCase(),
          ) ||
          medical.phoneNo.toLowerCase().contains(
            _medicalSearchQuery.toLowerCase(),
          ) ||
          medical.address.toLowerCase().contains(
            _medicalSearchQuery.toLowerCase(),
          ) ||
          medical.attachedDoctor.toLowerCase().contains(
            _medicalSearchQuery.toLowerCase(),
          );
    }).toList();

    return Expanded(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, color: Colors.red),
                  const SizedBox(width: 12),
                  const Text(
                    'Medicals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _medicalSearchController,
                      onChanged: (value) {
                        setState(() {
                          _medicalSearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by name, HQ, area, contact...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _medicalSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _medicalSearchController.clear();
                                  setState(() {
                                    _medicalSearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _medicalService.showAddMedicalDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredMedicals.isEmpty
                ? Center(
                    child: Text(
                      _medicalSearchQuery.isNotEmpty
                          ? 'No medical facilities found matching "$_medicalSearchQuery"'
                          : 'No medical facilities added yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredMedicals.length,
                    itemBuilder: (context, index) {
                      final medical = filteredMedicals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.local_hospital),
                          title: Text(medical.name),
                          subtitle: Text(
                            '${medical.contactPerson} • ${medical.phoneNo} • ${medical.area}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _medicalService.showEditMedicalDialog(
                                      context,
                                      medical,
                                      _refreshCurrentSection,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  'medical facility',
                                  medical.name,
                                  () {
                                    _medicalService.deleteMedical(medical);
                                    _refreshCurrentSection();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSection() {
    // Filter doctors based on search query
    final filteredDoctors = _doctorService.doctorsList.where((doctor) {
      return doctor.name.toLowerCase().contains(
            _doctorSearchQuery.toLowerCase(),
          ) ||
          doctor.specialty.toLowerCase().contains(
            _doctorSearchQuery.toLowerCase(),
          ) ||
          doctor.area.toLowerCase().contains(
            _doctorSearchQuery.toLowerCase(),
          ) ||
          doctor.phoneNo.toLowerCase().contains(
            _doctorSearchQuery.toLowerCase(),
          );
    }).toList();

    return Expanded(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.teal),
                  const SizedBox(width: 12),
                  const Text(
                    'Doctors',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _doctorSearchController,
                      onChanged: (value) {
                        setState(() {
                          _doctorSearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by name, specialty, area, phone...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _doctorSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _doctorSearchController.clear();
                                  setState(() {
                                    _doctorSearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _doctorService.showAddDoctorDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredDoctors.isEmpty
                ? Center(
                    child: Text(
                      _doctorSearchQuery.isNotEmpty
                          ? 'No doctors found matching "$_doctorSearchQuery"'
                          : 'No doctors added yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text('Dr. ${doctor.name}'),
                          subtitle: Text(
                            '${doctor.specialty} • ${doctor.area} • ${doctor.phoneNo}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _doctorService.showEditDoctorDialog(
                                      context,
                                      doctor,
                                      _refreshCurrentSection,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  'doctor',
                                  doctor.name,
                                  () {
                                    _doctorService.deleteDoctor(doctor);
                                    _refreshCurrentSection();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockistSection() {
    // Filter stockists based on search query
    final filteredStockists = _stockistService.stockistList.where((stockist) {
      return stockist.name.toLowerCase().contains(
            _stockistSearchQuery.toLowerCase(),
          ) ||
          stockist.company.toLowerCase().contains(
            _stockistSearchQuery.toLowerCase(),
          ) ||
          stockist.contact.toLowerCase().contains(
            _stockistSearchQuery.toLowerCase(),
          ) ||
          stockist.area.toLowerCase().contains(
            _stockistSearchQuery.toLowerCase(),
          ) ||
          stockist.address.toLowerCase().contains(
            _stockistSearchQuery.toLowerCase(),
          ) ||
          stockist.licenseNumber.toLowerCase().contains(
            _stockistSearchQuery.toLowerCase(),
          );
    }).toList();

    return Expanded(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.business, color: Colors.indigo),
                  const SizedBox(width: 12),
                  const Text(
                    'Stockists',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _stockistSearchController,
                      onChanged: (value) {
                        setState(() {
                          _stockistSearchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by name, company, area, license...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _stockistSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _stockistSearchController.clear();
                                  setState(() {
                                    _stockistSearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _stockistService.showAddStockistDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredStockists.isEmpty
                ? Center(
                    child: Text(
                      _stockistSearchQuery.isNotEmpty
                          ? 'No stockists found matching "$_stockistSearchQuery"'
                          : 'No stockists added yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredStockists.length,
                    itemBuilder: (context, index) {
                      final stockist = filteredStockists[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.business),
                          title: Text(stockist.name),
                          subtitle: Text(
                            '${stockist.company} • ${stockist.area}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _stockistService.showEditStockistDialog(
                                      context,
                                      stockist,
                                      _refreshCurrentSection,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  'stockist',
                                  stockist.name,
                                  () {
                                    _stockistService.deleteStockist(stockist);
                                    _refreshCurrentSection();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String itemType,
    String itemName,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $itemType'),
        content: Text(
          'Are you sure you want to delete "$itemName"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$itemName deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
