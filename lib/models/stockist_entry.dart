import 'package:uuid/uuid.dart';

class StockistEntry {
  final String? id;
  final String name;
  final String company;
  final String contact;
  final String address;
  final String headquarter;
  final String gstNumber; // Added GST number field
  final String license20B; // 20B license number
  final String license21B; // 21B license number
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StockistEntry({
    this.id,
    required this.name,
    required this.company,
    required this.contact,
    required this.address,
    required this.headquarter,
    required this.gstNumber,
    required this.license20B,
    required this.license21B,
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
      headquarter: headquarter,
      gstNumber: gstNumber,
      license20B: license20B,
      license21B: license21B,
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
    String? headquarter,
    String? gstNumber,
    String? license20B,
    String? license21B,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockistEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      headquarter: headquarter ?? this.headquarter,
      gstNumber: gstNumber ?? this.gstNumber,
      license20B: license20B ?? this.license20B,
      license21B: license21B ?? this.license21B,
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
      'headquarter': headquarter,
      'gst_number': gstNumber,
      'license_20b': license20B,
      'license_21b': license21B,
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
      'headquarter': headquarter,
      'gstNumber': gstNumber,
      'license20B': license20B,
      'license21B': license21B,
    };
  }

  factory StockistEntry.fromJson(Map<String, dynamic> json) {
    return StockistEntry(
      id: json['id'],
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      headquarter: json['headquarter'] ?? '',
      gstNumber: json['gstNumber'] ?? json['gst_number'] ?? '',
      license20B: json['license20B'] ?? json['license_20b'] ?? '',
      license21B: json['license21B'] ?? json['license_21b'] ?? '',
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
        other.headquarter == headquarter &&
        other.gstNumber == gstNumber &&
        other.license20B == license20B &&
        other.license21B == license21B;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        company.hashCode ^
        contact.hashCode ^
        address.hashCode ^
        headquarter.hashCode ^
        gstNumber.hashCode ^
        license20B.hashCode ^
        license21B.hashCode;
  }

  @override
  String toString() =>
      'StockistEntry(id: $id, name: $name, company: $company, contact: $contact, address: $address, headquarter: $headquarter, gstNumber: $gstNumber, license20B: $license20B, license21B: $license21B)';
}
