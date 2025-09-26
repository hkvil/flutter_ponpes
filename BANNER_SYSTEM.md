# Banner Configuration System

Sistem konfigurasi banner terpusat untuk menampilkan banner atas dan bawah di setiap cabang menu aplikasi Pesantren.

## Overview

Banner system ini menampilkan **banner yang sama untuk semua menu dalam satu lembaga**. Banner diambil dari field `topBanner` dan `botBanner` di level lembaga dari API.

**Key Features:**
- Banner sama untuk semua menu dalam satu lembaga (Profil, Program Kerja, dll)
- Berbeda antar lembaga (TK, SD, SMP masing-masing punya banner sendiri)
- Diambil dari API field `topBanner` dan `botBanner`
- Cached untuk performa optimal
- Support banner atas dan bawah (optional)

## File Structure

```
lib/
├── models/
│   └── banner_config.dart          # Model untuk banner configuration
├── core/utils/
│   ├── banner_manager.dart         # Manager untuk handle banner configs
│   └── menu_navigation_helper.dart # Updated dengan banner support
├── widgets/
│   └── banner_widget.dart          # Widget untuk display banner
└── screens/
    └── bannered_detail_screen.dart # Screen dengan banner support
```

## Models

### BannerConfig
Model utama untuk konfigurasi banner:

```dart
class BannerConfig {
  final String? topBannerUrl;        // URL gambar banner atas
  final String? bottomBannerUrl;     // URL gambar banner bawah  
  final String? topBannerRedirectUrl;    // URL redirect banner atas
  final String? bottomBannerRedirectUrl; // URL redirect banner bawah
}
```

### Lembaga Model Enhancement
Field baru ditambahkan ke model Lembaga:

```dart
final ImageItem? topBanner; // Banner atas untuk semua menu lembaga
final ImageItem? botBanner; // Banner bawah untuk semua menu lembaga
```

## API Response Format

Banner configuration dari API dalam format:

```json
{
  "id": 95,
  "nama": "Taman Kanak-Kanak",
  "slug": "taman-kanak-kanak",
  // ... fields lainnya
  "topBanner": {
    "id": 11,
    "url": "/uploads/top_banner_image.png",
    "alternativeText": "Top Banner",
    // ... media fields lainnya
  },
  "botBanner": {
    "id": 12,
    "url": "/uploads/bottom_banner_image.png",
    "alternativeText": "Bottom Banner",
    // ... media fields lainnya
  }
}
```

**Note:** `topBanner` dan `botBanner` bisa null jika lembaga tidak memiliki banner.

## Supported Menu Keys

Menu keys yang didukung (akan dinormalisasi otomatis):
- `profil` 
- `program-kerja`
- `kontak`
- `prestasi`
- `prestasi-sdm`
- `galeri`
- `sejarah`
- `visi-misi`
- `struktur-organisasi`
- `fasilitas`

## Usage

### 1. BannerManager

Manager utama untuk handle banner configs per lembaga:

```dart
final bannerManager = BannerManager();

// Get banner config untuk lembaga tertentu (sama untuk semua menu)
BannerConfig config = await bannerManager.getBannerConfig(
  'profil',  // menuKey tidak berpengaruh, hanya untuk backward compatibility
  lembagaSlug: 'taman-kanak-kanak'
);

// Get synchronous dari cache
BannerConfig config = bannerManager.getBannerConfigSync('', lembagaSlug: 'taman-kanak-kanak');

// Preload banner config dari API
await bannerManager.preloadBannerConfigs('taman-kanak-kanak');

// Clear cache untuk lembaga tertentu
bannerManager.clearCache('taman-kanak-kanak'); // atau clearCache() untuk semua
```

### 2. BannerWidget

Widget untuk display banner individual:

```dart
BannerWidget(
  bannerConfig: bannerConfig,
  isTopBanner: true,  // false untuk bottom banner
  height: 100,
  margin: EdgeInsets.all(16),
)
```

