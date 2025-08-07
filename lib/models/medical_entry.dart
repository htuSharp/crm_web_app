class MedicalEntry {
  final String name;
  final String headquarter;
  final String area;
  final String contactPerson;
  final String phoneNo;
  final String address;
  final String attachedDoctor;

  MedicalEntry({
    required this.name,
    required this.headquarter,
    required this.area,
    required this.contactPerson,
    required this.phoneNo,
    required this.address,
    required this.attachedDoctor,
  });

  MedicalEntry copyWith({
    String? name,
    String? headquarter,
    String? area,
    String? contactPerson,
    String? phoneNo,
    String? address,
    String? attachedDoctor,
  }) {
    return MedicalEntry(
      name: name ?? this.name,
      headquarter: headquarter ?? this.headquarter,
      area: area ?? this.area,
      contactPerson: contactPerson ?? this.contactPerson,
      phoneNo: phoneNo ?? this.phoneNo,
      address: address ?? this.address,
      attachedDoctor: attachedDoctor ?? this.attachedDoctor,
    );
  }

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
      name: json['name'] ?? '',
      headquarter: json['headquarter'] ?? '',
      area: json['area'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      address: json['address'] ?? '',
      attachedDoctor: json['attachedDoctor'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicalEntry &&
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
    return name.hashCode ^
        headquarter.hashCode ^
        area.hashCode ^
        contactPerson.hashCode ^
        phoneNo.hashCode ^
        address.hashCode ^
        attachedDoctor.hashCode;
  }

  @override
  String toString() =>
      'MedicalEntry(name: $name, headquarter: $headquarter, area: $area, contactPerson: $contactPerson, phoneNo: $phoneNo, address: $address, attachedDoctor: $attachedDoctor)';
}
