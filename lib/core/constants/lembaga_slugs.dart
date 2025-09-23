/// Daftar lengkap slug lembaga dari Strapi seed data
/// Berdasarkan: src/seeds/lembaga.seed.ts

class LembagaSlugs {
  // ORGAN STRUKTURAL
  static const String pusatKepegawaianDanPengawasan =
      'pusat-kepegawaian-dan-pengawasan';
  static const String pusatPengawasanDanPembinaanSdmPutri =
      'pusat-pengawasan-dan-pembinaan-sdm-putri';
  static const String pusatPenjaminanMutuPendidikanDanPengajaran =
      'pusat-penjaminan-mutu-pendidikan-dan-pengajaran';

  // ORGAN PENYELENGGARA PENDIDIKAN FORMAL
  static const String tamanKanakKanak = 'taman-kanak-kanak';
  static const String tamanPendidikanAlQuran = 'taman-pendidikan-al-quran';
  static const String madrasahDiniyah = 'madrasah-diniyah';
  static const String madrasahIbtidaiyah = 'madrasah-ibtidaiyah';
  static const String madrasahTsanawiyahPutra = 'madrasah-tsanawiyah-putra';
  static const String madrasahTsanawiyahPutri = 'madrasah-tsanawiyah-putri';
  static const String madrasahAliyahPutra = 'madrasah-aliyah-putra';
  static const String madrasahAliyahPutri = 'madrasah-aliyah-putri';
  static const String madrasahTahfizhLilAthfal = 'madrasah-tahfizh-lil-athfal';
  static const String institutMujahadahDanPembibitan =
      'institut-mujahadah-dan-pembibitan';
  static const String haromain = 'haromain'; // atau 'haramain' jika diperbaiki
  static const String alIttifaqiahLanguageCenter =
      'al-ittifaqiah-language-center';

  // ORGAN PENYELENGGARA PENDIDIKAN INFORMAL
  static const String lemtatiqhiPA = 'lemtatiqhi-pa';
  static const String lemtatiqhiPI = 'lemtatiqhi-pi';
  static const String lebahPutra = 'lebah-putra';
  static const String lebahPutri = 'lebah-putri';
  static const String lesgatramPutra = 'lesgatram-putra';
  static const String lesgatramPutri = 'lesgatram-putri';
  static const String muhadhorohPutra = 'muhadhoroh-putra';
  static const String muhadhorohPutri = 'muhadhoroh-putri';
  static const String lemkakiku = 'lemkakiku';
  static const String lemkappi = 'lemkappi';
  static const String lerasiLogintaru = 'lerasi-logintaru';
  static const String lk2ppi = 'lk2ppi';

  // ORGAN PENGASUHAN DAN PENGKADERAN
  static const String datsuhbinospiPutra = 'datsuhbinospi-putra';
  static const String datsuhbinospiPutri = 'datsuhbinospi-putri';
  static const String biroPengkaderanBeasiswaDanKerjasama =
      'biro-pengkaderan-beasiswa-dan-kerjasama';

  // ORGAN UMUM
  static const String adkeu = 'adkeu';
  static const String biddappmassul = 'biddappmassul';
  static const String bidangKebersihanPerairanPertamananDanLingkunganHidup =
      'bidang-kebersihan-perairan-pertamanan-dan-lingkungan-hidup';
  static const String bidangSaranaPrasaranaPerlistrikanDanTransportasi =
      'bidang-sarana-prasarana-perlistrikan-dan-transportasi';
  static const String keslogmess = 'keslogmess';
  static const String klinik = 'klinik';
  static const String bidangKeamananKetertiban = 'bidang-keamanan-ketertiban';
  static const String humasDanProtokol = 'humas-dan-protokol';

  // ORGAN STRUKTURAL OTONOM
  static const String iwappi = 'iwappi';
  static const String puspamaya = 'puspamaya';
  static const String pusdem = 'pusdem';
  static const String avicennaInstitute = 'avicenna-institute';
  static const String pusdap = 'pusdap';
  static const String pbhu = 'pbhu';
  static const String lpbi = 'lpbi';

