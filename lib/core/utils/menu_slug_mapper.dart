import '../constants/lembaga_slugs.dart';

/// Utility class untuk mapping nama menu ke lembaga slug
class MenuSlugMapper {
  /// Map nama menu/title ke slug lembaga untuk API calls
  static String? getSlugByMenuTitle(String menuTitle) {
    // Normalize title (trim, lowercase, handle special chars)
    final normalizedTitle = menuTitle.trim();

    print('🔍 [MENU_SLUG_MAPPER] Looking for slug for: "$normalizedTitle"');

    // Direct mapping berdasarkan nama yang ada di menu
    switch (normalizedTitle) {
      // ===== ORGAN STRUKTURAL =====
      case 'Pusat Kepegawaian dan Pengawasan':
        print(
            '✅ [MENU_SLUG_MAPPER] Found slug: pusat-kepegawaian-dan-pengawasan');
        return LembagaSlugs.pusatKepegawaianDanPengawasan;
      case 'Pusat Pengawasan dan Pembinaan SDM Putri':
        print(
            '✅ [MENU_SLUG_MAPPER] Found slug: pusat-pengawasan-dan-pembinaan-sdm-putri');
        return LembagaSlugs.pusatPengawasanDanPembinaanSdmPutri;
      case 'Pusat Penjaminan Mutu Pendidikan dan Pengajaran':
        print(
            '✅ [MENU_SLUG_MAPPER] Found slug: pusat-penjaminan-mutu-pendidikan-dan-pengajaran');
        return LembagaSlugs.pusatPenjaminanMutuPendidikanDanPengajaran;

      // ===== ORGAN PENYELENGGARA PENDIDIKAN FORMAL =====
      case 'Taman Kanak-Kanak':
        print('✅ [MENU_SLUG_MAPPER] Found slug: taman-kanak-kanak');
        return LembagaSlugs.tamanKanakKanak;
      case 'Taman Pendidikan Al-Qur\'an':
        print('✅ [MENU_SLUG_MAPPER] Found slug: taman-pendidikan-al-quran');
        return LembagaSlugs.tamanPendidikanAlQuran;
      case 'Madrasah Diniyah':
        print('✅ [MENU_SLUG_MAPPER] Found slug: madrasah-diniyah');
        return LembagaSlugs.madrasahDiniyah;
      case 'Madrasah Ibtidaiyah':
        print('✅ [MENU_SLUG_MAPPER] Found slug: madrasah-ibtidaiyah');
        return LembagaSlugs.madrasahIbtidaiyah;
      case 'Madrasah Tsanawiyah Putra':
        print('✅ [MENU_SLUG_MAPPER] Found slug: madrasah-tsanawiyah-putra');
        return LembagaSlugs.madrasahTsanawiyahPutra;
      case 'Madrasah Tsanawiyah Putri':
        print('✅ [MENU_SLUG_MAPPER] Found slug: madrasah-tsanawiyah-putri');
        return LembagaSlugs.madrasahTsanawiyahPutri;
      case 'Madrasah Aliyah Putra':
        print('✅ [MENU_SLUG_MAPPER] Found slug: madrasah-aliyah-putra');
        return LembagaSlugs.madrasahAliyahPutra;
      case 'Madrasah Aliyah Putri':
        print('✅ [MENU_SLUG_MAPPER] Found slug: madrasah-aliyah-putri');
        return LembagaSlugs.madrasahAliyahPutri;
      case 'Madrasah Tahfizh Lil Athfal':
        print('✅ [MENU_SLUG_MAPPER] Found slug: madrasah-tahfizh-lil-athfal');
        return LembagaSlugs.madrasahTahfizhLilAthfal;
      case 'Institut Mujahadah dan Pembibitan':
        print(
            '✅ [MENU_SLUG_MAPPER] Found slug: institut-mujahadah-dan-pembibitan');
        return LembagaSlugs.institutMujahadahDanPembibitan;
      case 'Haromain':
        print('✅ [MENU_SLUG_MAPPER] Found slug: haromain');
        return LembagaSlugs.haromain;
      case 'Al Ittifaqiah Language Center':
        print('✅ [MENU_SLUG_MAPPER] Found slug: al-ittifaqiah-language-center');
        return LembagaSlugs.alIttifaqiahLanguageCenter;

      // ===== ORGAN PENYELENGGARA PENDIDIKAN INFORMAL =====
      case 'LEMTATIQHI PA':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lemtatiqhi-pa');
        return LembagaSlugs.lemtatiqhiPA;
      case 'LEMTATIQHI PI':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lemtatiqhi-pi');
        return LembagaSlugs.lemtatiqhiPI;
      case 'LEBAH Putra':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lebah-putra');
        return LembagaSlugs.lebahPutra;
      case 'LEBAH Putri':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lebah-putri');
        return LembagaSlugs.lebahPutri;
      case 'LESGATRAM Putra':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lesgatram-putra');
        return LembagaSlugs.lesgatramPutra;
      case 'LESGATRAM Putri':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lesgatram-putri');
        return LembagaSlugs.lesgatramPutri;
      case 'Lembaga Muhadhoroh Putra':
        print('✅ [MENU_SLUG_MAPPER] Found slug: muhadhoroh-putra');
        return LembagaSlugs.muhadhorohPutra;
      case 'Lembaga Muhadhoroh Putri':
        print('✅ [MENU_SLUG_MAPPER] Found slug: muhadhoroh-putri');
        return LembagaSlugs.muhadhorohPutri;
      case 'LEMKAKIKU':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lemkakiku');
        return LembagaSlugs.lemkakiku;
      case 'LEMKAPPI':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lemkappi');
        return LembagaSlugs.lemkappi;
      case 'LERASI_LOGINTARU':
      case 'LERASI LOGINTARU':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lerasi-logintaru');
        return LembagaSlugs.lerasiLogintaru;
      case 'LK2PPI':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lk2ppi');
        return LembagaSlugs.lk2ppi;

      // ===== ORGAN PENGASUHAN DAN PENGKADERAN =====
      case 'DATSUHBINOSPI Putra':
        print('✅ [MENU_SLUG_MAPPER] Found slug: datsuhbinospi-putra');
        return LembagaSlugs.datsuhbinospiPutra;
      case 'DATSUHBINOSPI Putri':
        print('✅ [MENU_SLUG_MAPPER] Found slug: datsuhbinospi-putri');
        return LembagaSlugs.datsuhbinospiPutri;
      case 'Biro Pengkaderan, Beasiswa dan Kerjasama':
        print(
            '✅ [MENU_SLUG_MAPPER] Found slug: biro-pengkaderan-beasiswa-dan-kerjasama');
        return LembagaSlugs.biroPengkaderanBeasiswaDanKerjasama;

      // ===== ORGAN UMUM =====
      case 'ADKEU':
        print('✅ [MENU_SLUG_MAPPER] Found slug: adkeu');
        return LembagaSlugs.adkeu;
      case 'BIDDAPPMASSUL':
        print('✅ [MENU_SLUG_MAPPER] Found slug: biddappmassul');
        return LembagaSlugs.biddappmassul;
      case 'Bidang Kebersihan, Perairan, Pertamanan dan Lingkungan Hidup':
        print(
            '✅ [MENU_SLUG_MAPPER] Found slug: bidang-kebersihan-perairan-pertamanan-dan-lingkungan-hidup');
        return LembagaSlugs
            .bidangKebersihanPerairanPertamananDanLingkunganHidup;
      case 'Bidang Sarana Prasarana, Perlistrikan dan Transportasi':
        print(
            '✅ [MENU_SLUG_MAPPER] Found slug: bidang-sarana-prasarana-perlistrikan-dan-transportasi');
        return LembagaSlugs.bidangSaranaPrasaranaPerlistrikanDanTransportasi;
      case 'KESLOGMESS':
        print('✅ [MENU_SLUG_MAPPER] Found slug: keslogmess');
        return LembagaSlugs.keslogmess;
      case 'Klinik':
        print('✅ [MENU_SLUG_MAPPER] Found slug: klinik');
        return LembagaSlugs.klinik;
      case 'Bidang Keamanan, Ketertiban':
        print('✅ [MENU_SLUG_MAPPER] Found slug: bidang-keamanan-ketertiban');
        return LembagaSlugs.bidangKeamananKetertiban;
      case 'Hubungan Masyarakat dan Protokol':
        print('✅ [MENU_SLUG_MAPPER] Found slug: humas-dan-protokol');
        return LembagaSlugs.humasDanProtokol;

      // ===== ORGAN STRUKTURAL OTONOM =====
      case 'IWAPPI':
        print('✅ [MENU_SLUG_MAPPER] Found slug: iwappi');
        return LembagaSlugs.iwappi;
      case 'PUSPAMAYA':
        print('✅ [MENU_SLUG_MAPPER] Found slug: puspamaya');
        return LembagaSlugs.puspamaya;
      case 'PUSDEM':
        print('✅ [MENU_SLUG_MAPPER] Found slug: pusdem');
        return LembagaSlugs.pusdem;
      case 'Avicenna Institute':
        print('✅ [MENU_SLUG_MAPPER] Found slug: avicenna-institute');
        return LembagaSlugs.avicennaInstitute;
      case 'PUSDAP':
        print('✅ [MENU_SLUG_MAPPER] Found slug: pusdap');
        return LembagaSlugs.pusdap;
      case 'PBHU':
        print('✅ [MENU_SLUG_MAPPER] Found slug: pbhu');
        return LembagaSlugs.pbhu;
      case 'LPBI':
        print('✅ [MENU_SLUG_MAPPER] Found slug: lpbi');
        return LembagaSlugs.lpbi;

      default:
        // Jika tidak ada mapping, return null (akan fallback ke static content)
        print(
            '❌ [MENU_SLUG_MAPPER] No slug found, will fallback to static content');
        return null;
    }
  }

  /// Check apakah menu title memiliki slug (API content available)
  static bool hasApiContent(String menuTitle) {
    return getSlugByMenuTitle(menuTitle) != null;
  }

  /// Get human readable name dari slug (untuk debugging)
  static String? getNameBySlug(String slug) {
    return LembagaSlugs.getNamaBySlug(slug);
  }
}
