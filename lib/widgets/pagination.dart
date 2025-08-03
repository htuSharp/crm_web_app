// import 'package:flutter/material.dart';

// class PaginationWidget extends StatefulWidget {
//   final int totalEntries;
//   final Function(int) onPageChanged;

//   const PaginationWidget({
//     Key? key,
//     required this.totalEntries,
//     required this.onPageChanged,
//   }) : super(key: key);

//   @override
//   State<PaginationWidget> createState() => _PaginationWidgetState();
// }

// class _PaginationWidgetState extends State<PaginationWidget> {
//   int _currentPage = 1;
//   static const int _entriesPerPage = 20;

//   Widget _buildPagination(int totalEntries) {
//   final totalPages = (totalEntries / _entriesPerPage).ceil().clamp(1, 9999);
//   List<Widget> pageButtons = [];

//   int startPage = (_currentPage - 2).clamp(1, totalPages);
//   int endPage = (_currentPage + 2).clamp(1, totalPages);

//   if (endPage - startPage < 4) {
//     if (startPage == 1) {
//       endPage = (startPage + 4).clamp(1, totalPages);
//     } else if (endPage == totalPages) {
//       startPage = (endPage - 4).clamp(1, totalPages);
//     }
//   }

//   for (int i = startPage; i <= endPage; i++) {
//     pageButtons.add(
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1),
//         child: OutlinedButton(
//           style: OutlinedButton.styleFrom(
//             minimumSize: const Size(32, 28),
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             side: BorderSide(
//               color: i == _currentPage
//                   ? Theme.of(context).colorScheme.primary
//                   : Colors.grey,
//             ),
//             backgroundColor: i == _currentPage
//                 ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
//                 : null,
//           ),
//           onPressed: () {
//             setState(() {
//               _currentPage = i;
//             });
//           },
//           child: Text(
//             '$i',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: i == _currentPage
//                   ? FontWeight.bold
//                   : FontWeight.normal,
//               color: i == _currentPage
//                   ? Theme.of(context).colorScheme.primary
//                   : Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       IconButton(
//         tooltip: 'First Page',
//         icon: const Icon(Icons.first_page, size: 18),
//         onPressed: _currentPage > 1
//             ? () => setState(() => _currentPage = 1)
//             : null,
//       ),
//       IconButton(
//         tooltip: 'Previous Page',
//         icon: const Icon(Icons.chevron_left, size: 18),
//         onPressed: _currentPage > 1
//             ? () => setState(() => _currentPage--)
//             : null,
//       ),
//       ...pageButtons,
//       IconButton(
//         tooltip: 'Next Page',
//         icon: const Icon(Icons.chevron_right, size: 18),
//         onPressed: _currentPage < totalPages
//             ? () => setState(() => _currentPage++)
//             : null,
//       ),
//       IconButton(
//         tooltip: 'Last Page',
//         icon: const Icon(Icons.last_page, size: 18),
//         onPressed: _currentPage < totalPages
//             ? () => setState(() => _currentPage = totalPages)
//             : null,
//       ),
//     ],
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }

// }

// // int _currentPage = 1;
// // static const int _entriesPerPage = 20;