  /// Daftar semua slug dalam array
  static const List<String> allSlugs = [
    // ORGAN STRUKTURAL
    pusatKepegawaianDanPengawasan,
    pusatPengawasanDanPembinaanSdmPutri,
    pusatPenjaminanMutuPendidikanDanPengajaran,

    // ORGAN PENYELENGGARA PENDIDIKAN FORMAL
    tamanKanakKanak,
    tamanPendidikanAlQuran,
    madrasahDiniyah,
    madrasahIbtidaiyah,
    madrasahTsanawiyahPutra,
    madrasahTsanawiyahPutri,
    madrasahAliyahPutra,
    madrasahAliyahPutri,
    madrasahTahfizhLilAthfal,
    institutMujahadahDanPembibitan,
    haromain,
    alIttifaqiahLanguageCenter,

    // ORGAN PENYELENGGARA PENDIDIKAN INFORMAL
    lemtatiqhiPA,
    lemtatiqhiPI,
    lebahPutra,
    lebahPutri,
    lesgatramPutra,
    lesgatramPutri,
    muhadhorohPutra,
    muhadhorohPutri,
    lemkakiku,
    lemkappi,
    lerasiLogintaru,
    lk2ppi,

    // ORGAN PENGASUHAN DAN PENGKADERAN
    datsuhbinospiPutra,
    datsuhbinospiPutri,
    biroPengkaderanBeasiswaDanKerjasama,

    // ORGAN UMUM
    adkeu,
    biddappmassul,
    bidangKebersihanPerairanPertamananDanLingkunganHidup,
    bidangSaranaPrasaranaPerlistrikanDanTransportasi,
    keslogmess,
    klinik,
    bidangKeamananKetertiban,
    humasDanProtokol,

    // ORGAN STRUKTURAL OTONOM
    iwappi,
    puspamaya,
    pusdem,
    avicennaInstitute,
    pusdap,
    pbhu,
    lpbi,
  ];

  /// Mapping slug ke nama lengkap
  static const Map<String, String> slugToNama = {
    // ORGAN STRUKTURAL
    pusatKepegawaianDanPengawasan: 'Pusat Kepegawaian dan Pengawasan',
    pusatPengawasanDanPembinaanSdmPutri:
        'Pusat Pengawasan dan Pembinaan SDM Putri',
    pusatPenjaminanMutuPendidikanDanPengajaran:
        'Pusat Penjaminan Mutu Pendidikan dan Pengajaran',

    // ORGAN PENYELENGGARA PENDIDIKAN FORMAL
    tamanKanakKanak: 'Taman AKanak-Kanak',
    tamanPendidikanAlQuran: 'Taman Pendidikan Al-Qur\'an',
    madrasahDiniyah: 'Madrasah Diniyah',
    madrasahIbtidaiyah: 'Madrasah Ibtidaiyah',
    madrasahTsanawiyahPutra: 'Madrasah Tsanawiyah Putra',
    madrasahTsanawiyahPutri: 'Madrasah Tsanawiyah Putri',
    madrasahAliyahPutra: 'Madrasah Aliyah Putra',
    madrasahAliyahPutri: 'Madrasah Aliyah Putri',
    madrasahTahfizhLilAthfal: 'Madrasah Tahfizh Lil Athfal',
    institutMujahadahDanPembibitan: 'Institut Mujahadah dan Pembibitan',
    haromain: 'Haromain',
    alIttifaqiahLanguageCenter: 'Al Ittifaqiah Language Center',

    // ORGAN PENYELENGGARA PENDIDIKAN INFORMAL
    lemtatiqhiPA: 'LEMTATIQHI PA',
    lemtatiqhiPI: 'LEMTATIQHI PI',
    lebahPutra: 'LEBAH Putra',
    lebahPutri: 'LEBAH Putri',
    lesgatramPutra: 'LESGATRAM Putra',
    lesgatramPutri: 'LESGATRAM Putri',
    muhadhorohPutra: 'Lembaga Muhadhoroh Putra',
    muhadhorohPutri: 'Lembaga Muhadhoroh Putri',
    lemkakiku: 'LEMKAKIKU',
    lemkappi: 'LEMKAPPI',
    lerasiLogintaru: 'LERASI_LOGINTARU',
    lk2ppi: 'LK2PPI',

    // ORGAN PENGASUHAN DAN PENGKADERAN
    datsuhbinospiPutra: 'DATSUHBINOSPI Putra',
    datsuhbinospiPutri: 'DATSUHBINOSPI Putri',
    biroPengkaderanBeasiswaDanKerjasama:
        'Biro Pengkaderan, Beasiswa dan Kerjasama',

    // ORGAN UMUM
    adkeu: 'ADKEU',
    biddappmassul: 'BIDDAPPMASSUL',
    bidangKebersihanPerairanPertamananDanLingkunganHidup:
        'Bidang Kebersihan, Perairan, Pertamanan dan Lingkungan Hidup',
    bidangSaranaPrasaranaPerlistrikanDanTransportasi:
        'Bidang Sarana Prasarana, Perlistrikan dan Transportasi',
    keslogmess: 'KESLOGMESS',
    klinik: 'Klinik',
    bidangKeamananKetertiban: 'Bidang Keamanan, Ketertiban',
    humasDanProtokol: 'Hubungan Masyarakat dan Protokol',

    // ORGAN STRUKTURAL OTONOM
    iwappi: 'IWAPPI',
    puspamaya: 'PUSPAMAYA',
    pusdem: 'PUSDEM',
    avicennaInstitute: 'Avicenna Institute',
    pusdap: 'PUSDAP',
    pbhu: 'PBHU',
    lpbi: 'LPBI',
  };

