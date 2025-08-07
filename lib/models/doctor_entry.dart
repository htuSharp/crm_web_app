class DoctorEntry {
  final String name;
  final String specialty;
  final String area;
  final DateTime? dateOfBirth;
  final String phoneNo;
  final DateTime? marriageAnniversary;
  final List<String> callDays;

  DoctorEntry({
    required this.name,
    required this.specialty,
    required this.area,
    this.dateOfBirth,
    required this.phoneNo,
    this.marriageAnniversary,
    required this.callDays,
  });

  DoctorEntry copyWith({
    String? name,
    String? specialty,
    String? area,
    DateTime? dateOfBirth,
    String? phoneNo,
    DateTime? marriageAnniversary,
    List<String>? callDays,
  }) {
    return DoctorEntry(
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      area: area ?? this.area,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNo: phoneNo ?? this.phoneNo,
      marriageAnniversary: marriageAnniversary ?? this.marriageAnniversary,
      callDays: callDays ?? this.callDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialty': specialty,
      'area': area,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phoneNo': phoneNo,
      'marriageAnniversary': marriageAnniversary?.toIso8601String(),
      'callDays': callDays,
    };
  }

  factory DoctorEntry.fromJson(Map<String, dynamic> json) {
    return DoctorEntry(
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      area: json['area'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      phoneNo: json['phoneNo'] ?? '',
      marriageAnniversary: json['marriageAnniversary'] != null
          ? DateTime.parse(json['marriageAnniversary'])
          : null,
      callDays: List<String>.from(json['callDays'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorEntry &&
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
    return name.hashCode ^
        specialty.hashCode ^
        area.hashCode ^
        dateOfBirth.hashCode ^
        phoneNo.hashCode ^
        marriageAnniversary.hashCode ^
        callDays.hashCode;
  }

  @override
  String toString() =>
      'DoctorEntry(name: $name, specialty: $specialty, area: $area, dateOfBirth: $dateOfBirth, phoneNo: $phoneNo, marriageAnniversary: $marriageAnniversary, callDays: $callDays)';
}
