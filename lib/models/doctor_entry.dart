import 'package:uuid/uuid.dart';

class DoctorEntry {
  final String id;
  final String name;
  final String specialty;
  final String area;
  final String headquarter; // Added headquarter field
  final DateTime? dateOfBirth;
  final String? phoneNo; // Made optional
  final String callTime; // Added call time field (Morning/Evening/Both)
  final DateTime? marriageAnniversary;
  final List<String> callDays;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorEntry({
    String? id,
    required this.name,
    required this.specialty,
    required this.area,
    required this.headquarter,
    this.dateOfBirth,
    this.phoneNo, // Made optional
    required this.callTime, // Added call time field
    this.marriageAnniversary,
    required this.callDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  DoctorEntry copyWith({
    String? id,
    String? name,
    String? specialty,
    String? area,
    String? headquarter,
    DateTime? dateOfBirth,
    String? phoneNo,
    String? callTime, // Added call time field
    DateTime? marriageAnniversary,
    List<String>? callDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      area: area ?? this.area,
      headquarter: headquarter ?? this.headquarter,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNo: phoneNo ?? this.phoneNo,
      callTime: callTime ?? this.callTime, // Added call time field
      marriageAnniversary: marriageAnniversary ?? this.marriageAnniversary,
      callDays: callDays ?? this.callDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'area': area,
      'headquarter': headquarter,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'phone_no': phoneNo,
      'call_time': callTime, // Added call time field
      'marriage_anniversary': marriageAnniversary?.toIso8601String(),
      'call_days': callDays,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // For Supabase insert (excludes id if it should be auto-generated)
  Map<String, dynamic> toSupabaseJson() {
    final json = toJson();
    // Remove fields that Supabase handles automatically
    json.remove('created_at');
    json.remove('updated_at');
    return json;
  }

  factory DoctorEntry.fromJson(Map<String, dynamic> json) {
    return DoctorEntry(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      area: json['area'] ?? '',
      headquarter: json['headquarter'] ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      phoneNo: json['phone_no'],
      callTime:
          json['call_time'] ?? 'Morning', // Default to Morning if not specified
      marriageAnniversary: json['marriage_anniversary'] != null
          ? DateTime.parse(json['marriage_anniversary'])
          : null,
      callDays: List<String>.from(json['call_days'] ?? []),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorEntry &&
        other.id == id &&
        other.name == name &&
        other.specialty == specialty &&
        other.area == area &&
        other.dateOfBirth == dateOfBirth &&
        other.phoneNo == phoneNo &&
        other.marriageAnniversary == marriageAnniversary &&
        _listEquals(other.callDays, callDays);
  }

  // Helper method for list equality
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        specialty.hashCode ^
        area.hashCode ^
        dateOfBirth.hashCode ^
        phoneNo.hashCode ^
        marriageAnniversary.hashCode ^
        callDays.hashCode;
  }

  @override
  String toString() =>
      'DoctorEntry(id: $id, name: $name, specialty: $specialty, area: $area, headquarter: $headquarter, dateOfBirth: $dateOfBirth, phoneNo: $phoneNo, callTime: $callTime, marriageAnniversary: $marriageAnniversary, callDays: $callDays, createdAt: $createdAt, updatedAt: $updatedAt)';
}
