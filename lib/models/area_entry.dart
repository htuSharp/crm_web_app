class AreaEntry {
  final String area;
  final String headquarter;

  AreaEntry({required this.area, required this.headquarter});

  AreaEntry copyWith({String? area, String? headquarter}) {
    return AreaEntry(
      area: area ?? this.area,
      headquarter: headquarter ?? this.headquarter,
    );
  }

  Map<String, dynamic> toJson() {
    return {'area': area, 'headquarter': headquarter};
  }

  factory AreaEntry.fromJson(Map<String, dynamic> json) {
    return AreaEntry(
      area: json['area'] ?? '',
      headquarter: json['headquarter'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AreaEntry &&
        other.area == area &&
        other.headquarter == headquarter;
  }

  @override
  int get hashCode => area.hashCode ^ headquarter.hashCode;

  @override
  String toString() => 'AreaEntry(area: $area, headquarter: $headquarter)';
}
