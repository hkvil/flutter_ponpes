class KehadiranGuru {
  final int id;
  final String documentId;
  final String tanggal;
  final String jenis; // HADIR, IZIN, SAKIT, ALPHA
  final String keterangan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  KehadiranGuru({
    required this.id,
    required this.documentId,
    required this.tanggal,
    required this.jenis,
    required this.keterangan,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory KehadiranGuru.fromJson(Map<String, dynamic> json) {
    return KehadiranGuru(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      tanggal: json['tanggal'] as String,
      jenis: json['jenis'] as String,
      keterangan: json['keterangan'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'tanggal': tanggal,
      'jenis': jenis,
      'keterangan': keterangan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isHadir => jenis == 'HADIR';
  bool get isIzin => jenis == 'IZIN';
  bool get isSakit => jenis == 'SAKIT';
  bool get isAlpha => jenis == 'ALPHA';
  DateTime get tanggalDateTime => DateTime.parse(tanggal);
}
