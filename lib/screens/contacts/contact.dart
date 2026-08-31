class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String relation;
  final bool isPrimary;
  final String avatarLetter;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
    required this.isPrimary,
    required this.avatarLetter,
  });

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phone,
    String? relation,
    bool? isPrimary,
    String? avatarLetter,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
      isPrimary: isPrimary ?? this.isPrimary,
      avatarLetter: avatarLetter ?? this.avatarLetter,
    );
  }
}