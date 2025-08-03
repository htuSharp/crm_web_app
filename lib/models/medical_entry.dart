class MedicalEntry {
  final String name;
  final String type;
  final String contact;
  final String address;
  final String specialization;

  MedicalEntry({
    required this.name,
    required this.type,
    required this.contact,
    required this.address,
    required this.specialization,
  });

  MedicalEntry copyWith({
    String? name,
    String? type,
    String? contact,
    String? address,
    String? specialization,
  }) {
    return MedicalEntry(
      name: name ?? this.name,
      type: type ?? this.type,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      specialization: specialization ?? this.specialization,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'contact': contact,
      'address': address,
      'specialization': specialization,
    };
  }

  factory MedicalEntry.fromJson(Map<String, dynamic> json) {
    return MedicalEntry(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      specialization: json['specialization'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicalEntry &&
        other.name == name &&
        other.type == type &&
        other.contact == contact &&
        other.address == address &&
        other.specialization == specialization;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        contact.hashCode ^
        address.hashCode ^
        specialization.hashCode;
  }

  @override
  String toString() =>
      'MedicalEntry(name: $name, type: $type, contact: $contact, address: $address, specialization: $specialization)';
}
