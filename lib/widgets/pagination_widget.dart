import 'package:flutter/material.dart';
import '../constants/data_management_constants.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalEntries;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalEntries,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalEntries / DataManagementConstants.entriesPerPage)
        .ceil()
        .clamp(1, 9999);
    List<Widget> pageButtons = [];

    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);

    if (endPage - startPage < 4) {
      if (startPage == 1) {
        endPage = (startPage + 4).clamp(1, totalPages);
      } else if (endPage == totalPages) {
        startPage = (endPage - 4).clamp(1, totalPages);
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(32, 28),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              side: BorderSide(
                color: i == currentPage
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              backgroundColor: i == currentPage
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
                  : null,
            ),
            onPressed: () => onPageChanged(i),
            child: Text(
              '$i',
              style: TextStyle(
                fontSize: 12,
                fontWeight: i == currentPage
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: i == currentPage
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'First Page',
          icon: const Icon(Icons.first_page, size: 18),
          onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
        ),
        IconButton(
          tooltip: 'Previous Page',
          icon: const Icon(Icons.chevron_left, size: 18),
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        ...pageButtons,
        IconButton(
          tooltip: 'Next Page',
          icon: const Icon(Icons.chevron_right, size: 18),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
        IconButton(
          tooltip: 'Last Page',
          icon: const Icon(Icons.last_page, size: 18),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(totalPages)
              : null,
        ),
      ],
    );
  }
}
