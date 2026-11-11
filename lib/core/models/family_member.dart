class FamilyMember {
  final String id;
  final String name;
  final String shortName;
  final String relation;
  final int age;
  final String initials;
  final String color;
  final String bloodGroup;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.shortName,
    required this.relation,
    required this.age,
    required this.initials,
    required this.color,
    required this.bloodGroup,
  });

  FamilyMember copyWith({
    String? id,
    String? name,
    String? shortName,
    String? relation,
    int? age,
    String? initials,
    String? color,
    String? bloodGroup,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      relation: relation ?? this.relation,
      age: age ?? this.age,
      initials: initials ?? this.initials,
      color: color ?? this.color,
      bloodGroup: bloodGroup ?? this.bloodGroup,
    );
  }
}
