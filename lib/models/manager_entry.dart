import 'package:uuid/uuid.dart';

class ManagerEntry {
  final String? id;
  final String name;
  final List<String> mrList; // List of MR names under this manager
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ManagerEntry({
    this.id,
    required this.name,
    required this.mrList,
    this.createdAt,
    this.updatedAt,
  });

  // Generate a new ManagerEntry with an ID for database insertion
  ManagerEntry withGeneratedId() {
    return ManagerEntry(
      id: const Uuid().v4(),
      name: name,
      mrList: mrList,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  ManagerEntry copyWith({
    String? id,
    String? name,
    List<String>? mrList,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ManagerEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      mrList: mrList ?? this.mrList,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // JSON serialization for database operations
  Map<String, dynamic> toSupabaseJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'mr_list': mrList,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // JSON serialization for UI operations (backwards compatibility)
  Map<String, dynamic> toJson() {
    return {'name': name, 'mrList': mrList};
  }

  factory ManagerEntry.fromJson(Map<String, dynamic> json) {
    return ManagerEntry(
      id: json['id'],
      name: json['name'] ?? '',
      mrList: List<String>.from(json['mrList'] ?? json['mr_list'] ?? []),
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
    return other is ManagerEntry &&
        other.id == id &&
        other.name == name &&
        _listEquals(other.mrList, mrList);
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(id, name, mrList);

  @override
  String toString() {
    return 'ManagerEntry(id: $id, name: $name, mrList: $mrList)';
  }
}
