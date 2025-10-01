class TahunAjaran {
  final int id;
  final String documentId;
  final String tahunAjaran;
  final String semester; // GANJIL, GENAP
  final bool aktif;
  final String label;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  TahunAjaran({
    required this.id,
    required this.documentId,
    required this.tahunAjaran,
    required this.semester,
    required this.aktif,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory TahunAjaran.fromJson(Map<String, dynamic> json) {
    return TahunAjaran(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      tahunAjaran: json['tahunAjaran'] as String,
      semester: json['semester'] as String,
      aktif: json['aktif'] as bool,
      label: json['label'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'aktif': aktif,
      'label': label,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  @override
  String toString() => label;
}
