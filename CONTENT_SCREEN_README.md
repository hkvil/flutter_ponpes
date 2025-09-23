# ContentScreen Documentation

## Overview
`ContentScreen` adalah screen universal yang bisa merender markdown content dengan 2 tipe layout berbeda:

1. **Full Layout**: Banner + Section Header + Markdown Content + Bottom Banner
2. **Minimal Layout**: Hanya Markdown Content

## Screen Hierarchy
- **ContentScreen**: Base screen untuk rendering markdown
- **DetailContentScreen**: Untuk profil, program kerja, kontak (menggunakan ProfileSection)
- **AchievementDetailScreen**: Untuk detail prestasi (menggunakan markdown content)

## Usage

### 1. Basic ContentScreen

```dart
import 'package:pesantren_app/screens/content_screen.dart';

// Full layout
ContentScreen(
  title: 'Judul Halaman',
  markdownContent: '# Hello World\nIni adalah **markdown** content.',
  type: ContentScreenType.full,
)

// Minimal layout  
ContentScreen(
  title: 'Judul Halaman',
  markdownContent: '# Hello World\nIni adalah **markdown** content.',
  type: ContentScreenType.minimal,
)
```

### 2. DetailContentScreen (Renamed from ProfileScreen)

DetailContentScreen digunakan untuk menampilkan konten dengan ProfileSection (profil, program kerja, kontak):

```dart
DetailContentScreen(
  title: 'Profil Pesantren',
  sections: profileSections,
)
// Otomatis menggunakan ContentScreen dengan type: full
```

### 3. MenuNavigationHelper

Helper class untuk navigasi menu berdasarkan detail_lists.dart:

```dart
// Navigasi otomatis berdasarkan nama menu
MenuNavigationHelper.navigateToMenuItem(
  context, 
  'Profil',        // dari menuItemsJenis1 atau menuItemsJenis2
  'Pesantren XYZ'  // kategori title
);
```

Supported menu items:
- **Profil**: Navigate ke DetailContentScreen dengan profil sections
- **Program Kerja**: Navigate ke DetailContentScreen dengan program sections  
- **Kontak**: Navigate ke DetailContentScreen dengan kontak sections
- **Prestasi/Prestasi SDM**: Navigate ke ContentScreen dengan markdown prestasi
- **Others**: Show "Coming Soon" snackbar

### 3. Achievement Detail Screen

Untuk menampilkan detail achievement dengan markdown:

```dart
// Minimal layout (recommended untuk detail)
AchievementDetailScreen(
  achievement: achievementModel,
  showFullLayout: false,
)

// Full layout
AchievementDetailScreen(
  achievement: achievementModel, 
  showFullLayout: true,
)
```

### 4. Navigation dari AchievementItem

```dart
// Otomatis navigate ke detail dengan minimal layout
onTap: () {
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => AchievementDetailScreen(
      achievement: achievement,
      showFullLayout: false,
    ),
  ));
}
```

### 5. Menu Demo Screen

`MenuDemoScreen` mendemonstrasikan penggunaan semua menu dari `detail_lists.dart`:

```dart
// Demo navigasi untuk semua menu items
const MenuDemoScreen() // Lihat implementasi lengkap
```

## Features

### Markdown Styling
- ✅ Headers (H1, H2, H3) dengan color green theme
- ✅ Paragraphs dengan line height optimal
- ✅ Links dengan underline styling
- ✅ Code blocks dengan background abu-abu
- ✅ Blockquotes styling
- ✅ Responsive design dengan ResponsiveWrapper

### Layouts
- **Full Layout**: TopBanner + SectionHeader + Content + BottomBanner
- **Minimal Layout**: Content only (good untuk detail pages)

## Example Usage

Lihat `ExampleMarkdownScreen` untuk demo lengkap kedua tipe layout.

## Files Structure

```
lib/
├── screens/
│   ├── content_screen.dart          # Main ContentScreen (base)
│   ├── detail_content_screen.dart   # For profil, program kerja, kontak  
│   ├── achievement_detail_screen.dart # Achievement detail with markdown
│   ├── example_markdown_screen.dart  # Demo markdown layouts
│   └── menu_demo_screen.dart        # Demo menu navigation
├── core/
│   ├── constants/
│   │   └── detail_lists.dart        # Menu items constants
│   └── utils/
│       └── menu_navigation_helper.dart # Navigation helper
└── widgets/
    ├── achievement_item.dart        # Updated with navigation
    └── detail_layout.dart          # Updated to use MenuNavigationHelper
```