import 'package:flutter/material.dart';
import '../constants/data_management_constants.dart';

class CategoryTabsWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryTabsWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: List.generate(DataManagementConstants.categories.length, (
          index,
        ) {
          final category = DataManagementConstants.categories[index];
          final isSelected = selectedCategory == category;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[200],
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  textStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                onPressed: () => onCategoryChanged(category),
                child: Text(category, textAlign: TextAlign.center),
              ),
            ),
          );
        }),
      ),
    );
  }
}
