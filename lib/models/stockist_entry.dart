class StockistEntry {
  final String name;
  final String company;
  final String contact;
  final String address;
  final String area;
  final String licenseNumber;

  StockistEntry({
    required this.name,
    required this.company,
    required this.contact,
    required this.address,
    required this.area,
    required this.licenseNumber,
  });

  StockistEntry copyWith({
    String? name,
    String? company,
    String? contact,
    String? address,
    String? area,
    String? licenseNumber,
  }) {
    return StockistEntry(
      name: name ?? this.name,
      company: company ?? this.company,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      area: area ?? this.area,
      licenseNumber: licenseNumber ?? this.licenseNumber,
    );
  }

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
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      area: json['area'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StockistEntry &&
        other.name == name &&
        other.company == company &&
        other.contact == contact &&
        other.address == address &&
        other.area == area &&
        other.licenseNumber == licenseNumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        company.hashCode ^
        contact.hashCode ^
        address.hashCode ^
        area.hashCode ^
        licenseNumber.hashCode;
  }

  @override
  String toString() =>
      'StockistEntry(name: $name, company: $company, contact: $contact, address: $address, area: $area, licenseNumber: $licenseNumber)';
}
