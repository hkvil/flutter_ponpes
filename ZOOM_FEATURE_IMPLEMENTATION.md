# Implementasi Fitur Zoom pada Galeri

## Perubahan yang Dilakukan

### 1. Package Dependencies
- Menambahkan `photo_view: ^0.15.0` ke `pubspec.yaml`
- Package ini digunakan untuk implementasi zoom dan pan pada gambar

### 2. Modifikasi `lib/screens/galeri_screen.dart`

#### Import Baru
```dart
import 'package:photo_view/photo_view.dart';
```

#### Perubahan pada Icon Zoom
Mengganti icon zoom yang sebelumnya hanya tampilan menjadi interaktif:

```dart
// Sebelum: Icon statis
Icon(Icons.zoom_in, ...)

// Sesudah: InkWell dengan onTap handler
InkWell(
  borderRadius: BorderRadius.circular(20),
  onTap: () {
    final allImageUrls = lembaga!.images
        .map((img) => img.resolvedUrl.isNotEmpty
            ? img.resolvedUrl
            : 'https://picsum.photos/400/300?random=${img.id ?? (lembaga!.images.indexOf(img) + 1)}')
        .toList();
    _openPhotoViewer(context, imageUrl, allImageUrls, index);
  },
  child: Container(...),
)
```

#### Method Baru
1. **`_openPhotoViewer`**: Method untuk membuka photo viewer
2. **`PhotoViewer` Class**: Widget untuk menampilkan gambar dengan fitur zoom

### 3. Fitur yang Ditambahkan

#### Photo Viewer Features
- **Zoom In/Out**: Pinch to zoom atau double tap
- **Pan**: Drag untuk menggeser gambar saat di-zoom
- **Min/Max Scale**: Kontrol batas zoom (0.8x hingga 3x)
- **Hero Animation**: Transisi smooth dari thumbnail ke full view
- **Navigation**: Menampilkan posisi foto (e.g., "Foto 1 dari 5")
- **Full Screen**: Background hitam untuk fokus maksimal

#### User Experience
- Tap icon kaca pembesar pada foto untuk membuka photo viewer
- AppBar dengan tombol back dan informasi posisi foto
- Background hitam untuk kontras maksimal
- Smooth transition animation

## Cara Penggunaan

1. Buka halaman Galeri pada aplikasi
2. Pilih tab "Foto"
3. Tap icon kaca pembesar (zoom_in) di pojok kanan atas foto
4. Photo viewer akan terbuka dengan fitur zoom/pan
5. Gunakan pinch gesture atau double tap untuk zoom
6. Drag untuk menggeser gambar saat di-zoom
7. Tap tombol back untuk kembali ke galeri

## Technical Details

- **Package**: photo_view ^0.15.0
- **Supported Gestures**: Pinch, Pan, Double Tap
- **Scale Range**: 0.8x - 3.0x
- **Background**: Full black untuk fokus maksimal
- **Hero Tags**: Unique tag per foto untuk smooth transition