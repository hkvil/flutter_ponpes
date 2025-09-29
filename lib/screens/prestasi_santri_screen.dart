import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PrestasiSantriScreen extends StatefulWidget {
  final String title;
  final String lembagaName;

  const PrestasiSantriScreen({
    super.key,
    required this.title,
    required this.lembagaName,
  });

  @override
  State<PrestasiSantriScreen> createState() => _PrestasiSantriScreenState();
}

class _PrestasiSantriScreenState extends State<PrestasiSantriScreen> {
  String? selectedYear;
  String? selectedTingkat;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Static data prestasi santri
  final List<Map<String, dynamic>> prestasiData = [
    {
      'namaLomba': 'Olimpiade Matematika Nasional',
      'bidang': 'Matematika',
      'tingkat': 'Nasional',
      'penyelenggara': 'Kemendikbud RI',
      'peringkat': 'Juara 1',
      'tahun': '2024',
      'namaSantri': 'Ahmad Fauzi',
      'kelas': 'XII IPA 1',
    },
    {
      'namaLomba': 'Lomba Tahfidz Al-Quran',
      'bidang': 'Agama',
      'tingkat': 'Provinsi',
      'penyelenggara': 'Kemenag Jawa Barat',
      'peringkat': 'Juara 2',
      'tahun': '2024',
      'namaSantri': 'Siti Nurhaliza',
      'kelas': 'XI IPS 1',
    },
    {
      'namaLomba': 'Kompetisi Sains Nasional (KSN)',
      'bidang': 'Fisika',
      'tingkat': 'Nasional',
      'penyelenggara': 'Kemendikbud RI',
      'peringkat': 'Juara 3',
      'tahun': '2023',
      'namaSantri': 'Muhammad Rizki',
      'kelas': 'XII IPA 2',
    },
    {
      'namaLomba': 'Festival Nasyid Pelajar',
      'bidang': 'Seni',
      'tingkat': 'Kabupaten/Kota',
      'penyelenggara': 'OSIS SMA Se-Kabupaten',
      'peringkat': 'Juara 1',
      'tahun': '2024',
      'namaSantri': 'Fatimah Az-Zahra',
      'kelas': 'X IPS 2',
    },
    {
      'namaLomba': 'Lomba Debat Bahasa Arab',
      'bidang': 'Bahasa',
      'tingkat': 'Internasional',
      'penyelenggara':
          'Islamic World Educational, Scientific and Cultural Organization (ISESCO)',
      'peringkat': 'Juara 2',
      'tahun': '2023',
      'namaSantri': 'Abdul Rahman',
      'kelas': 'XI IPA 1',
    },
    {
      'namaLomba': 'Olimpiade Biologi',
      'bidang': 'Biologi',
      'tingkat': 'Provinsi',
      'penyelenggara': 'Dinas Pendidikan Jabar',
      'peringkat': 'Juara 3',
      'tahun': '2024',
      'namaSantri': 'Khadijah Binti Ali',
      'kelas': 'XI IPA 2',
    },
    {
      'namaLomba': 'Lomba Pidato 3 Bahasa',
      'bidang': 'Bahasa',
      'tingkat': 'Kecamatan',
      'penyelenggara': 'Forum Komunikasi Pondok Pesantren Kecamatan Cijeruk',
      'peringkat': 'Juara 1',
      'tahun': '2023',
      'namaSantri': 'Ibrahim Khalil',
      'kelas': 'XII IPS 1',
    },
    {
      'namaLomba': 'Lomba Kaligrafi Al-Quran',
      'bidang': 'Seni',
      'tingkat': 'Kelurahan',
      'penyelenggara': 'Takmir Masjid Al-Hidayah',
      'peringkat': 'Juara 2',
      'tahun': '2023',
      'namaSantri': 'Aisyah Ummu Salamah',
      'kelas': 'X IPA 1',
    },
    {
      'namaLomba': 'Lomba Tartil Al-Quran',
      'bidang': 'Agama',
      'tingkat': 'Sekolah',
      'penyelenggara': 'MA Al-Ittifaqiah',
      'peringkat': 'Juara 1',
      'tahun': '2024',
      'namaSantri': 'Umar bin Khattab',
      'kelas': 'X IPA 3',
    },
  ];

  List<Map<String, dynamic>> get filteredPrestasi {
    var filtered = prestasiData.where((prestasi) {
      final matchesSearch = searchQuery.isEmpty ||
          prestasi['namaLomba']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          prestasi['namaSantri']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          prestasi['bidang'].toLowerCase().contains(searchQuery.toLowerCase());

      final matchesYear =
          selectedYear == null || prestasi['tahun'] == selectedYear;
      final matchesTingkat =
          selectedTingkat == null || prestasi['tingkat'] == selectedTingkat;

      return matchesSearch && matchesYear && matchesTingkat;
    }).toList();

    // Sort by year (newest first) then by ranking
    filtered.sort((a, b) {
      final yearComparison = b['tahun'].compareTo(a['tahun']);
      if (yearComparison != 0) return yearComparison;

      // Sort by ranking (Juara 1, 2, 3)
      final rankA = _getRankingOrder(a['peringkat']);
      final rankB = _getRankingOrder(b['peringkat']);
      return rankA.compareTo(rankB);
    });

    return filtered;
  }