  /// Helper method untuk mendapatkan nama dari slug
  static String? getNamaBySlug(String slug) {
    return slugToNama[slug];
  }

  /// Helper method untuk validasi slug
  static bool isValidSlug(String slug) {
    return allSlugs.contains(slug);
  }

  /// Get slugs by category
  static List<String> get organStruktural => [
        pusatKepegawaianDanPengawasan,
        pusatPengawasanDanPembinaanSdmPutri,
        pusatPenjaminanMutuPendidikanDanPengajaran,
      ];

  static List<String> get pendidikanFormal => [
        tamanKanakKanak,
        tamanPendidikanAlQuran,
        madrasahDiniyah,
        madrasahIbtidaiyah,
        madrasahTsanawiyahPutra,
        madrasahTsanawiyahPutri,
        madrasahAliyahPutra,
        madrasahAliyahPutri,
        madrasahTahfizhLilAthfal,
        institutMujahadahDanPembibitan,
        haromain,
        alIttifaqiahLanguageCenter,
      ];

  static List<String> get pendidikanInformal => [
        lemtatiqhiPA,
        lemtatiqhiPI,
        lebahPutra,
        lebahPutri,
        lesgatramPutra,
        lesgatramPutri,
        muhadhorohPutra,
        muhadhorohPutri,
        lemkakiku,
        lemkappi,
        lerasiLogintaru,
        lk2ppi,
      ];

  static List<String> get pengasuhanDanPengkaderan => [
        datsuhbinospiPutra,
        datsuhbinospiPutri,
        biroPengkaderanBeasiswaDanKerjasama,
      ];

  static List<String> get organUmum => [
        adkeu,
        biddappmassul,
        bidangKebersihanPerairanPertamananDanLingkunganHidup,
        bidangSaranaPrasaranaPerlistrikanDanTransportasi,
        keslogmess,
        klinik,
        bidangKeamananKetertiban,
        humasDanProtokol,
      ];

  static List<String> get organStruturalOtonom => [
        iwappi,
        puspamaya,
        pusdem,
        avicennaInstitute,
        pusdap,
        pbhu,
        lpbi,
      ];
}
