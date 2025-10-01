class Staff {
  final int id;
  final String documentId;
  final String nama;
  final String? nip;
  final String tempatLahir;
  final String tanggalLahir;
  final String gender;
  final String agama;
  final String? noTelepon;
  final String? namaIbu;
  final String nik;
  final String kategoriPersonil; // GURU, STAFF
  final String keteranganTugas;
  final String? statusKepegawaian;
  final String? mulaiTugas;
  final bool aktif;
  final String? pendidikanTerakhir;
  final String? lulusan;
  final String? statusPNS;
  final String? statusGuruTetap;
  final String? sertifikasi;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  Staff({
    required this.id,
    required this.documentId,
    required this.nama,
    this.nip,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.gender,
    required this.agama,
    this.noTelepon,
    this.namaIbu,
    required this.nik,
    required this.kategoriPersonil,
    required this.keteranganTugas,
    this.statusKepegawaian,
    this.mulaiTugas,
    required this.aktif,
    this.pendidikanTerakhir,
    this.lulusan,
    this.statusPNS,
    this.statusGuruTetap,
    this.sertifikasi,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] as int,
      documentId: json['documentId'] as String,
      nama: json['nama'] as String,
      nip: json['nip'] as String?,
      tempatLahir: json['tempatLahir'] as String,
      tanggalLahir: json['tanggalLahir'] as String,
      gender: json['gender'] as String,
      agama: json['agama'] as String,
      noTelepon: json['noTelepon'] as String?,
      namaIbu: json['namaIbu'] as String?,
      nik: json['NIK'] as String,
      kategoriPersonil: json['kategoriPersonil'] as String,
      keteranganTugas: json['keteranganTugas'] as String,
      statusKepegawaian: json['statusKepegawaian'] as String?,
      mulaiTugas: json['mulaiTugas'] as String?,
      aktif: json['aktif'] as bool,
      pendidikanTerakhir: json['pendidikanTerakhir'] as String?,
      lulusan: json['lulusan'] as String?,
      statusPNS: json['statusPNS'] as String?,
      statusGuruTetap: json['statusGuruTetap'] as String?,
      sertifikasi: json['sertifikasi'] as String?,
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
      'nip': nip,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'gender': gender,
      'agama': agama,
      'noTelepon': noTelepon,
      'namaIbu': namaIbu,
      'NIK': nik,
      'kategoriPersonil': kategoriPersonil,
      'keteranganTugas': keteranganTugas,
      'statusKepegawaian': statusKepegawaian,
      'mulaiTugas': mulaiTugas,
      'aktif': aktif,
      'pendidikanTerakhir': pendidikanTerakhir,
      'lulusan': lulusan,
      'statusPNS': statusPNS,
      'statusGuruTetap': statusGuruTetap,
      'sertifikasi': sertifikasi,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  // Helper getters
  String get namaLengkap => nama;
  String get tempatTanggalLahir => '$tempatLahir, $tanggalLahir';
  bool get isGuru => kategoriPersonil == 'GURU';
  bool get isStaff => kategoriPersonil == 'STAFF';
  String get jabatan => keteranganTugas;
}
