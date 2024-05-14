class Vaccine {
  final int id;
  final String name;
  final int ageMin;
  final int ageMax;


  Vaccine({
    this.id = 0,
    required this.name,
    required this.ageMin,
    required this.ageMax,
  });

  static Vaccine fromMap(Map<String, dynamic> map) => Vaccine(
    id: map['id'] as int,
    name: map['name'] as String,
    ageMin: map['age_min'] as int,
    ageMax: map['age_max'] as int,
  );

  @override
  String toString() {
    return 'Vaccine{id: $id, name: $name, ageMin: $ageMin, ageMax: $ageMax}';
  }
}
