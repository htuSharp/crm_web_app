// lib/constants/section_data.dart
import 'package:flutter/material.dart';

class Section {
  final String title;
  final IconData icon;
  final String description;

  const Section({
    required this.title,
    required this.icon,
    required this.description,
  });
}

const List<Section> sections = [
  Section(
    title: 'Dashboard',
    icon: Icons.dashboard_outlined,
    description: 'Get an overview of key metrics and recent activities.',
  ),
  Section(
    title: 'Data Management',
    icon: Icons.storage,
    description: 'Manage customer, retailer, and product data efficiently.',
  ),
  Section(
    title: 'Inventory',
    icon: Icons.inventory,
    description: 'Track available stock, product batches, and movement.',
  ),
  Section(
    title: 'Stock Invoices',
    icon: Icons.receipt_long,
    description: 'Create and manage stock invoices for distribution.',
  ),
  Section(
    title: 'Retailer Bills',
    icon: Icons.point_of_sale,
    description: 'Generate and view billing records for retailers.',
  ),
  Section(
    title: 'MR Activity Planner',
    icon: Icons.event_note,
    description: 'Plan and track Medical Representative visits and schedules.',
  ),
  Section(
    title: 'Activity Log',
    icon: Icons.history,
    description: 'Monitor all activities for transparency and audits.',
  ),
];
