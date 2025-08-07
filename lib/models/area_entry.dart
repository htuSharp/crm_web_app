import 'package:uuid/uuid.dart';

class AreaEntry {
  final String id;
  final String area;
  final String headquarter;
  final DateTime createdAt;
  final DateTime updatedAt;

  AreaEntry({
    String? id,
    required this.area,
    required this.headquarter,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  AreaEntry copyWith({
    String? id,
    String? area,
    String? headquarter,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AreaEntry(
      id: id ?? this.id,
      area: area ?? this.area,
      headquarter: headquarter ?? this.headquarter,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area': area,
      'headquarter': headquarter,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toSupabaseJson() {
    final json = toJson();
    json.remove('created_at');
    json.remove('updated_at');
    return json;
  }

  factory AreaEntry.fromJson(Map<String, dynamic> json) {
    return AreaEntry(
      id: json['id'] ?? '',
      area: json['area'] ?? '',
      headquarter: json['headquarter'] ?? '',
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
    return other is AreaEntry &&
        other.id == id &&
        other.area == area &&
        other.headquarter == headquarter;
  }

  @override
  int get hashCode => id.hashCode ^ area.hashCode ^ headquarter.hashCode;

  @override
  String toString() =>
      'AreaEntry(id: $id, area: $area, headquarter: $headquarter, createdAt: $createdAt, updatedAt: $updatedAt)';
}
