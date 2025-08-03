class DoctorEntry {
  final String name;
  final String specialty;
  final String qualification;
  final String hospital;
  final String contact;
  final String address;
  final String area;

  DoctorEntry({
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.hospital,
    required this.contact,
    required this.address,
    required this.area,
  });

  DoctorEntry copyWith({
    String? name,
    String? specialty,
    String? qualification,
    String? hospital,
    String? contact,
    String? address,
    String? area,
  }) {
    return DoctorEntry(
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      qualification: qualification ?? this.qualification,
      hospital: hospital ?? this.hospital,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      area: area ?? this.area,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialty': specialty,
      'qualification': qualification,
      'hospital': hospital,
      'contact': contact,
      'address': address,
      'area': area,
    };
  }

  factory DoctorEntry.fromJson(Map<String, dynamic> json) {
    return DoctorEntry(
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      qualification: json['qualification'] ?? '',
      hospital: json['hospital'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      area: json['area'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorEntry &&
        other.name == name &&
        other.specialty == specialty &&
        other.qualification == qualification &&
        other.hospital == hospital &&
        other.contact == contact &&
        other.address == address &&
        other.area == area;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        specialty.hashCode ^
        qualification.hashCode ^
        hospital.hashCode ^
        contact.hashCode ^
        address.hashCode ^
        area.hashCode;
  }

  @override
  String toString() =>
      'DoctorEntry(name: $name, specialty: $specialty, qualification: $qualification, hospital: $hospital, contact: $contact, address: $address, area: $area)';
}
