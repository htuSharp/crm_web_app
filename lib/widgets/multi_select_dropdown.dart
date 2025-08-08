import 'package:flutter/material.dart';

class MultiSelectDropdown<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final Function(List<T>) onSelectionChanged;
  final String Function(T) displayText;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final String? Function(List<T>?)? validator;

  const MultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    required this.displayText,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.validator,
  }) : super(key: key);

  @override
  State<MultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: widget.selectedItems,
      validator: widget.validator,
      builder: (FormFieldState<List<T>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _showMultiSelectDialog(context, state),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: state.hasError ? Colors.red : Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      Icon(widget.prefixIcon, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: widget.selectedItems.isEmpty
                          ? Text(
                              widget.hintText,
                              style: TextStyle(color: Colors.grey[600]),
                            )
                          : Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: widget.selectedItems
                                  .map(
                                    (item) => Chip(
                                      label: Text(
                                        widget.displayText(item),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      deleteIcon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      onDeleted: () {
                                        final newSelection = List<T>.from(
                                          widget.selectedItems,
                                        );
                                        newSelection.remove(item);
                                        widget.onSelectionChanged(newSelection);
                                        state.didChange(newSelection);
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            // Label text
            if (widget.selectedItems.isNotEmpty || state.hasError)
              Positioned(
                left: 12,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    widget.labelText,
                    style: TextStyle(
                      fontSize: 12,
                      color: state.hasError ? Colors.red : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showMultiSelectDialog(
    BuildContext context,
    FormFieldState<List<T>> state,
  ) {
    List<T> tempSelected = List.from(widget.selectedItems);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select ${widget.labelText}'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = tempSelected.contains(item);
                return CheckboxListTile(
                  title: Text(widget.displayText(item)),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        tempSelected.add(item);
                      } else {
                        tempSelected.remove(item);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                tempSelected.clear();
                setState(() {});
              },
              child: const Text('Clear All'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onSelectionChanged(tempSelected);
                state.didChange(tempSelected);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
