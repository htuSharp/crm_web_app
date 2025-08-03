import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/data_management_constants.dart';
import '../widgets/pagination_widget.dart';
import '../widgets/error_animation_widget.dart';

class BasicListManagementSection extends StatefulWidget {
  final List<String> items;
  final String label;
  final Function(String) onAdd;
  final Function(int, String) onEdit;
  final Function(int) onDelete;
  final String? recentlyAdded;
  final String? errorMessage;
  final AnimationController? errorAnimController;

  const BasicListManagementSection({
    super.key,
    required this.items,
    required this.label,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.recentlyAdded,
    this.errorMessage,
    this.errorAnimController,
  });

  @override
  State<BasicListManagementSection> createState() =>
      _BasicListManagementSectionState();
}

class _BasicListManagementSectionState
    extends State<BasicListManagementSection> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  String _searchQuery = '';
  int _currentPage = 1;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _searchController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _showEditDialog(int index) {
    _controller.text = widget.items[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Edit ${widget.label}',
          style: DataManagementStyles.titleStyle,
        ),
        content: TextField(
          controller: _controller,
          autofocus: true,
          style: DataManagementStyles.inputStyle,
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
              final newValue = _controller.text.trim();
              if (newValue.isNotEmpty) {
                widget.onEdit(index, newValue);
              }
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Save', style: DataManagementStyles.buttonStyle),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Confirm Delete',
          style: DataManagementStyles.titleStyle,
        ),
        content: const Text(
          'Are you sure you want to delete this item?',
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
              widget.onDelete(index);
              Navigator.pop(context);
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
    final filteredList = widget.items
        .where(
          (item) => item.toLowerCase().contains(_searchQuery.toLowerCase()),
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
              Text(
                '${widget.label} Management',
                style: DataManagementStyles.titleStyle,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: DataManagementStyles.inputStyle,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          size: DataManagementStyles.iconSize,
                        ),
                        hintText: 'Search ${widget.label}...',
                        border: const OutlineInputBorder(),
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
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: DataManagementStyles.inputStyle,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.add,
                          size: DataManagementStyles.iconSize,
                        ),
                        hintText: 'Add new ${widget.label}',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: DataManagementStyles.inputPadding,
                      ),
                      onSubmitted: (value) {
                        widget.onAdd(value);
                        _controller.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: DataManagementStyles.buttonPadding,
                      textStyle: DataManagementStyles.buttonStyle,
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add'),
                    onPressed: () {
                      widget.onAdd(_controller.text);
                      _controller.clear();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (widget.errorAnimController != null)
                ErrorAnimationWidget(
                  animationController: widget.errorAnimController!,
                  errorMessage: widget.errorMessage,
                ),
              Expanded(
                child: pageList.isEmpty
                    ? const Center(
                        child: Text(
                          'No items found.',
                          style: DataManagementStyles.hintStyle,
                        ),
                      )
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: ListView.separated(
                          controller: _listScrollController,
                          key: ValueKey(
                            '${widget.label}-$_searchQuery-$_currentPage',
                          ),
                          itemCount: pageList.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, color: Colors.grey),
                          itemBuilder: (context, idx) {
                            int index = widget.items.indexOf(pageList[idx]);
                            String value = pageList[idx];
                            final isNew = value == widget.recentlyAdded;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: isNew ? Colors.yellow[100] : null,
                                borderRadius:
                                    DataManagementStyles.defaultBorderRadius,
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                ),
                                title: Text(
                                  value,
                                  style: DataManagementStyles.contentStyle,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: DataManagementStyles.iconSize,
                                      ),
                                      tooltip: 'Edit',
                                      onPressed: () => _showEditDialog(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: DataManagementStyles.iconSize,
                                      ),
                                      tooltip: 'Delete',
                                      onPressed: () => _showDeleteDialog(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
