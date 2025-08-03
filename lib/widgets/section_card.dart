// lib/widgets/section_card.dart
import 'package:flutter/material.dart';
import '../constants/section_data.dart';

class SectionCard extends StatelessWidget {
  final Section section;

  const SectionCard(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              section.icon,
              size: 40,
              color: Colors.indigo,
            ),
            const SizedBox(height: 10),
            Text(
              section.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              section.description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
