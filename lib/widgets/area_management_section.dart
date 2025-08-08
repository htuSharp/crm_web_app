import 'dart:async';
import 'package:flutter/material.dart';
import '../models/area_entry.dart';
import '../constants/data_management_constants.dart';
import '../widgets/pagination_widget.dart';

class AreaManagementSection extends StatefulWidget {
  final List<AreaEntry> areas;
  final Function(AreaEntry) onAdd;
  final Function(AreaEntry, AreaEntry) onEdit;
  final Function(AreaEntry) onDelete;
  final String? recentlyAdded;

  const AreaManagementSection({
    super.key,
    required this.areas,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.recentlyAdded,
  });

  @override
  State<AreaManagementSection> createState() => _AreaManagementSectionState();
}

class _AreaManagementSectionState extends State<AreaManagementSection> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  String _searchQuery = '';
  String _selectedHQFilter = 'All';
  String _sortBy = 'area'; // 'area', 'headquarter', 'recent'
  bool _isGridView = false;
  int _currentPage = 1;
  Timer? _debounce;
  String? _editingItemId;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _showAddAreaDialog() {
    final TextEditingController areaController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? selectedHQ = DataManagementConstants.headquarters.isNotEmpty
        ? DataManagementConstants.headquarters.first
        : null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add_location_alt, color: Colors.blue, size: 24),
            SizedBox(width: 8),
            Text(
              'Add New Area',
              style: DataManagementStyles.titleStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Headquarters',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedHQ,
                items: DataManagementConstants.headquarters
                    .map(
                      (hq) => DropdownMenuItem(
                        value: hq,
                        child: Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8),
                            Text(hq),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => selectedHQ = val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) =>
                    value == null ? 'Please select a headquarters' : null,
              ),
              SizedBox(height: 16),
              Text(
                'Area Name',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: areaController,
                autofocus: true,
                style: DataManagementStyles.inputStyle,
                decoration: InputDecoration(
                  hintText: 'Enter area name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey[50],
                  prefixIcon: Icon(Icons.location_on, size: 20),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an area name';
                  }
                  if (value.trim().length < 2) {
                    return 'Area name must be at least 2 characters';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  if (formKey.currentState!.validate() && selectedHQ != null) {
                    Navigator.pop(context);
                    widget.onAdd(
                      AreaEntry(area: value.trim(), headquarter: selectedHQ!),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate() && selectedHQ != null) {
                Navigator.pop(context);
                widget.onAdd(
                  AreaEntry(
                    area: areaController.text.trim(),
                    headquarter: selectedHQ!,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Add Area'),
          ),
        ],
      ),
    );
  }

  void _showEditAreaDialog(AreaEntry entry) {
    final TextEditingController areaController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    areaController.text = entry.area;
    String? selectedHQ = entry.headquarter;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.edit_location_alt, color: Colors.orange, size: 24),
            SizedBox(width: 8),
            Text(
              'Edit Area',
              style: DataManagementStyles.titleStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Editing: ${entry.area} (${entry.headquarter})',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Headquarters',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedHQ,
                items: DataManagementConstants.headquarters
                    .map(
                      (hq) => DropdownMenuItem(
                        value: hq,
                        child: Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8),
                            Text(hq),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => selectedHQ = val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) =>
                    value == null ? 'Please select a headquarters' : null,
              ),
              SizedBox(height: 16),
              Text(
                'Area Name',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: areaController,
                autofocus: true,
                style: DataManagementStyles.inputStyle,
                decoration: InputDecoration(
                  hintText: 'Enter area name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey[50],
                  prefixIcon: Icon(Icons.location_on, size: 20),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an area name';
                  }
                  if (value.trim().length < 2) {
                    return 'Area name must be at least 2 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate() && selectedHQ != null) {
                final newEntry = AreaEntry(
                  area: areaController.text.trim(),
                  headquarter: selectedHQ!,
                );
                widget.onEdit(entry, newEntry);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(AreaEntry entry) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text(
              'Confirm Delete',
              style: DataManagementStyles.titleStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red[700],
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'You are about to delete:',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Area: ${entry.area}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Headquarters: ${entry.headquarter}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This action cannot be undone. Are you sure you want to continue?',
              style: DataManagementStyles.contentStyle.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete(entry);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, size: 18),
                SizedBox(width: 4),
                Text('Delete'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get available headquarters for filtering
    final availableHQs = ['All'] + DataManagementConstants.headquarters;

    // Filter and sort areas
    List<AreaEntry> filteredList = widget.areas.where((entry) {
      final matchesSearch =
          entry.area.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.headquarter.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesHQ =
          _selectedHQFilter == 'All' || entry.headquarter == _selectedHQFilter;
      return matchesSearch && matchesHQ;
    }).toList();

    // Sort areas
    switch (_sortBy) {
      case 'headquarter':
        filteredList.sort((a, b) => a.headquarter.compareTo(b.headquarter));
        break;
      case 'recent':
        // Sort by recently added (assuming newer entries are at the end)
        filteredList = filteredList.reversed.toList();
        break;
      case 'area':
      default:
        filteredList.sort((a, b) => a.area.compareTo(b.area));
        break;
    }

    final totalEntries = filteredList.length;
    final start = (_currentPage - 1) * DataManagementConstants.entriesPerPage;
    final end = (start + DataManagementConstants.entriesPerPage).clamp(
      0,
      totalEntries,
    );
    final pageList = filteredList.sublist(start, end);

    // Group areas by headquarters for better organization
    final groupedAreas = <String, List<AreaEntry>>{};
    for (final area in pageList) {
      groupedAreas.putIfAbsent(area.headquarter, () => []).add(area);
    }

    return Expanded(
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: DataManagementStyles.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.location_city, color: Colors.blue, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Area Management',
                          style: DataManagementStyles.titleStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${totalEntries} area${totalEntries != 1 ? 's' : ''} total',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.add, size: 18),
                    label: Text('Add Area'),
                    onPressed: _showAddAreaDialog,
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Search and Filter Controls
              Row(
                children: [
                  // Search
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _searchController,
                      style: DataManagementStyles.inputStyle,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        hintText: 'Search areas or headquarters...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
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
                  SizedBox(width: 12),

                  // Headquarters Filter
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedHQFilter,
                      decoration: InputDecoration(
                        labelText: 'Filter by HQ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.grey[50],
                        prefixIcon: Icon(Icons.filter_list, size: 20),
                      ),
                      items: availableHQs
                          .map(
                            (hq) =>
                                DropdownMenuItem(value: hq, child: Text(hq)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedHQFilter = value!;
                          _currentPage = 1;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),

                  // Sort Options
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _sortBy,
                      decoration: InputDecoration(
                        labelText: 'Sort by',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.grey[50],
                        prefixIcon: Icon(Icons.sort, size: 20),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'area',
                          child: Text('Area Name'),
                        ),
                        DropdownMenuItem(
                          value: 'headquarter',
                          child: Text('Headquarters'),
                        ),
                        DropdownMenuItem(
                          value: 'recent',
                          child: Text('Recently Added'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),

                  // View Toggle
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.view_list,
                            color: !_isGridView
                                ? Colors.blue
                                : Colors.grey[600],
                          ),
                          onPressed: () => setState(() => _isGridView = false),
                          tooltip: 'List View',
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.grid_view,
                            color: _isGridView ? Colors.blue : Colors.grey[600],
                          ),
                          onPressed: () => setState(() => _isGridView = true),
                          tooltip: 'Grid View',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Content Area
              Expanded(
                child: pageList.isEmpty
                    ? _buildEmptyState()
                    : _isGridView
                    ? _buildGridView(pageList)
                    : _buildListView(groupedAreas),
              ),

              // Pagination
              if (totalEntries > DataManagementConstants.entriesPerPage)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No areas found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedHQFilter != 'All'
                ? 'Try adjusting your search or filter criteria'
                : 'Get started by adding your first area',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          if (_searchQuery.isEmpty && _selectedHQFilter == 'All')
            ElevatedButton.icon(
              onPressed: _showAddAreaDialog,
              icon: Icon(Icons.add),
              label: Text('Add First Area'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<AreaEntry> areas) {
    return GridView.builder(
      controller: _listScrollController,
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: areas.length,
      itemBuilder: (context, index) {
        final entry = areas[index];
        final isNew = entry.area == widget.recentlyAdded;

        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: isNew ? Colors.yellow[50] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isNew ? Colors.yellow[300]! : Colors.grey[300]!,
              width: isNew ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showEditAreaDialog(entry),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                      ),
                      Spacer(),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, size: 18),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditAreaDialog(entry);
                          } else if (value == 'delete') {
                            _showDeleteDialog(entry);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 16, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.area,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                entry.headquarter,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(Map<String, List<AreaEntry>> groupedAreas) {
    return ListView.builder(
      controller: _listScrollController,
      padding: EdgeInsets.all(8),
      itemCount: groupedAreas.keys.length,
      itemBuilder: (context, index) {
        final headquarter = groupedAreas.keys.elementAt(index);
        final areas = groupedAreas[headquarter]!;

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headquarters Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.business, color: Colors.blue[700], size: 20),
                    SizedBox(width: 8),
                    Text(
                      headquarter,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.blue[700],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${areas.length} area${areas.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Areas List
              ...areas.map((entry) {
                final isNew = entry.area == widget.recentlyAdded;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: isNew ? Colors.yellow[50] : null,
                    border: isNew
                        ? Border.all(color: Colors.yellow[300]!, width: 1)
                        : null,
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      entry.area,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                          tooltip: 'Edit Area',
                          onPressed: () => _showEditAreaDialog(entry),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 20),
                          tooltip: 'Delete Area',
                          onPressed: () => _showDeleteDialog(entry),
                        ),
                      ],
                    ),
                    onTap: () => _showEditAreaDialog(entry),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
