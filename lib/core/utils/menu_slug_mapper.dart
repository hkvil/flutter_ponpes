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
      // Pusat-pusat (yang ada di constants)
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

      // Pendidikan Formal (yang ada di constants)
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
