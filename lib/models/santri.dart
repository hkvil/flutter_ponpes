class Santri {
  final int id;
  final String documentId;
  final String nama;
  final String nisn;
  final String gender;
  final String tempatLahir;
  final String tanggalLahir;
  final String namaAyah;
  final String namaIbu;
  final String kelurahan;
  final String kecamatan;
  final String kota;
  final String? nomorIjazah;
  final bool isAlumni;
  final String? tahunIjazah;
  final String tahunMasuk;
  final String? tahunLulus;
  final String? kelasAktif;
  final String? tahunAjaranAktif;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  Santri({
    required this.id,
    required this.documentId,
    required this.nama,
    required this.nisn,
    required this.gender,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.namaAyah,
    required this.namaIbu,
    required this.kelurahan,
    required this.kecamatan,
    required this.kota,
    this.nomorIjazah,
    required this.isAlumni,
    this.tahunIjazah,
    required this.tahunMasuk,
    this.tahunLulus,
    this.kelasAktif,
    this.tahunAjaranAktif,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      nama: json['nama'] as String,
      nisn: json['nisn'] as String,
      gender: json['gender'] as String,
      tempatLahir: json['tempatLahir'] as String,
      tanggalLahir: json['tanggalLahir'] as String,
      namaAyah: json['namaAyah'] as String,
      namaIbu: json['namaIbu'] as String,
      kelurahan: json['kelurahan'] as String,
      kecamatan: json['kecamatan'] as String,
      kota: json['kota'] as String,
      nomorIjazah: json['nomorIjazah'] as String?,
      isAlumni: json['isAlumni'] as bool,
      tahunIjazah: json['tahunIjazah'] as String?,
      tahunMasuk: json['tahunMasuk'] as String,
      tahunLulus: json['tahunLulus'] as String?,
      kelasAktif: json['kelasAktif'] as String?,
      tahunAjaranAktif: json['tahunAjaranAktif'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'nama': nama,
      'nisn': nisn,
      'gender': gender,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'namaAyah': namaAyah,
      'namaIbu': namaIbu,
      'kelurahan': kelurahan,
      'kecamatan': kecamatan,
      'kota': kota,
      'nomorIjazah': nomorIjazah,
      'isAlumni': isAlumni,
      'tahunIjazah': tahunIjazah,
      'tahunMasuk': tahunMasuk,
      'tahunLulus': tahunLulus,
      'kelasAktif': kelasAktif,
      'tahunAjaranAktif': tahunAjaranAktif,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  // Helper getters
  String get namaLengkap => nama;
  String get tempatTanggalLahir => '$tempatLahir, $tanggalLahir';
  String get alamatLengkap => 'Kel. $kelurahan, Kec. $kecamatan, $kota';

  // Age calculation
  int get umur {
    final lahir = DateTime.parse(tanggalLahir);
    final now = DateTime.now();
    int age = now.year - lahir.year;
    if (now.month < lahir.month ||
        (now.month == lahir.month && now.day < lahir.day)) {
      age--;
    }
    return age;
  }
}
