class KehadiranGuru {
  final int id;
  final String documentId;
  final String tanggal;
  final String jenis; // HADIR, IZIN, SAKIT, ALPHA
  final String keterangan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  // Nested data from populate
  final StaffData? staff;

  KehadiranGuru({
    required this.id,
    required this.documentId,
    required this.tanggal,
    required this.jenis,
    required this.keterangan,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.staff,
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
      staff: json['staff'] != null
          ? StaffData.fromJson(json['staff'] as Map<String, dynamic>)
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
      if (staff != null) 'staff': staff!.toJson(),
    };
  }

  // Helper getters
  bool get isHadir => jenis == 'HADIR';
  bool get isIzin => jenis == 'IZIN';
  bool get isSakit => jenis == 'SAKIT';
  bool get isAlpha => jenis == 'ALPHA';
  DateTime get tanggalDateTime => DateTime.parse(tanggal);

  // Get staff name
  String get namaStaff => staff?.nama ?? '-';
}

// Simplified Staff data for kehadiran
class StaffData {
  final int id;
  final String nama;
  final String gender;
  final String? kategoriPersonil;
  final String? keteranganTugas;

  StaffData({
    required this.id,
    required this.nama,
    required this.gender,
    this.kategoriPersonil,
    this.keteranganTugas,
  });

  factory StaffData.fromJson(Map<String, dynamic> json) {
    return StaffData(
      id: json['id'] as int,
      nama: json['nama'] as String,
      gender: json['gender'] as String,
      kategoriPersonil: json['kategoriPersonil'] as String?,
      keteranganTugas: json['keteranganTugas'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'gender': gender,
      if (kategoriPersonil != null) 'kategoriPersonil': kategoriPersonil,
      if (keteranganTugas != null) 'keteranganTugas': keteranganTugas,
    };
  }
}
