import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../models/models.dart';
import '../providers/prestasi_provider.dart';

class PrestasiScreen extends StatefulWidget {
  final String title;
  final String lembagaName;
  final bool showOnlyStaff;

  const PrestasiScreen({
    super.key,
    required this.title,
    required this.lembagaName,
    this.showOnlyStaff = false,
  });

  @override
  State<PrestasiScreen> createState() => _PrestasiScreenState();
}

class _PrestasiScreenState extends State<PrestasiScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Prestasi> _prestasiList = [];

  String? selectedYear;
  String? selectedTingkat;
  String selectedType = 'santri'; // 'santri' or 'staff'
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  String get _pageTitle =>
      selectedType == 'staff' ? 'Prestasi Staff' : 'Prestasi Santri';
  String get _pageSubtitle => selectedType == 'staff'
      ? 'Pencapaian dan penghargaan staff'
      : 'Pencapaian dan penghargaan santri';

  @override
  void initState() {
    super.initState();
    // Set default type based on showOnlyStaff parameter
    selectedType = widget.showOnlyStaff ? 'staff' : 'santri';
    // Defer the data fetching to after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPrestasiData();
    });
  }

  Future<void> _fetchPrestasiData(
      {String? tahun, String? tingkat, String? type}) async {
    final prestasiType = type ?? selectedType;
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
        type: prestasiType,
        forceRefresh: true,
      );
      final state = provider.prestasiState(
        slug,
        tahun: tahun,
        tingkat: tingkat,
        type: prestasiType,
      );

      setState(() {
        _prestasiList = prestasiList;
        _errorMessage = state.errorMessage;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching prestasi: $e');
      setState(() {
        _prestasiList = [];
        _errorMessage = 'Gagal memuat data prestasi';
        _isLoading = false;
      });
    }
  }

  String _getLembagaSlug(String lembagaName) {
    final slug = MenuSlugMapper.getSlugByMenuTitle(lembagaName);
    return slug ?? '';
  }

  List<dynamic> get filteredPrestasi {
    // Using API data only
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

  List<String> get availableYears {
    // Get unique years from API data only
    final years =
        _prestasiList.map((prestasi) => prestasi.tahun).toSet().toList();
    years.sort((a, b) => b.compareTo(a));
    return years;
  }

  List<String> get availableTingkat {
    // Get unique tingkat from API data only
    final tingkat =
        _prestasiList.map((prestasi) => prestasi.tingkat).toSet().toList();
    return tingkat..sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 12.0 : 20.0;
    final verticalPadding = isMobile ? 8.0 : 12.0;

    if (_isLoading) {
      return ResponsiveWrapper(
        child: Scaffold(
          backgroundColor: AppColors.primaryGreen,
          body: const Center(
              child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: Column(
          children: [
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(horizontalPadding),
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange.shade700, size: 20),
                    SizedBox(width: verticalPadding),
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
            _buildHeader(horizontalPadding),
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
                    _buildFilters(horizontalPadding),
                    _buildStats(horizontalPadding),
                    Expanded(
                        child: _buildPrestasiList(
                            horizontalPadding, verticalPadding)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double horizontalPadding) {
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
            padding: EdgeInsets.all(horizontalPadding),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pageTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _pageSubtitle,
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

  Widget _buildFilters(double horizontalPadding) {
    return Container(
      padding: EdgeInsets.all(horizontalPadding),
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
                    decoration: InputDecoration(
                      hintText: selectedType == 'staff'
                          ? 'Cari nama lomba, staff, atau bidang...'
                          : 'Cari nama lomba, santri, atau bidang...',
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
          // Type filter (Santri/Staff)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipe:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (!widget.showOnlyStaff) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedType,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'santri',
                                child: Text('Santri'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'staff',
                                child: Text('Staff'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedType = value;
                                });
                                _fetchPrestasiData(
                                    tahun: selectedYear,
                                    tingkat: selectedTingkat,
                                    type: value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
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
                            _fetchPrestasiData(
                                tahun: value, tingkat: selectedTingkat);
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
                            _fetchPrestasiData(
                                tahun: selectedYear, tingkat: value);
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

  Widget _buildStats(double horizontalPadding) {
    final filteredCount = filteredPrestasi.length;

    int juara1Count;
    int nasionalCount;
    int internasionalCount;

    juara1Count =
        filteredPrestasi.where((p) => (p as Prestasi).isJuara1).length;
    nasionalCount =
        filteredPrestasi.where((p) => (p as Prestasi).isNasional).length;
    internasionalCount =
        filteredPrestasi.where((p) => (p as Prestasi).isInternasional).length;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: horizontalPadding / 2),
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

  Widget _buildPrestasiList(double horizontalPadding, double verticalPadding) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
          SizedBox(height: verticalPadding),
          Expanded(
            child: filteredPrestasi.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () => _fetchPrestasiData(
                        tahun: selectedYear,
                        tingkat: selectedTingkat,
                        type: selectedType),
                    child: ListView.builder(
                      itemCount: filteredPrestasi.length,
                      itemBuilder: (context, index) {
                        final prestasi = filteredPrestasi[index];
                        return _buildPrestasiCard(prestasi, index,
                            horizontalPadding, verticalPadding);
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

  Widget _buildPrestasiCard(dynamic prestasi, int index,
      double horizontalPadding, double verticalPadding) {
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
        tilePadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding / 2),
        childrenPadding: EdgeInsets.all(horizontalPadding),
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
          _buildDetailRow(
              selectedType == 'staff' ? 'Nama Staff' : 'Nama Santri',
              namaSantri),
          _buildDetailRow(selectedType == 'staff' ? 'Jabatan' : 'Kelas', kelas),
          const SizedBox(height: 16),
          _buildSertifikatButton(prestasi),
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

  Widget _buildSertifikatButton(dynamic prestasi) {
    Map<String, dynamic>? sertifikat;

    if (prestasi is Prestasi) {
      sertifikat = prestasi.sertifikat;
    } else if (prestasi is Map<String, dynamic>) {
      sertifikat = prestasi['sertifikat'] as Map<String, dynamic>?;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showSertifikatDialog(sertifikat),
        icon: const Icon(Icons.visibility, size: 18),
        label: const Text('Lihat Sertifikat'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _showSertifikatDialog(Map<String, dynamic>? sertifikat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Sertifikat Prestasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: sertifikat != null
                        ? _buildSertifikatImage(sertifikat)
                        : _buildNoSertifikatMessage(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSertifikatImage(Map<String, dynamic> sertifikat) {
    // Get the best available image URL (large > medium > small > original)
    String? imageUrl;
    final formats = sertifikat['formats'] as Map<String, dynamic>?;

    if (formats != null) {
      imageUrl = formats['large']?['url'] ??
          formats['medium']?['url'] ??
          formats['small']?['url'] ??
          sertifikat['url'];
    } else {
      imageUrl = sertifikat['url'];
    }

    if (imageUrl == null) {
      return _buildNoSertifikatMessage();
    }

    // Ensure full URL
    final fullUrl = imageUrl.startsWith('http')
        ? imageUrl
        : '${dotenv.env['API_HOST']!}$imageUrl';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                fullUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Gagal memuat gambar sertifikat',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoSertifikatMessage() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Sertifikat belum tersedia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sertifikat untuk prestasi ini belum diupload ke sistem',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
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