### 3. BanneredContent

Widget wrapper untuk content dengan banner:

```dart
BanneredContent(
  bannerConfig: bannerConfig,
  contentPadding: EdgeInsets.symmetric(horizontal: 16),
  content: YourMainContent(),
)
```

### 4. BanneredDetailScreen

Screen siap pakai dengan banner support:

```dart
BanneredDetailScreen(
  title: 'Al-Hikam - Profil',
  sections: profilSections,
  bannerConfig: bannerConfig,
)
```

## Integration Flow

1. **MenuNavigationHelper** dipanggil untuk navigasi menu
2. **BannerManager** mengambil banner config berdasarkan lembagaSlug:
   - Cek cache terlebih dahulu
   - Jika ada lembagaSlug, ambil dari API (topBanner & botBanner)
   - Fallback ke BannerConfig kosong jika tidak ada banner
3. **Navigation** menggunakan screen dengan banner support
4. **BannerWidget** menampilkan banner sesuai config lembaga

## Key Changes from Previous Design

### Old Design (Per Menu):
- Banner berbeda untuk setiap menu: profil punya banner sendiri, program kerja punya banner sendiri
- API format: `bannerConfigs: { "profil": {...}, "program-kerja": {...} }`

### New Design (Per Lembaga):
- Banner **sama untuk semua menu** dalam satu lembaga
- API format: `topBanner: {...}, botBanner: {...}` di level lembaga
- Lebih sederhana dan konsisten dengan kebutuhan actual

## Key Features

### Per-Lembaga Banner System
- Banner **sama untuk semua menu** dalam satu lembaga
- TK punya banner sendiri, SD punya banner sendiri, dst.
- Mengurangi kompleksitas konfigurasi

### Caching System
- Banner configs di-cache per lembaga (bukan per menu)
- Preload config dari API sekali saja per lembaga
- Cache otomatis saat pertama kali mengambil config

### API Integration
- Menggunakan `topBanner` dan `botBanner` dari Strapi
- Automatic URL resolution dengan AppConfig
- Graceful handling untuk banner yang null

### Error Handling
- Fallback ke default config saat API error
- Graceful handling untuk URL yang invalid
- Loading dan error states untuk gambar

### Performance
- Lazy loading banner configs
- Cached network images
- Minimal API calls dengan cache strategy

## Example Implementation

```dart
// Di MenuNavigationHelper
static void _navigateWithBanner(
  BuildContext context, 
  String menuItem, 
  String categoryTitle, 
  String? lembagaSlug
) async {
  // Get banner config (cached atau dari API)
  final bannerConfig = await _bannerManager.getBannerConfig(
    menuItem, 
    lembagaSlug: lembagaSlug
  );

  if (!context.mounted) return;

  // Navigate dengan banner
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BanneredDetailScreen(
        title: '$categoryTitle - $menuItem',
        sections: getSectionsForMenu(menuItem),
        bannerConfig: bannerConfig,
      ),
    ),
  );
}
```

## Configuration Examples

### Default Configuration (No Banner)
```dart
BannerConfig() // Semua field null, tidak ada banner
```

### Top Banner Only
```dart
BannerConfig(
  topBannerUrl: "https://example.com/top-banner.jpg",
  topBannerRedirectUrl: "https://website.com"
)
```

### Full Banner Configuration
```dart
BannerConfig(
  topBannerUrl: "https://example.com/top-banner.jpg",
  bottomBannerUrl: "https://example.com/bottom-banner.jpg",
  topBannerRedirectUrl: "https://website.com",
  bottomBannerRedirectUrl: "https://donate.com"
)
```

## Notes

- Banner images menggunakan `CachedNetworkImage` untuk performance
- Redirect URLs dibuka dengan `url_launcher` di external browser
- Banner height default 100px, bisa disesuaikan
- Border radius default 12px untuk aesthetic
- Shadow effect untuk visual depth