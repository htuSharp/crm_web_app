import 'package:flutter/material.dart';

typedef AddItemCallback = void Function(String value);
typedef EditItemCallback = void Function(int index, String value);
typedef DeleteItemCallback = void Function(int index);

class SectionListWidget extends StatelessWidget {
  final String label;
  final List<String> items;
  final TextEditingController addController;
  final TextEditingController searchController;
  final String searchQuery;
  final int currentPage;
  final int entriesPerPage;
  final Function(String) onSearchChanged;
  final AddItemCallback onAdd;
  final EditItemCallback onEdit;
  final DeleteItemCallback onDelete;
  final ScrollController listScrollController;
  final String? recentlyAdded;

  const SectionListWidget({
    super.key,
    required this.label,
    required this.items,
    required this.addController,
    required this.searchController,
    required this.searchQuery,
    required this.currentPage,
    required this.entriesPerPage,
    required this.onSearchChanged,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.listScrollController,
    this.recentlyAdded,
  });

  @override
  Widget build(BuildContext context) {
    final filteredList = items
        .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    final totalEntries = filteredList.length;
    final start = (currentPage - 1) * entriesPerPage;
    final end = (start + entriesPerPage).clamp(0, totalEntries);
    final pageList = filteredList.sublist(start, end);

    return Expanded(
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label Management',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 18),
                        hintText: 'Search $label...',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                      ),
                      onChanged: onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: addController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.add, size: 18),
                        hintText: 'Add new $label',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                      ),
                      onSubmitted: onAdd,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add'),
                    onPressed: () => onAdd(addController.text),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: pageList.isEmpty
                    ? const Center(
                        child: Text(
                          'No items found.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      )
                    : ListView.separated(
                        controller: listScrollController,
                        itemCount: pageList.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Colors.grey),
                        itemBuilder: (context, idx) {
                          final value = pageList[idx];
                          final isNew = value == recentlyAdded;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: isNew ? Colors.yellow[100] : null,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 0,
                              ),
                              title: Text(
                                value,
                                style: const TextStyle(fontSize: 13),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                    tooltip: 'Edit',
                                    onPressed: () => onEdit(idx, value),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    tooltip: 'Delete',
                                    onPressed: () => onDelete(idx),
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
        ),
      ),
    );
  }
}
