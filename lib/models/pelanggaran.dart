import 'santri.dart';

class Pelanggaran {
  final int id;
  final String documentId;
  final String jenis;
  final int poin;
  final String keterangan;
  final String tanggal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final Santri? santri; // Relasi dengan santri

  Pelanggaran({
    required this.id,
    required this.documentId,
    required this.jenis,
    required this.poin,
    required this.keterangan,
    required this.tanggal,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.santri,
  });

  factory Pelanggaran.fromJson(Map<String, dynamic> json) {
    return Pelanggaran(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      jenis: json['jenis'] as String,
      poin: json['poin'] as int,
      keterangan: json['keterangan'] as String,
      tanggal: json['tanggal'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      santri: json['santri'] != null
          ? Santri.fromJson(json['santri'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'jenis': jenis,
      'poin': poin,
      'keterangan': keterangan,
      'tanggal': tanggal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      'santri': santri?.toJson(),
    };
  }

  // Helper getters
  String get kategori {
    if (poin >= 30) return 'Berat';
    if (poin >= 15) return 'Sedang';
    return 'Ringan';
  }

  DateTime get tanggalDateTime => DateTime.parse(tanggal);
}
