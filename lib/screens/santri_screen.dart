import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../models/models.dart';
import '../providers/santri_provider.dart';
import '../providers/kelas_provider.dart';
import '../providers/kehadiran_provider.dart';
import '../widgets/detail_dialog.dart';

class SantriScreen extends StatefulWidget {
  final String title;
  final String? lembagaName;

  const SantriScreen({
    super.key,
    required this.title,
    this.lembagaName,
  });

  @override
  State<SantriScreen> createState() => _SantriScreenState();
}

class _SantriScreenState extends State<SantriScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _kehadiranTabInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to tab changes to lazy-load second tab
    _tabController.addListener(() {
      if (_tabController.index == 1 && !_kehadiranTabInitialized) {
        _kehadiranTabInitialized = true;
        // Trigger rebuild so Kehadiran tab can initialize
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Daftar'),
            Tab(text: 'Kehadiran'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DaftarSantriTab(
            title: widget.title,
            lembagaName: widget.lembagaName,
          ),
          KehadiranSantriTab(lembagaName: widget.lembagaName),
        ],
      ),
    );
  }
}

class DaftarSantriTab extends StatefulWidget {
  final String title;
  final String? lembagaName;

  const DaftarSantriTab({
    super.key,
    required this.title,
    this.lembagaName,
  });

  @override
  State<DaftarSantriTab> createState() => _DaftarSantriTabState();
}

class _DaftarSantriTabState extends State<DaftarSantriTab> {
  String selectedKelas = 'Semua Kelas';
  int jumlahSantri = 0;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // State management untuk API
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<Santri> _santriList = [];

  // Track pagination per kelas
  final Map<String, bool> _kelasHasMorePages = {};
  final Map<String, int> _kelasCurrentPage = {};

  // State untuk kelas dari API
  List<String> kelasList = ['Semua Kelas'];

  List<Santri> get filteredSantri {
    // Jika filter kelas aktif (bukan "Semua Kelas"), data sudah difilter dari API
    if (selectedKelas != 'Semua Kelas') {
      // Hanya filter berdasarkan search query
      return _santriList.where((santri) {
        bool matchesSearch = searchQuery.isEmpty ||
            santri.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (santri.alamatLengkap
                .toLowerCase()
                .contains(searchQuery.toLowerCase()));

        return matchesSearch;
      }).toList();
    }

    // Untuk "Semua Kelas", filter berdasarkan kelas dan search query
    var filtered = _santriList.where((santri) {
      // Filter by kelas name
      bool matchesKelas = selectedKelas == 'Semua Kelas' ||
          (santri.kelasAktif == selectedKelas);

      // Filter by search query
      bool matchesSearch = searchQuery.isEmpty ||
          santri.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (santri.alamatLengkap
              .toLowerCase()
              .contains(searchQuery.toLowerCase()));

      return matchesKelas && matchesSearch;
    }).toList();

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Initialize data sequentially to avoid overwhelming server
  Future<void> _initializeData() async {
    await _fetchKelasData(); // Fetch kelas first
    await _fetchSantriData(); // Then fetch santri
  }

  Future<void> _fetchKelasData() async {
    try {
      final lembagaSlug = _getLembagaSlug();
      if (lembagaSlug.isEmpty) {
        // No slug, keep default kelas list
        return;
      }

      final provider = context.read<KelasProvider>();
      final kelasNames = await provider.fetchKelas(
        lembagaSlug,
        pageSize: 100,
        forceRefresh: true,
      );

      setState(() {
        final sortedKelas = [...kelasNames]..sort();
        kelasList = ['Semua Kelas', ...sortedKelas];
      });

      print('✅ [KELAS] Loaded ${kelasList.length - 1} kelas from API');
    } catch (e) {
      print('❌ [KELAS] Error fetching kelas: $e');
      // Keep default kelas list on error
    }
  }

  Future<void> _fetchSantriData(
      {String? kelasFilter, bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get lembaga slug from widget or use default
      final lembagaSlug = _getLembagaSlug();

      if (lembagaSlug.isEmpty) {
        throw Exception('Slug lembaga tidak ditemukan');
      }

      final provider = context.read<SantriProvider>();

      // Jika filter kelas dipilih, gunakan method khusus untuk filter kelas
      if (kelasFilter != null && kelasFilter != 'Semua Kelas') {
        final response = await provider.getSantriByLembagaAndKelas(
          lembagaSlug,
          kelasFilter,
          page: 1,
          pageSize: 20,
        );

        setState(() {
          _santriList = response.data;
          _kelasCurrentPage[kelasFilter] = 1;
          _kelasHasMorePages[kelasFilter] =
              response.meta.page < response.meta.pageCount;
          _isLoading = false;
        });
      } else {
        // Load semua santri untuk "Semua Kelas"
        final santriList = await provider.fetchSantriByLembaga(
          lembagaSlug,
          forceRefresh: forceRefresh,
        );
        final state = provider.santriState(lembagaSlug);

        setState(() {
          _santriList = santriList;
          _isLoading = false;
          _errorMessage = state.errorMessage;
          _updateJumlahSantri();
        });
      }
    } catch (e) {
      print('Error fetching santri data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data santri';
        _updateJumlahSantri();
      });
    }
  }

