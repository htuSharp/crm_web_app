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

  @override
  void initState() {
    super.initState();
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
    return Expanded(
      child: Column(
        children: [
          // Card(
          //   margin: const EdgeInsets.all(8),
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Row(
          //       children: [
          //         const Icon(Icons.medical_services, color: Colors.blue),
          //         const SizedBox(width: 12),
          //         const Text(
          //           'Medical Specialties Management',
          //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //         ),
          //         const Spacer(),
          //         ElevatedButton.icon(
          //           onPressed: () => _specialtyService.showAddSpecialtyDialog(
          //             context,
          //             _refreshCurrentSection,
          //           ),
          //           icon: const Icon(Icons.add),
          //           label: const Text('Add Specialty'),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.medical_services, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    'Medical Specialties Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _specialtyService.showAddSpecialtyDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Specialty'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _specialtyService.specialtyList.isEmpty
                ? const Center(
                    child: Text(
                      'No specialties added yet.\nClick "Add Specialty" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _specialtyService.specialtyList.length,
                    itemBuilder: (context, index) {
                      final specialty = _specialtyService.specialtyList[index];
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
                    'Headquarters Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _headquartersService.showAddHeadquartersDialog(
                          context,
                          _refreshCurrentSection,
                        ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Headquarters'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _headquartersService.headquartersList.isEmpty
                ? const Center(
                    child: Text(
                      'No headquarters added yet.\nClick "Add Headquarters" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _headquartersService.headquartersList.length,
                    itemBuilder: (context, index) {
                      final headquarters =
                          _headquartersService.headquartersList[index];
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
                    'Area Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _areaService.showAddAreaDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Area'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _areaService.areas.isEmpty
                ? const Center(
                    child: Text(
                      'No areas added yet.\nClick "Add Area" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _areaService.areas.length,
                    itemBuilder: (context, index) {
                      final area = _areaService.areas[index];
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
                    'Medical Representative Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _mrService.showAddMRDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add MR'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _mrService.mrList.isEmpty
                ? const Center(
                    child: Text(
                      'No medical representatives added yet.\nClick "Add MR" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _mrService.mrList.length,
                    itemBuilder: (context, index) {
                      final mr = _mrService.mrList[index];
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
                    'Medical Facility Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _medicalService.showAddMedicalDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Medical'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _medicalService.medicalsList.isEmpty
                ? const Center(
                    child: Text(
                      'No medical facilities added yet.\nClick "Add Medical" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _medicalService.medicalsList.length,
                    itemBuilder: (context, index) {
                      final medical = _medicalService.medicalsList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.local_hospital),
                          title: Text(medical.name),
                          subtitle: Text(
                            '${medical.type} • ${medical.contact}',
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
                    'Doctor Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _doctorService.showAddDoctorDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Doctor'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _doctorService.doctorsList.isEmpty
                ? const Center(
                    child: Text(
                      'No doctors added yet.\nClick "Add Doctor" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _doctorService.doctorsList.length,
                    itemBuilder: (context, index) {
                      final doctor = _doctorService.doctorsList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text('Dr. ${doctor.name}'),
                          subtitle: Text(
                            '${doctor.qualification} • ${doctor.specialty}',
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
                    'Stockist Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _stockistService.showAddStockistDialog(
                      context,
                      _refreshCurrentSection,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Stockist'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _stockistService.stockistList.isEmpty
                ? const Center(
                    child: Text(
                      'No stockists added yet.\nClick "Add Stockist" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _stockistService.stockistList.length,
                    itemBuilder: (context, index) {
                      final stockist = _stockistService.stockistList[index];
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
