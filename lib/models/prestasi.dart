class Prestasi {
  final int id;
  final String documentId;
  final String namaLomba;
  final String bidang;
  final String penyelenggara;
  final String tingkat;
  final String peringkat;
  final String tahun;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final PrestasiSantriData? santri;

  Prestasi({
    required this.id,
    required this.documentId,
    required this.namaLomba,
    required this.bidang,
    required this.penyelenggara,
    required this.tingkat,
    required this.peringkat,
    required this.tahun,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.santri,
  });

  factory Prestasi.fromJson(Map<String, dynamic> json) {
    return Prestasi(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      namaLomba: json['namaLomba'] as String,
      bidang: json['bidang'] as String,
      penyelenggara: json['penyelenggara'] as String,
      tingkat: json['tingkat'] as String,
      peringkat: json['peringkat'] as String,
      tahun: json['tahun'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      santri: json['santri'] != null
          ? PrestasiSantriData.fromJson(json['santri'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'namaLomba': namaLomba,
      'bidang': bidang,
      'penyelenggara': penyelenggara,
      'tingkat': tingkat,
      'peringkat': peringkat,
      'tahun': tahun,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      if (santri != null) 'santri': santri!.toJson(),
    };
  }

  // Helper getters
  String get namaSantri => santri?.nama ?? '-';
  String get kelasSantri => santri?.kelasAktif ?? '-';

  bool get isJuara1 =>
      peringkat.contains('1') || peringkat.toLowerCase().contains('juara 1');
  bool get isNasional => tingkat == 'Nasional';
  bool get isInternasional => tingkat == 'Internasional';

  // Get ranking order for sorting
  int get rankingOrder {
    if (peringkat.contains('1') || peringkat.toLowerCase().contains('juara 1'))
      return 1;
    if (peringkat.contains('2') || peringkat.toLowerCase().contains('juara 2'))
      return 2;
    if (peringkat.contains('3') || peringkat.toLowerCase().contains('juara 3'))
      return 3;
    if (peringkat.toLowerCase().contains('harapan 1')) return 4;
    if (peringkat.toLowerCase().contains('harapan 2')) return 5;
    if (peringkat.toLowerCase().contains('harapan 3')) return 6;
    return 99; // Other rankings
  }
}

class PrestasiSantriData {
  final int id;
  final String documentId;
  final String nama;
  final String nisn;
  final String gender;
  final String? kelasAktif;
  final String? tahunAjaranAktif;

  PrestasiSantriData({
    required this.id,
    required this.documentId,
    required this.nama,
    required this.nisn,
    required this.gender,
    this.kelasAktif,
    this.tahunAjaranAktif,
  });

  factory PrestasiSantriData.fromJson(Map<String, dynamic> json) {
    return PrestasiSantriData(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      nama: json['nama'] as String,
      nisn: json['nisn'] as String,
      gender: json['gender'] as String,
      kelasAktif: json['kelasAktif'] as String?,
      tahunAjaranAktif: json['tahunAjaranAktif'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'nama': nama,
      'nisn': nisn,
      'gender': gender,
      'kelasAktif': kelasAktif,
      'tahunAjaranAktif': tahunAjaranAktif,
    };
  }
}
