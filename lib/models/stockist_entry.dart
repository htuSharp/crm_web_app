import 'package:uuid/uuid.dart';

class StockistEntry {
  final String? id;
  final String name;
  final String company;
  final String contact;
  final String address;
  final String area;
  final String licenseNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StockistEntry({
    this.id,
    required this.name,
    required this.company,
    required this.contact,
    required this.address,
    required this.area,
    required this.licenseNumber,
    this.createdAt,
    this.updatedAt,
  });

  // Generate a new StockistEntry with an ID for database insertion
  StockistEntry withGeneratedId() {
    return StockistEntry(
      id: const Uuid().v4(),
      name: name,
      company: company,
      contact: contact,
      address: address,
      area: area,
      licenseNumber: licenseNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  StockistEntry copyWith({
    String? id,
    String? name,
    String? company,
    String? contact,
    String? address,
    String? area,
    String? licenseNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockistEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      area: area ?? this.area,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // JSON serialization for database operations
  Map<String, dynamic> toSupabaseJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'company': company,
      'contact': contact,
      'address': address,
      'area': area,
      'license_number': licenseNumber,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // JSON serialization for UI operations (backwards compatibility)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company': company,
      'contact': contact,
      'address': address,
      'area': area,
      'licenseNumber': licenseNumber,
    };
  }

  factory StockistEntry.fromJson(Map<String, dynamic> json) {
    return StockistEntry(
      id: json['id'],
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      area: json['area'] ?? '',
      licenseNumber: json['licenseNumber'] ?? json['license_number'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StockistEntry &&
        other.id == id &&
        other.name == name &&
        other.company == company &&
        other.contact == contact &&
        other.address == address &&
        other.area == area &&
        other.licenseNumber == licenseNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        company.hashCode ^
        contact.hashCode ^
        address.hashCode ^
        area.hashCode ^
        licenseNumber.hashCode;
  }

  @override
  String toString() =>
      'StockistEntry(id: $id, name: $name, company: $company, contact: $contact, address: $address, area: $area, licenseNumber: $licenseNumber)';
}
