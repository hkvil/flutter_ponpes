class KehadiranSantri {
  final int id;
  final String documentId;
  final String tanggal;
  final String jenis; // HADIR, IZIN, SAKIT, ALPHA
  final String keterangan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  // Nested data from populate
  final SantriData? santri;

  KehadiranSantri({
    required this.id,
    required this.documentId,
    required this.tanggal,
    required this.jenis,
    required this.keterangan,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.santri,
  });

  factory KehadiranSantri.fromJson(Map<String, dynamic> json) {
    return KehadiranSantri(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      tanggal: json['tanggal'] as String,
      jenis: json['jenis'] as String,
      keterangan: json['keterangan'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      santri: json['santri'] != null
          ? SantriData.fromJson(json['santri'] as Map<String, dynamic>)
          : null,
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
      if (santri != null) 'santri': santri!.toJson(),
    };
  }

  // Helper getters
  bool get isHadir => jenis == 'HADIR';
  bool get isIzin => jenis == 'IZIN';
  bool get isSakit => jenis == 'SAKIT';
  bool get isAlpha => jenis == 'ALPHA';
  DateTime get tanggalDateTime => DateTime.parse(tanggal);

  // Get santri name
  String get namaSantri => santri?.nama ?? '-';
}

// Simplified Santri data for kehadiran
class SantriData {
  final int id;
  final String nama;
  final String nisn;
  final String gender;
  final String? kelasAktif;

  SantriData({
    required this.id,
    required this.nama,
    required this.nisn,
    required this.gender,
    this.kelasAktif,
  });

  factory SantriData.fromJson(Map<String, dynamic> json) {
    return SantriData(
      id: json['id'] as int,
      nama: json['nama'] as String,
      nisn: json['nisn'] as String,
      gender: json['gender'] as String,
      kelasAktif: json['kelasAktif'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nisn': nisn,
      'gender': gender,
      if (kelasAktif != null) 'kelasAktif': kelasAktif,
    };
  }
}