  Future<void> _loadMoreSantri() async {
    if (_isLoadingMore) return;

    final lembagaSlug = _getLembagaSlug();
    if (lembagaSlug.isEmpty) return;

    final provider = context.read<SantriProvider>();
    setState(() {
      _isLoadingMore = true;
    });

    try {
      // Jika filter kelas aktif, load more untuk kelas tersebut
      if (selectedKelas != 'Semua Kelas') {
        final currentPage = _kelasCurrentPage[selectedKelas] ?? 1;
        if (!(_kelasHasMorePages[selectedKelas] ?? true)) return;

        final response = await provider.getSantriByLembagaAndKelas(
          lembagaSlug,
          selectedKelas,
          page: currentPage + 1,
          pageSize: 20,
        );

        setState(() {
          _santriList.addAll(response.data);
          _kelasCurrentPage[selectedKelas] = response.meta.page;
          _kelasHasMorePages[selectedKelas] =
              response.meta.page < response.meta.pageCount;
        });
      } else {
        // Load more untuk semua kelas
        if (!provider.santriHasMorePages(lembagaSlug)) return;

        await provider.loadMoreSantri(lembagaSlug);
        final state = provider.santriState(lembagaSlug);

        setState(() {
          _santriList = state.data ?? [];
          _errorMessage = state.errorMessage;
          _updateJumlahSantri();
        });
      }
    } catch (e) {
      print('Error loading more santri: $e');
      setState(() {
        _errorMessage = 'Gagal memuat lebih banyak data santri';
      });
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  String _getLembagaSlug() {
    // Use MenuSlugMapper for consistent slug mapping
    if (widget.lembagaName == null) return '';

    final slug = MenuSlugMapper.getSlugByMenuTitle(widget.lembagaName!);
    return slug ?? ''; // Return empty string if no mapping found
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateJumlahSantri() {
    jumlahSantri = filteredSantri.length;
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cari Santri'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama atau alamat santri...',
              prefixIcon: Icon(Icons.search),
            ),
            autofocus: true,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                _updateJumlahSantri();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  _searchController.clear();
                  _updateJumlahSantri();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSantriCard(Santri santri, int index) {
    // Handle Santri model from API
    String nama = santri.namaLengkap;
    String? subtitle = santri.alamatLengkap;
    String? kelasInfo;

    // Tambahkan info kelas
    if (santri.kelasAktif != null && santri.kelasAktif!.isNotEmpty) {
      kelasInfo = santri.kelasAktif;
      if (santri.tahunAjaranAktif != null &&
          santri.tahunAjaranAktif!.isNotEmpty) {
        kelasInfo = '$kelasInfo • ${santri.tahunAjaranAktif}';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Colors.grey.shade400,
            size: 30,
          ),
        ),
        title: Text(
          nama,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            if (kelasInfo != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  kelasInfo,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        onTap: () {
          DetailDialog.show(
            context: context,
            icon: Icons.person,
            title: 'Detail Santri',
            subtitle: santri.kelasAktif ?? 'Kelas tidak tersedia',
            contentSections: [
              // Data Pribadi
              DetailSection(
                title: 'Data Pribadi',
                children: [
                  DetailRow(label: 'Nama Lengkap', value: santri.nama),
                  DetailRow(label: 'NISN', value: santri.nisn),
                  DetailRow(
                    label: 'Jenis Kelamin',
                    value: santri.gender == 'L' ? 'Laki-laki' : 'Perempuan',
                  ),
                  DetailRow(
                    label: 'Tempat, Tanggal Lahir',
                    value:
                        '${santri.tempatLahir}, ${_formatDateString(santri.tanggalLahir)}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Data Orang Tua
              DetailSection(
                title: 'Data Orang Tua',
                children: [
                  DetailRow(label: 'Nama Ayah', value: santri.namaAyah),
                  DetailRow(label: 'Nama Ibu', value: santri.namaIbu),
                ],
              ),
              const SizedBox(height: 20),
              // Alamat
              DetailSection(
                title: 'Alamat',
                children: [
                  DetailRow(label: 'Kelurahan', value: santri.kelurahan),
                  DetailRow(label: 'Kecamatan', value: santri.kecamatan),
                  DetailRow(label: 'Kota', value: santri.kota),
                ],
              ),
              const SizedBox(height: 20),
              // Data Akademik
              DetailSection(
                title: 'Data Akademik',
                children: [
                  DetailRow(label: 'Tahun Masuk', value: santri.tahunMasuk),
                  if (santri.kelasAktif != null)
                    DetailRow(label: 'Kelas Aktif', value: santri.kelasAktif!),
                  if (santri.tahunAjaranAktif != null)
                    DetailRow(
                        label: 'Tahun Ajaran', value: santri.tahunAjaranAktif!),
                  DetailRow(
                    label: 'Status',
                    value: santri.isAlumni ? 'Alumni' : 'Aktif',
                  ),
                  if (santri.tahunLulus != null)
                    DetailRow(label: 'Tahun Lulus', value: santri.tahunLulus!),
                  if (santri.nomorIjazah != null)
                    DetailRow(
                        label: 'Nomor Ijazah', value: santri.nomorIjazah!),
                  if (santri.tahunIjazah != null)
                    DetailRow(
                        label: 'Tahun Ijazah', value: santri.tahunIjazah!),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.school,
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
                          widget.lembagaName ?? 'TAMAN PENDIDIKAN AL-QURAN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'AL-ITTIFAQIAH',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedKelas,
                            dropdownColor: Colors.black,
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            items: kelasList.map((String kelas) {
                              return DropdownMenuItem<String>(
                                value: kelas,
                                child: Text(kelas),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null &&
                                  newValue != selectedKelas) {
                                setState(() {
                                  selectedKelas = newValue;
                                });
                                // Fetch data untuk kelas yang dipilih
                                _fetchSantriData(kelasFilter: newValue);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jumlah\nSantri',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              jumlahSantri.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: _showSearchDialog,
                      child: Container(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey.shade50,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      // Show error message if using fallback
                      if (_errorMessage != null)
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.orange.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh, size: 20),
                                onPressed: _fetchSantriData,
                                color: Colors.orange.shade700,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: filteredSantri.isEmpty
                            ? const Center(
                                child: Text(
                                  'Tidak ada santri di kelas ini',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () => _fetchSantriData(
                                  kelasFilter: selectedKelas != 'Semua Kelas'
                                      ? selectedKelas
                                      : null,
                                  forceRefresh: true,
                                ),
                                child: NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification scrollInfo) {
                                    if (scrollInfo.metrics.pixels ==
                                            scrollInfo
                                                .metrics.maxScrollExtent &&
                                        !_isLoadingMore) {
                                      _loadMoreSantri();
                                    }
                                    return false;
                                  },
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(20),
                                    itemCount: filteredSantri.length +
                                        (_isLoadingMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == filteredSantri.length) {
                                        // Loading indicator at the bottom
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      final santri = filteredSantri[index];
                                      return _buildSantriCard(santri, index);
                                    },
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  String _formatDateString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      return '${date.day} ${months[date.month]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class KehadiranSantriTab extends StatefulWidget {
  final String? lembagaName;

  const KehadiranSantriTab({super.key, this.lembagaName});

  @override
  State<KehadiranSantriTab> createState() => _KehadiranSantriTabState();
}

class _KehadiranSantriTabState extends State<KehadiranSantriTab> {
  bool _isLoading = true;
  String? _errorMessage;
  List<KehadiranSantri> _kehadiranList = [];

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _fetchKehadiranData();
  }

  Future<void> _fetchKehadiranData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final slug = _getLembagaSlug(widget.lembagaName);
      if (slug.isEmpty) {
        throw Exception('Slug lembaga tidak ditemukan');
      }

      final provider = context.read<KehadiranProvider>();
      final kehadiranList = await provider.fetchSantriByLembaga(
        slug,
        forceRefresh: true,
      );
      final state = provider.santriState(slug);

      setState(() {
        _kehadiranList = kehadiranList;
        _errorMessage = state.errorMessage;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching kehadiran: $e');
      setState(() {
        _errorMessage = 'Gagal memuat data kehadiran';
        _isLoading = false;
      });
    }
  }

  String _getLembagaSlug(String? lembagaName) {
    if (lembagaName == null) return '';

    final slug = MenuSlugMapper.getSlugByMenuTitle(lembagaName);
    return slug ?? ''; // Return empty string if no mapping found
  }

  List<dynamic> get filteredKehadiran {
    // Using API data only
    if (startDate == null || endDate == null) {
      return _kehadiranList;
    }

    return _kehadiranList.where((kehadiran) {
      final tanggal = DateTime.parse(kehadiran.tanggal);
      return tanggal.isAfter(startDate!.subtract(const Duration(days: 1))) &&
          tanggal.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });

      // Always fetch data with date range
      await _fetchKehadiranDataByDateRange();
    }
  }

  Future<void> _fetchKehadiranDataByDateRange() async {
    if (startDate == null || endDate == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final slug = _getLembagaSlug(widget.lembagaName);
      if (slug.isEmpty) {
        throw Exception('Slug lembaga tidak ditemukan');
      }

      final provider = context.read<KehadiranProvider>();
      final kehadiranList = await provider.fetchSantriByDateRange(
        slug,
        startDate!,
        endDate!,
        forceRefresh: true,
      );
      final state = provider.santriState(
        slug,
        startDate: startDate,
        endDate: endDate,
      );

      if (state.errorMessage != null && kehadiranList.isEmpty) {
        setState(() {
          _kehadiranList = kehadiranList;
          _errorMessage = state.errorMessage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _kehadiranList = kehadiranList;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching kehadiran by date range: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading date range data';
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      startDate = null;
      endDate = null;
    });

    // Always reload all data
    _fetchKehadiranData();
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Color _getJenisColor(String jenis) {
    // Normalize jenis to uppercase for consistency
    final jenisUpper = jenis.toUpperCase();
    switch (jenisUpper) {
      case 'HADIR':
        return AppColors.primaryGreen;
      case 'IZIN':
        return Colors.blue;
      case 'SAKIT':
        return Colors.orange;
      case 'ALPHA':
        return Colors.red;
      case 'TERLAMBAT':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getJenisIcon(String jenis) {
    // Normalize jenis to uppercase for consistency
    final jenisUpper = jenis.toUpperCase();
    switch (jenisUpper) {
      case 'HADIR':
        return Icons.check_circle;
      case 'IZIN':
        return Icons.info;
      case 'SAKIT':
        return Icons.local_hospital;
      case 'ALPHA':
        return Icons.cancel;
      case 'TERLAMBAT':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  String _formatTanggalKehadiran(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      return _formatDate(date);
    } catch (e) {
      return tanggal;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.grey.shade50,
      child: Column(
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.assignment_turned_in,
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
                            'KEHADIRAN SANTRI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rekap kehadiran harian',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Filter tanggal button
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _selectDateRange,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.date_range,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          if (startDate != null && endDate != null) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _clearDateFilter,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Filter indicator
          if (startDate != null && endDate != null)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lightGreen),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: AppColors.primaryGreen,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      startDate!.isAtSameMomentAs(endDate!)
                          ? 'Tanggal: ${_formatDate(startDate!)}'
                          : 'Periode: ${_formatDate(startDate!)} - ${_formatDate(endDate!)}',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${filteredKehadiran.length} data',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchKehadiranData,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: filteredKehadiran.length,
                itemBuilder: (context, index) {
                  final kehadiran = filteredKehadiran[index];

                  // Handle KehadiranSantri model from API
                  String nama;
                  String tanggal;
                  String jenis;
                  String keterangan;
                  String? avatar;
                  String? kelasInfo;

                  // Handle KehadiranSantri model from API
                  nama = kehadiran.namaSantri;
                  tanggal = _formatTanggalKehadiran(kehadiran.tanggal);
                  jenis = kehadiran.jenis;
                  keterangan = kehadiran.keterangan;
                  avatar = null;
                  kelasInfo = kehadiran.santri?.kelasAktif;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                avatar != null ? NetworkImage(avatar) : null,
                            child: avatar == null
                                ? Icon(
                                    Icons.person,
                                    color: Colors.grey.shade400,
                                    size: 25,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Icon(
                                _getJenisIcon(jenis),
                                color: _getJenisColor(jenis),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (kelasInfo != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                kelasInfo,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            tanggal,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            keterangan,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getJenisColor(jenis),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          jenis.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
