import 'package:flutter/material.dart';

class DataManagementConstants {
  static const int entriesPerPage = 20;

  static const List<String> specialties = [
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Oncology',
    'Dermatology',
    'Orthopedics',
    'ENT',
    'Gastroenterology',
    'Nephrology',
    'Urology',
    'Pulmonology',
    'Rheumatology',
    'Endocrinology',
    'Hematology',
    'Immunology',
    'Ophthalmology',
    'Psychiatry',
    'Radiology',
    'Surgery',
    'Anesthesiology',
    'Pathology',
    'Genetics',
    'Geriatrics',
    'Obstetrics',
    'Gynecology',
  ];

  static const List<String> headquarters = [
    'Mumbai',
    'Delhi',
    'Chennai',
    'Kolkata',
    'Bangalore',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Bhopal',
    'Patna',
    'Ludhiana',
    'Agra',
    'Nashik',
    'Vadodara',
    'Faridabad',
    'Meerut',
    'Rajkot',
    'Varanasi',
    'Srinagar',
    'Aurangabad',
  ];

  static const List<String> categories = [
    'Specialties',
    'Headquarters',
    'Areas',
    'MR',
    'Medicals',
    'Doctors',
    'Stockist',
    'Manager',
  ];

  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration reverseAnimationDuration = Duration(milliseconds: 200);
  static const Duration scrollAnimationDuration = Duration(milliseconds: 400);
  static const Duration notificationDelay = Duration(seconds: 3);
  static const Duration highlightDelay = Duration(seconds: 2);
}

class DataManagementStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle inputStyle = TextStyle(fontSize: 13);

  static const TextStyle buttonStyle = TextStyle(fontSize: 13);

  static const TextStyle contentStyle = TextStyle(fontSize: 13);

  static const TextStyle errorStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  static const TextStyle hintStyle = TextStyle(
    color: Colors.grey,
    fontSize: 13,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(10);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 10,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 8,
  );
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 12,
  );

  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(6),
  );

  static const double iconSize = 18.0;
  static const double listItemHeight = 48.0;
}
