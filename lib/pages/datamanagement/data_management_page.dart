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
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load data from Supabase when page loads
    await Future.wait([
      _specialtyService.loadSpecialties(),
      _headquartersService.loadHeadquarters(),
      _areaService.loadAreas(),
      _mrService.loadMRs(),
      _medicalService.loadMedicals(),
      _doctorService.loadDoctors(),
      _stockistService.loadStockists(),
    ]);

    if (mounted) {
      setState(() {});
    }
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

  Future<void> _refreshCurrentSection() async {
    // Reload data from Supabase based on current section
    switch (selectedCategory) {
      case 'Specialties':
        await _specialtyService.loadSpecialties();
        break;
      case 'Headquarters':
        await _headquartersService.loadHeadquarters();
        break;
      case 'Areas':
        await _areaService.loadAreas();
        break;
      case 'MR':
        await _mrService.loadMRs();
        break;
      case 'Medicals':
        await _medicalService.loadMedicals();
        break;
      case 'Doctors':
        await _doctorService.loadDoctors();
        break;
      case 'Stockist':
        await _stockistService.loadStockists();
        break;
      default:
        break;
    }

    if (mounted) {
      setState(() {});
    }
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
    final filteredSpecialties = _specialtyService.specialtyNames.where((
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
                                onPressed: () => _showAsyncDeleteConfirmation(
                                  context,
                                  'specialty',
                                  specialty,
                                  () async {
                                    await _specialtyService.deleteSpecialty(
                                      specialty,
                                    );
                                    await _refreshCurrentSection();
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
    final filteredHeadquarters = _headquartersService.headquartersNames.where((
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
                                onPressed: () => _showAsyncDeleteConfirmation(
                                  context,
                                  'headquarters',
                                  headquarters,
                                  () async {
                                    await _headquartersService
                                        .deleteHeadquarters(headquarters);
                                    await _refreshCurrentSection();
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
                                onPressed: () => _showAsyncDeleteConfirmation(
                                  context,
                                  'area',
                                  area.area,
                                  () async {
                                    await _areaService.deleteArea(area);
                                    await _refreshCurrentSection();
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
          mr.areaNames.any(
            (area) => area.toLowerCase().contains(_mrSearchQuery.toLowerCase()),
          ) ||
          mr.headquarters.any(
            (hq) => hq.toLowerCase().contains(_mrSearchQuery.toLowerCase()),
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
                          subtitle: Text(
                            '${mr.phoneNo} • ${mr.areaNames.join(", ")}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.green,
                                ),
                                onPressed: () => _showMRViewDialog(context, mr),
                              ),
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
                                onPressed: () => _showAsyncDeleteConfirmation(
                                  context,
                                  'MR',
                                  mr.name,
                                  () async {
                                    await _mrService.deleteMR(mr);
                                    await _refreshCurrentSection();
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
                                  Icons.visibility,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    _showMedicalViewDialog(context, medical),
                              ),
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
                                onPressed: () => _showAsyncDeleteConfirmation(
                                  context,
                                  'medical facility',
                                  medical.name,
                                  () async {
                                    await _medicalService.deleteMedical(
                                      medical,
                                    );
                                    await _refreshCurrentSection();
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
    // Show loading state
    if (_doctorService.isLoading) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading doctors...'),
            ],
          ),
        ),
      );
    }

    // Show error state
    if (_doctorService.error != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading doctors',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _doctorService.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _doctorService.loadDoctors();
                  setState(() {});
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

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
                                  Icons.visibility,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    _showDoctorViewDialog(context, doctor),
                              ),
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
                                onPressed: () => _showAsyncDeleteConfirmation(
                                  context,
                                  'doctor',
                                  doctor.name,
                                  () async {
                                    await _doctorService.deleteDoctor(doctor);
                                    await _refreshCurrentSection();
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
                                  Icons.visibility,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    _showStockistViewDialog(context, stockist),
                              ),
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
                                onPressed: () => _showAsyncDeleteConfirmation(
                                  context,
                                  'stockist',
                                  stockist.name,
                                  () async {
                                    await _stockistService.deleteStockist(
                                      stockist,
                                    );
                                    await _refreshCurrentSection();
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

  void _showAsyncDeleteConfirmation(
    BuildContext context,
    String itemType,
    String itemName,
    Future<void> Function() onConfirm,
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
            onPressed: () async {
              Navigator.pop(context);
              try {
                await onConfirm();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$itemName deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete $itemName: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // View Dialog Methods
  void _showMRViewDialog(BuildContext context, mr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.person_outline, color: Colors.purple),
            const SizedBox(width: 8),
            const Text('MR Details'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Name', mr.name),
                _buildDetailRow('Age', '${mr.age} years'),
                _buildDetailRow('Sex', mr.sex),
                _buildDetailRow('Phone', mr.phoneNo),
                _buildDetailRow('Address', mr.address),
                _buildDetailRow('Headquarters', mr.headquarters.join(', ')),
                _buildDetailRow('Areas', mr.areaNames.join(', ')),
                const Divider(),
                const Text(
                  'Banking Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Account Number', mr.accountNumber),
                _buildDetailRow('Bank Name', mr.bankName),
                _buildDetailRow('IFSC Code', mr.ifscCode),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMedicalViewDialog(BuildContext context, medical) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.local_hospital, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Medical Facility Details'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Name', medical.name),
                _buildDetailRow('Headquarters', medical.headquarter),
                _buildDetailRow('Area', medical.area),
                _buildDetailRow('Contact Person', medical.contactPerson),
                _buildDetailRow('Phone', medical.phoneNo),
                _buildDetailRow('Address', medical.address),
                _buildDetailRow('Attached Doctor', medical.attachedDoctor),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDoctorViewDialog(BuildContext context, doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.teal),
            const SizedBox(width: 8),
            const Text('Doctor Details'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Name', 'Dr. ${doctor.name}'),
                _buildDetailRow('Specialty', doctor.specialty),
                _buildDetailRow('Headquarters', doctor.headquarter),
                _buildDetailRow('Area', doctor.area),
                _buildDetailRow('Phone', doctor.phoneNo),
                if (doctor.dateOfBirth != null)
                  _buildDetailRow('Date of Birth', '${doctor.dateOfBirth}'),
                if (doctor.marriageAnniversary != null)
                  _buildDetailRow(
                    'Marriage Anniversary',
                    '${doctor.marriageAnniversary}',
                  ),
                if (doctor.callDays.isNotEmpty)
                  _buildDetailRow('Call Days', doctor.callDays.join(', ')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStockistViewDialog(BuildContext context, stockist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.business, color: Colors.indigo),
            const SizedBox(width: 8),
            const Text('Stockist Details'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Name', stockist.name),
                _buildDetailRow('Company', stockist.company),
                _buildDetailRow('Headquarters', stockist.headquarter),
                _buildDetailRow('Area', stockist.area),
                _buildDetailRow('Contact', stockist.contact),
                _buildDetailRow('Address', stockist.address),
                if (stockist.licenseNumber.isNotEmpty)
                  _buildDetailRow('License Number', stockist.licenseNumber),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not provided',
              style: TextStyle(
                color: value.isNotEmpty ? null : Colors.grey,
                fontStyle: value.isNotEmpty ? null : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
