import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../models/models.dart';
import '../providers/prestasi_provider.dart';
import '../data/fallback/prestasi_fallback.dart';

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
  bool _isLoading = true;
  String? _errorMessage;
  List<Prestasi> _prestasiList = [];
  bool _usesFallback = false;

  String? selectedYear;
  String? selectedTingkat;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPrestasiData();
  }

  Future<void> _fetchPrestasiData({String? tahun, String? tingkat}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final slug = _getLembagaSlug(widget.lembagaName);
      final provider = context.read<PrestasiProvider>();
      final prestasiList = await provider.fetchPrestasiByLembaga(
        slug,
        tahun: tahun,
        tingkat: tingkat,
        forceRefresh: true,
      );
      final state = provider.prestasiState(
        slug,
        tahun: tahun,
        tingkat: tingkat,
      );

      if (state.errorMessage != null && prestasiList.isEmpty) {
        setState(() {
          _prestasiList = [];
          _usesFallback = true;
          _errorMessage = state.errorMessage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _prestasiList = prestasiList;
          _usesFallback = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching prestasi: $e');
      // Convert fallback data to empty list since we can't convert Map to Prestasi easily
      // User will need to see the fallback prestasiData in the UI
      setState(() {
        _prestasiList = [];
        _usesFallback = true;
        _errorMessage = 'Using offline data';
        _isLoading = false;
      });
    }
  }

  String _getLembagaSlug(String lembagaName) {
    final slug = MenuSlugMapper.getSlugByMenuTitle(lembagaName);
    return slug ?? '';
  }

  // Use fallback data when API fails
  List<Map<String, dynamic>> get prestasiData => fallbackPrestasiData;

  List<dynamic> get filteredPrestasi {
    if (_usesFallback) {
      var filtered = prestasiData.where((prestasi) {
        final namaLomba = prestasi['namaLomba'] ?? '';
        final namaSantri = prestasi['santri'] ?? prestasi['namaSantri'] ?? '';
        final bidang = prestasi['bidang'] ?? prestasi['keterangan'] ?? '';

        final matchesSearch = searchQuery.isEmpty ||
            namaLomba.toLowerCase().contains(searchQuery.toLowerCase()) ||
            namaSantri.toLowerCase().contains(searchQuery.toLowerCase()) ||
            bidang.toLowerCase().contains(searchQuery.toLowerCase());

        final tahunStr = prestasi['tahun'].toString();
        final matchesYear = selectedYear == null || tahunStr == selectedYear;

        final tingkatStr = (prestasi['tingkat'] ?? '').toString().toUpperCase();
        final selectedTingkatUpper = selectedTingkat?.toUpperCase();
        final matchesTingkat = selectedTingkat == null ||
            tingkatStr == selectedTingkatUpper ||
            tingkatStr.contains(selectedTingkatUpper ?? '');

        return matchesSearch && matchesYear && matchesTingkat;
      }).toList();

      // Sort by year (newest first) then by ranking
      filtered.sort((a, b) {
        final yearA = a['tahun'].toString();
        final yearB = b['tahun'].toString();
        final yearComparison = yearB.compareTo(yearA);
        if (yearComparison != 0) return yearComparison;

        // Sort by ranking (Juara 1, 2, 3)
        final rankA = _getRankingOrder(a['peringkat'] ?? '');
        final rankB = _getRankingOrder(b['peringkat'] ?? '');
        return rankA.compareTo(rankB);
      });

      return filtered;
    } else {
      // Using API data (Prestasi list) - filter already done in API for year and tingkat
      var filtered = _prestasiList.where((prestasi) {
        final matchesSearch = searchQuery.isEmpty ||
            prestasi.namaLomba
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            prestasi.namaSantri
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            prestasi.bidang.toLowerCase().contains(searchQuery.toLowerCase());

        return matchesSearch;
      }).toList();

      // Sort by year (newest first) then by ranking
      filtered.sort((a, b) {
        final yearComparison = b.tahun.compareTo(a.tahun);
        if (yearComparison != 0) return yearComparison;
        return a.rankingOrder.compareTo(b.rankingOrder);
      });

      return filtered;
    }
  }

  int _getRankingOrder(String peringkat) {
    if (peringkat.contains('1')) return 1;
    if (peringkat.contains('2')) return 2;
    if (peringkat.contains('3')) return 3;
    return 4;
  }

  List<String> get availableYears {
    if (_usesFallback) {
      final years = prestasiData
          .map((prestasi) => prestasi['tahun'].toString())
          .toSet()
          .toList();
      years.sort((a, b) => b.compareTo(a)); // Sort descending (newest first)
      return years;
    } else {
      // Get unique years from API data
      final years =
          _prestasiList.map((prestasi) => prestasi.tahun).toSet().toList();
      years.sort((a, b) => b.compareTo(a));
      return years;
    }
  }

  List<String> get availableTingkat {
    if (_usesFallback) {
      final tingkat = prestasiData
          .map((prestasi) => (prestasi['tingkat'] as String?) ?? '')
          .where((t) => t.isNotEmpty)
          .toSet()
          .toList();
      return tingkat..sort();
    } else {
      // Get unique tingkat from API data
      final tingkat =
          _prestasiList.map((prestasi) => prestasi.tingkat).toSet().toList();
      return tingkat..sort();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body:
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Column(
        children: [
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                          color: Colors.orange.shade900, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
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
                            if (!_usesFallback) {
                              _fetchPrestasiData(
                                  tahun: value, tingkat: selectedTingkat);
                            }
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
                            if (!_usesFallback) {
                              _fetchPrestasiData(
                                  tahun: selectedYear, tingkat: value);
                            }
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

    int juara1Count;
    int nasionalCount;
    int internasionalCount;

    if (_usesFallback) {
      juara1Count =
          filteredPrestasi.where((p) => p['peringkat'].contains('1')).length;
      nasionalCount =
          filteredPrestasi.where((p) => p['tingkat'] == 'Nasional').length;
      internasionalCount =
          filteredPrestasi.where((p) => p['tingkat'] == 'Internasional').length;
    } else {
      juara1Count =
          filteredPrestasi.where((p) => (p as Prestasi).isJuara1).length;
      nasionalCount =
          filteredPrestasi.where((p) => (p as Prestasi).isNasional).length;
      internasionalCount =
          filteredPrestasi.where((p) => (p as Prestasi).isInternasional).length;
    }

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
                : RefreshIndicator(
                    onRefresh: () => _fetchPrestasiData(
                        tahun: selectedYear, tingkat: selectedTingkat),
                    child: ListView.builder(
                      itemCount: filteredPrestasi.length,
                      itemBuilder: (context, index) {
                        final prestasi = filteredPrestasi[index];
                        return _buildPrestasiCard(prestasi, index);
                      },
                    ),
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

  Widget _buildPrestasiCard(dynamic prestasi, int index) {
    // Handle both Prestasi model and Map (fallback data)
    String namaLomba,
        bidang,
        penyelenggara,
        tingkat,
        peringkat,
        tahun,
        namaSantri,
        kelas;

    if (prestasi is Prestasi) {
      namaLomba = prestasi.namaLomba;
      bidang = prestasi.bidang;
      penyelenggara = prestasi.penyelenggara;
      tingkat = prestasi.tingkat;
      peringkat = prestasi.peringkat;
      tahun = prestasi.tahun;
      namaSantri = prestasi.namaSantri;
      kelas = prestasi.kelasSantri;
    } else {
      // Fallback Map data
      namaLomba = prestasi['namaLomba'] ?? '-';
      bidang = prestasi['bidang'] ?? prestasi['keterangan'] ?? '-';
      penyelenggara = prestasi['penyelenggara'] ?? '-';
      tingkat = prestasi['tingkat'] ?? '-';
      peringkat = prestasi['peringkat'] ?? '-';
      tahun = prestasi['tahun']?.toString() ?? '-';
      namaSantri = prestasi['santri'] ?? prestasi['namaSantri'] ?? '-';
      kelas = prestasi['kelas'] ?? '-';
    }

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
            color: _getRankingColor(peringkat).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getRankingIcon(peringkat),
            color: _getRankingColor(peringkat),
            size: 20,
          ),
        ),
        title: Text(
          namaLomba,
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
                    color: _getRankingColor(peringkat),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    peringkat,
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
                    color: _getTingkatColor(tingkat).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tingkat,
                    style: TextStyle(
                      color: _getTingkatColor(tingkat),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  tahun,
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
              '$namaSantri - $kelas',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        children: [
          _buildDetailRow('Bidang', bidang),
          _buildDetailRow('Penyelenggara', penyelenggara),
          _buildDetailRow('Tingkat', tingkat),
          _buildDetailRow('Peringkat', peringkat),
          _buildDetailRow('Tahun', tahun),
          _buildDetailRow('Nama Santri', namaSantri),
          _buildDetailRow('Kelas', kelas),
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
      case 'internasional':
        return Colors.purple.shade600;
      case 'nasional':
        return Colors.red.shade600;
      case 'provinsi':
        return Colors.blue.shade600;
      case 'kabupaten/kota':
      case 'kabupaten':
      case 'kota':
        return AppColors.primaryGreen;
      case 'kecamatan':
        return Colors.orange.shade600;
      case 'kelurahan':
        return Colors.teal.shade600;
      case 'sekolah':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
