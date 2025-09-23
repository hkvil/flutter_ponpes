import 'package:flutter/material.dart';
import 'content_screen.dart';

class ExampleMarkdownScreen extends StatelessWidget {
  const ExampleMarkdownScreen({super.key});

  // Contoh markdown content
  static const String _sampleMarkdown = '''
# Sejarah Pondok Pesantren Al-Hikam

## Latar Belakang

Pondok Pesantren Al-Hikam didirikan pada tahun **1985** oleh **KH. Ahmad Sholeh** dengan visi mencetak generasi Islam yang berakhlaq mulia dan berwawasan luas.

### Visi dan Misi

#### Visi
Menjadi lembaga pendidikan Islam terdepan yang menghasilkan generasi Muslim yang:
- Berakhlaq mulia
- Berwawasan luas  
- Menguasai ilmu agama dan umum

#### Misi
1. Menyelenggarakan pendidikan Islam yang berkualitas
2. Mengembangkan potensi santri secara optimal
3. Menanamkan nilai-nilai islami dalam kehidupan sehari-hari

## Prestasi Terbaru

> "Prestasi adalah hasil dari kerja keras, doa, dan ridha Allah SWT"

Beberapa prestasi yang telah diraih:

- 🏆 **Juara 1** Lomba Tahfidz Al-Quran tingkat Nasional 2024
- 🥈 **Juara 2** Olimpiade Sains Nasional 2024
- 🥉 **Juara 3** Festival Seni Islami se-Jawa Timur

### Fasilitas

Pondok Pesantren Al-Hikam dilengkapi dengan fasilitas modern:

```
- Masjid dengan kapasitas 1000 jamaah
- Asrama putra dan putri
- Perpustakaan digital
- Laboratorium komputer
- Lapangan olahraga
```

### Kontak

**Alamat**: Jl. Pesantren No. 123, Malang, Jawa Timur  
**Telepon**: (0341) 123-4567  
**Website**: [www.ponpes-alhikam.ac.id](https://www.ponpes-alhikam.ac.id)

---

*Barakallahu fiikum*
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contoh Markdown Screen'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Pilih tipe layout untuk melihat markdown content:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Button untuk Full Layout
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContentScreen(
                      title: 'Sejarah Pesantren',
                      markdownContent: _sampleMarkdown,
                      type: ContentScreenType.full,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.dashboard),
              label: const Text('Full Layout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),

            const SizedBox(height: 16),

            // Button untuk Minimal Layout
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContentScreen(
                      title: 'Sejarah Pesantren',
                      markdownContent: _sampleMarkdown,
                      type: ContentScreenType.minimal,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.article),
              label: const Text('Minimal Layout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),

            const SizedBox(height: 32),

            // Info text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Full Layout: Banner + Header + Markdown\n'
                'Minimal Layout: Hanya Markdown',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
