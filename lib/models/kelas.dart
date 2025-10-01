class Kelas {
  final int id;
  final String documentId;
  final String kelas;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  Kelas({
    required this.id,
    required this.documentId,
    required this.kelas,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      kelas: json['kelas'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'kelas': kelas,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  @override
  String toString() => kelas;
}
