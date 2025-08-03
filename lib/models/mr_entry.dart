class MREntry {
  final String name;
  final int age;
  final String sex;
  final String phoneNo;
  final String address;
  final String areaName;
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String headquarter;

  MREntry({
    required this.name,
    required this.age,
    required this.sex,
    required this.phoneNo,
    required this.address,
    required this.areaName,
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.headquarter,
  });

  MREntry copyWith({
    String? name,
    int? age,
    String? sex,
    String? phoneNo,
    String? address,
    String? areaName,
    String? accountNumber,
    String? bankName,
    String? ifscCode,
    String? headquarter,
  }) {
    return MREntry(
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      phoneNo: phoneNo ?? this.phoneNo,
      address: address ?? this.address,
      areaName: areaName ?? this.areaName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      ifscCode: ifscCode ?? this.ifscCode,
      headquarter: headquarter ?? this.headquarter,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'sex': sex,
      'phoneNo': phoneNo,
      'address': address,
      'areaName': areaName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'headquarter': headquarter,
    };
  }

  factory MREntry.fromJson(Map<String, dynamic> json) {
    return MREntry(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      sex: json['sex'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      address: json['address'] ?? '',
      areaName: json['areaName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      bankName: json['bankName'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      headquarter: json['headquarter'] ?? '',
    );
  }
}
