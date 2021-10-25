final String tableNotes = 'attendancestwo';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id,  image, address, createdTime
  ];

  static final String id = '_id';
  static final String image = 'image';
  static final String address = 'address';
  static final String createdTime = 'createdTime';
}

class Note {
  final int? id;
  final String image;
  final String address;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.image,
    required this.address,
    required this.createdTime,
  });

  Note copy({
    int? id,
    String? image,
    String? address,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,

        image: image ?? this.image,
        address: address ?? this.address,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,

        image: json[NoteFields.image] as String,
        address: json[NoteFields.address] as String,
        createdTime: DateTime.parse(json[NoteFields.createdTime] as String),
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.image: image,

        NoteFields.address: address,
        NoteFields.createdTime: createdTime.toIso8601String(),
      };
}
