import 'package:uuid/uuid.dart';

class MedicalEntry {
  final String? id;
  final String name;
  final String headquarter;
  final String area;
  final String contactPerson;
  final String phoneNo;
  final String address;
  // making attachedDoctor optional
  final String? attachedDoctor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MedicalEntry({
    this.id,
    required this.name,
    required this.headquarter,
    required this.area,
    required this.contactPerson,
    required this.phoneNo,
    required this.address,
    // making attachedDoctor optional
    this.attachedDoctor,
    this.createdAt,
    this.updatedAt,
  });

  // Generate a new MedicalEntry with an ID for database insertion
  MedicalEntry withGeneratedId() {
    return MedicalEntry(
      id: const Uuid().v4(),
      name: name,
      headquarter: headquarter,
      area: area,
      contactPerson: contactPerson,
      phoneNo: phoneNo,
      address: address,
      attachedDoctor: attachedDoctor,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MedicalEntry copyWith({
    String? id,
    String? name,
    String? headquarter,
    String? area,
    String? contactPerson,
    String? phoneNo,
    String? address,
    // making attachedDoctor optional
    String? attachedDoctor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      headquarter: headquarter ?? this.headquarter,
      area: area ?? this.area,
      contactPerson: contactPerson ?? this.contactPerson,
      phoneNo: phoneNo ?? this.phoneNo,
      address: address ?? this.address,
      attachedDoctor: attachedDoctor ?? this.attachedDoctor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // JSON serialization for database operations
  Map<String, dynamic> toSupabaseJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'headquarter': headquarter,
      'area': area,
      'contact_person': contactPerson,
      'phone_no': phoneNo,
      'address': address,
      'attached_doctor': attachedDoctor,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // JSON serialization for UI operations (backwards compatibility)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'headquarter': headquarter,
      'area': area,
      'contactPerson': contactPerson,
      'phoneNo': phoneNo,
      'address': address,
      'attachedDoctor': attachedDoctor,
    };
  }

  factory MedicalEntry.fromJson(Map<String, dynamic> json) {
    return MedicalEntry(
      id: json['id'],
      name: json['name'] ?? '',
      headquarter: json['headquarter'] ?? '',
      area: json['area'] ?? '',
      contactPerson: json['contactPerson'] ?? json['contact_person'] ?? '',
      phoneNo: json['phoneNo'] ?? json['phone_no'] ?? '',
      address: json['address'] ?? '',
      attachedDoctor: json['attachedDoctor'] ?? json['attached_doctor'] ?? '',
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
    return other is MedicalEntry &&
        other.id == id &&
        other.name == name &&
        other.headquarter == headquarter &&
        other.area == area &&
        other.contactPerson == contactPerson &&
        other.phoneNo == phoneNo &&
        other.address == address &&
        other.attachedDoctor == attachedDoctor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        headquarter.hashCode ^
        area.hashCode ^
        contactPerson.hashCode ^
        phoneNo.hashCode ^
        address.hashCode ^
        attachedDoctor.hashCode;
  }

  @override
  String toString() =>
      'MedicalEntry(id: $id, name: $name, headquarter: $headquarter, area: $area, contactPerson: $contactPerson, phoneNo: $phoneNo, address: $address, attachedDoctor: $attachedDoctor)';
}
