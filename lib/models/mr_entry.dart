import 'package:uuid/uuid.dart';

class MREntry {
  final String? id;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MREntry({
    this.id,
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
    this.createdAt,
    this.updatedAt,
  });

  // Generate a new MREntry with an ID for database insertion
  MREntry withGeneratedId() {
    return MREntry(
      id: const Uuid().v4(),
      name: name,
      age: age,
      sex: sex,
      phoneNo: phoneNo,
      address: address,
      areaName: areaName,
      accountNumber: accountNumber,
      bankName: bankName,
      ifscCode: ifscCode,
      headquarter: headquarter,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  MREntry copyWith({
    String? id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MREntry(
      id: id ?? this.id,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // JSON serialization for database operations
  Map<String, dynamic> toSupabaseJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'age': age,
      'sex': sex,
      'phone_no': phoneNo,
      'address': address,
      'area_name': areaName,
      'account_number': accountNumber,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'headquarter': headquarter,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // JSON serialization for UI operations (backwards compatibility)
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
      id: json['id'],
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      sex: json['sex'] ?? '',
      phoneNo: json['phoneNo'] ?? json['phone_no'] ?? '',
      address: json['address'] ?? '',
      areaName: json['areaName'] ?? json['area_name'] ?? '',
      accountNumber: json['accountNumber'] ?? json['account_number'] ?? '',
      bankName: json['bankName'] ?? json['bank_name'] ?? '',
      ifscCode: json['ifscCode'] ?? json['ifsc_code'] ?? '',
      headquarter: json['headquarter'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
