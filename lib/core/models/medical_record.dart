class MedicalRecord {
  final int id;
  final String title;
  final String category;
  final String memberId;
  final String provider;
  final String date;
  final String type; // 'PDF' | 'Image'
  final String notes;
  final bool bookmarked;
  final bool archived;
  final List<String> tags;

  const MedicalRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.memberId,
    required this.provider,
    required this.date,
    this.type = 'PDF',
    this.notes = '',
    this.bookmarked = false,
    this.archived = false,
    this.tags = const [],
  });

  MedicalRecord copyWith({
    int? id,
    String? title,
    String? category,
    String? memberId,
    String? provider,
    String? date,
    String? type,
    String? notes,
    bool? bookmarked,
    bool? archived,
    List<String>? tags,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      memberId: memberId ?? this.memberId,
      provider: provider ?? this.provider,
      date: date ?? this.date,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      bookmarked: bookmarked ?? this.bookmarked,
      archived: archived ?? this.archived,
      tags: tags ?? this.tags,
    );
  }
}
