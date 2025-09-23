# API Lembaga Integration Documentation

## Overview
Integrasi API Lembaga memungkinkan aplikasi mengambil konten `profilMd` dan `programKerjaMd` dari Strapi backend berdasarkan slug lembaga.

## API Endpoint
```
GET http://localhost:1337/api/lembagas?filters[slug][$eq]={slug}&populate=*
```

## Implementation

### 1. Model (LembagaModel)
```dart
// lib/models/lembaga_model.dart
class Lembaga {
  final String slug;
  final String nama;
  final String? profilMd;
  final String? programKerjaMd;
  
  // Helper methods
  bool hasProfilContent() => profilMd != null && profilMd!.isNotEmpty;
  bool hasProgramKerjaContent() => programKerjaMd != null && programKerjaMd!.isNotEmpty;
}
```

### 2. Repository (LembagaRepository)
```dart
// lib/repository/lembaga_repository.dart
class LembagaRepository {
  Future<Lembaga?> fetchBySlug(String slug) async {
    // Hit API dengan slug filter
    // Return Lembaga object dengan profilMd dan programKerjaMd
  }
}
```

### 3. Navigation Helper (MenuNavigationHelper)
```dart
// lib/core/utils/menu_navigation_helper.dart
class MenuNavigationHelper {
  static void navigateToMenuItem(
    BuildContext context,
    String menuItem,
    String categoryTitle,
    {String? lembagaSlug} // New parameter
  ) {
    if (lembagaSlug != null) {
      // Hit API dan render markdown content
      _navigateWithApiContent(context, menuItem, categoryTitle, lembagaSlug);
    } else {
      // Fallback ke static content
      _navigateWithStaticContent(context, menuItem, categoryTitle);
    }
  }
}
```

### 4. Detail Layout (DetailLayout)
```dart
// lib/widgets/detail_layout.dart
class DetailLayout extends StatelessWidget {
  final String? lembagaSlug; // New parameter

  const DetailLayout({
    required this.title,
    this.lembagaSlug, // Pass slug untuk API integration
  });
}
```

## Usage Examples

### 1. Dengan API Content (Recommended)
```dart
DetailLayout(
  title: 'Taman Kanak-Kanak',
  lembagaSlug: 'taman-kanak-kanak', // Hit API
  menuItems: menuItemsJenis2,
)
```

### 2. Dengan Static Content (Fallback)
```dart
DetailLayout(
  title: 'Static Content',
  // Tidak ada lembagaSlug = gunakan static content
  menuItems: menuItemsJenis1,
)
```

## Slug Mapping

Berdasarkan seed data Strapi:

### Pendidikan Formal
- `taman-kanak-kanak` → "Taman Kanak-Kanak"
- `madrasah-ibtidaiyah` → "Madrasah Ibtidaiyah"
- `madrasah-tsanawiyah-putra` → "Madrasah Tsanawiyah Putra"
- `madrasah-aliyah-putra` → "Madrasah Aliyah Putra"

### Organ Struktural
- `pusat-kepegawaian-dan-pengawasan` → "Pusat Kepegawaian dan Pengawasan"
- `pusat-penjaminan-mutu-pendidikan-dan-pengajaran` → "Pusat Penjaminan Mutu..."

### Lembaga Informal
- `lemtatiqhi-pa` → "LEMTATIQHI PA"
- `lebah-putra` → "LEBAH Putra"

## Menu Item Mapping

### Supported API Menu Items:
- **"Profil"** → Render `profilMd` dari API
- **"Program Kerja"** → Render `programKerjaMd` dari API

### Static Menu Items (Fallback):
- "Prestasi" → Static markdown content
- "Kontak" → Static ProfileSection
- "SDM", "Santri", "Guru", dll → "Coming Soon"

## Flow Diagram

```
User clicks menu item
        ↓
DetailLayout.onTap()
        ↓
MenuNavigationHelper.navigateToMenuItem()
        ↓
    lembagaSlug != null?
        ↓               ↓
      YES              NO
        ↓               ↓
_navigateWithApiContent  _navigateWithStaticContent
        ↓               ↓
LembagaRepository.fetchBySlug()  Static ProfileSection
        ↓               ↓
ContentScreen with markdown    DetailContentScreen
```

## Error Handling

1. **API Error** → Show error snackbar
2. **Lembaga not found** → Show "Data tidak ditemukan"
3. **Empty content** → Show "Konten belum tersedia"
4. **Network timeout** → Show error message

## Testing

Use `ApiDemoScreen` untuk testing:

```dart
// Demo dengan API
DetailLayout(
  title: 'Taman Kanak-Kanak',
  lembagaSlug: 'taman-kanak-kanak',
  menuItems: menuItemsJenis2,
)

// Klik "Profil" → Hit API → Render profilMd
// Klik "Program Kerja" → Hit API → Render programKerjaMd
```

## Environment Variables

Pastikan `.env` sudah ada:
```env
API_HOST=http://localhost:1337
API_TOKEN_READONLY=your_strapi_token
```

## Future Enhancements

1. **Caching** → Simpan API response untuk performa
2. **Offline Mode** → Fallback ke cached data
3. **More Fields** → Support `kontakMd`, `galeriMd`, dll
4. **Push Notifications** → Update content realtime