  int _getRankingOrder(String peringkat) {
    if (peringkat.contains('1')) return 1;
    if (peringkat.contains('2')) return 2;
    if (peringkat.contains('3')) return 3;
    return 4;
  }

  List<String> get availableYears {
    final years = prestasiData
        .map((prestasi) => prestasi['tahun'] as String)
        .toSet()
        .toList();
    years.sort((a, b) => b.compareTo(a)); // Sort descending (newest first)
    return years;
  }

  List<String> get availableTingkat {
    final tingkat = prestasiData
        .map((prestasi) => prestasi['tingkat'] as String)
        .toSet()
        .toList();
    return tingkat..sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  _buildFilters(),
                  _buildStats(),
                  Expanded(child: _buildPrestasiList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: AppColors.primaryGreen,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prestasi Santri',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Pencapaian dan penghargaan santri',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search bar
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari nama lomba, santri, atau bidang...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: searchQuery.isNotEmpty
                      ? Colors.blue.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.search,
                  color: searchQuery.isNotEmpty
                      ? Colors.blue.shade600
                      : Colors.grey.shade600,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Filter dropdowns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tahun:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedYear,
                          hint: const Text('Semua'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Semua'),
                            ),
                            ...availableYears
                                .map((year) => DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tingkat:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTingkat,
                          hint: const Text('Semua'),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Semua'),
                            ),
                            ...availableTingkat
                                .map((tingkat) => DropdownMenuItem<String>(
                                      value: tingkat,
                                      child: Text(tingkat),
                                    )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedTingkat = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final filteredCount = filteredPrestasi.length;
    final juara1Count =
        filteredPrestasi.where((p) => p['peringkat'].contains('1')).length;
    final nasionalCount =
        filteredPrestasi.where((p) => p['tingkat'] == 'Nasional').length;
    final internasionalCount =
        filteredPrestasi.where((p) => p['tingkat'] == 'Internasional').length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Baris pertama
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Prestasi',
                  '$filteredCount',
                  Icons.emoji_events,
                  AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Juara 1',
                  '$juara1Count',
                  Icons.star,
                  Colors.amber.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Baris kedua
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Nasional',
                  '$nasionalCount',
                  Icons.flag,
                  Colors.red.shade600,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Internasional',
                  '$internasionalCount',
                  Icons.public,
                  Colors.blue.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPrestasiList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Prestasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredPrestasi.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredPrestasi.length,
                    itemBuilder: (context, index) {
                      final prestasi = filteredPrestasi[index];
                      return _buildPrestasiCard(prestasi, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Tidak ada prestasi ditemukan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Coba ubah kriteria pencarian',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrestasiCard(Map<String, dynamic> prestasi, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        childrenPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getRankingColor(prestasi['peringkat']).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getRankingIcon(prestasi['peringkat']),
            color: _getRankingColor(prestasi['peringkat']),
            size: 20,
          ),
        ),
        title: Text(
          prestasi['namaLomba'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getRankingColor(prestasi['peringkat']),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    prestasi['peringkat'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        _getTingkatColor(prestasi['tingkat']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    prestasi['tingkat'],
                    style: TextStyle(
                      color: _getTingkatColor(prestasi['tingkat']),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  prestasi['tahun'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '${prestasi['namaSantri']} - ${prestasi['kelas']}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        children: [
          _buildDetailRow('Bidang', prestasi['bidang']),
          _buildDetailRow('Penyelenggara', prestasi['penyelenggara']),
          _buildDetailRow('Tingkat', prestasi['tingkat']),
          _buildDetailRow('Peringkat', prestasi['peringkat']),
          _buildDetailRow('Tahun', prestasi['tahun']),
          _buildDetailRow('Nama Santri', prestasi['namaSantri']),
          _buildDetailRow('Kelas', prestasi['kelas']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankingColor(String peringkat) {
    if (peringkat.contains('1')) return Colors.amber.shade600; // Gold
    if (peringkat.contains('2')) return Colors.grey.shade600; // Silver
    if (peringkat.contains('3')) return Colors.orange.shade700; // Bronze
    return Colors.blue.shade600;
  }

  IconData _getRankingIcon(String peringkat) {
    if (peringkat.contains('1')) return Icons.emoji_events; // Trophy
    if (peringkat.contains('2')) return Icons.star; // Star
    if (peringkat.contains('3')) return Icons.star_half; // Half star
    return Icons.star_outline;
  }

  Color _getTingkatColor(String tingkat) {
    switch (tingkat.toLowerCase()) {
      case 'nasional':
        return Colors.red.shade600;
      case 'provinsi':
        return Colors.blue.shade600;
      case 'kabupaten':
        return AppColors.primaryGreen;
      default:
        return Colors.grey.shade600;
    }
  }
}
