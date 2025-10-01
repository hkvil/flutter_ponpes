import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../repository/santri_repository.dart';
import '../models/models.dart';
import '../data/fallback/santri_fallback.dart';

class AlumniScreen extends StatefulWidget {
  final String title;
  final String lembagaName;

  const AlumniScreen({
    super.key,
    required this.title,
    required this.lembagaName,
  });

  @override
  State<AlumniScreen> createState() => _AlumniScreenState();
}

class _AlumniScreenState extends State<AlumniScreen> {
  final SantriRepository _santriRepo = SantriRepository();

  bool _isLoading = true;
  String? _errorMessage;
  List<Santri> _alumniList = [];
  bool _usesFallback = false;

  String? selectedYear;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAlumniData();
  }

  Future<void> _fetchAlumniData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final slug = _getLembagaSlug(widget.lembagaName);
      final alumniList = await _santriRepo.getAlumniByLembaga(slug);

      setState(() {
        _alumniList = alumniList;
        _usesFallback = false;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching alumni: $e');
      setState(() {
        _alumniList =
            fallbackSantriData.map((json) => Santri.fromJson(json)).toList();
        _usesFallback = true;
        _errorMessage = 'Using offline data';
        _isLoading = false;
      });
    }
  }

  String _getLembagaSlug(String lembagaName) {
    final slug = MenuSlugMapper.getSlugByMenuTitle(lembagaName);
    return slug ?? ''; // Return empty string if no mapping found
  }

  // Static data alumni dengan tahun lulus
  final List<Map<String, dynamic>> alumniData = [
    {
      'nama': 'Ahmad Fauzi',
      'nisn': '1001',
      'tahun_lulus': '2023',
      'kelas_terakhir': 'XII IPA 1',
      'tempat_lahir': 'Bandung',
      'tanggal_lahir': '15 Januari 2005',
      'alamat': 'Jl. Merdeka No. 123, Bandung',
      'pekerjaan': 'Mahasiswa',
      'institusi': 'ITB',
    },
    {
      'nama': 'Siti Nurhaliza',
      'nisn': '1002',
      'tahun_lulus': '2023',
      'kelas_terakhir': 'XII IPS 1',
      'tempat_lahir': 'Jakarta',
      'tanggal_lahir': '22 Maret 2005',
      'alamat': 'Jl. Sudirman No. 456, Jakarta',
      'pekerjaan': 'Wirausaha',
      'institusi': 'Toko Online',
    },
    {
      'nama': 'Muhammad Rizki',
      'nisn': '1003',
      'tahun_lulus': '2022',
      'kelas_terakhir': 'XII IPA 2',
      'tempat_lahir': 'Surabaya',
      'tanggal_lahir': '10 Juli 2004',
      'alamat': 'Jl. Pahlawan No. 789, Surabaya',
      'pekerjaan': 'Mahasiswa',
      'institusi': 'ITS',
    },
    {
      'nama': 'Fatimah Az-Zahra',
      'nisn': '1004',
      'tahun_lulus': '2022',
      'kelas_terakhir': 'XII IPS 2',
      'tempat_lahir': 'Yogyakarta',
      'tanggal_lahir': '5 September 2004',
      'alamat': 'Jl. Malioboro No. 321, Yogyakarta',
      'pekerjaan': 'Guru',
      'institusi': 'SDN 1 Yogyakarta',
    },
    {
      'nama': 'Abdul Rahman',
      'nisn': '1005',
      'tahun_lulus': '2021',
      'kelas_terakhir': 'XII IPA 1',
      'tempat_lahir': 'Medan',
      'tanggal_lahir': '18 November 2003',
      'alamat': 'Jl. Asia No. 654, Medan',
      'pekerjaan': 'Engineer',
      'institusi': 'PT. Teknologi Indonesia',
    },
    {
      'nama': 'Khadijah Binti Ali',
      'nisn': '1006',
      'tahun_lulus': '2021',
      'kelas_terakhir': 'XII IPS 1',
      'tempat_lahir': 'Makassar',
      'tanggal_lahir': '30 April 2003',
      'alamat': 'Jl. Veteran No. 987, Makassar',
      'pekerjaan': 'Dokter',
      'institusi': 'RS. Wahidin Sudirohusodo',
    },
    {
      'nama': 'Ibrahim Khalil',
      'nisn': '1007',
      'tahun_lulus': '2020',
      'kelas_terakhir': 'XII IPA 2',
      'tempat_lahir': 'Padang',
      'tanggal_lahir': '12 Desember 2002',
      'alamat': 'Jl. Minang No. 147, Padang',
      'pekerjaan': 'Programmer',
      'institusi': 'PT. Software Nusantara',
    },
    {
      'nama': 'Aisyah Ummu Salamah',
      'nisn': '1008',
      'tahun_lulus': '2020',
      'kelas_terakhir': 'XII IPS 2',
      'tempat_lahir': 'Semarang',
      'tanggal_lahir': '25 Februari 2002',
      'alamat': 'Jl. Gajah Mada No. 258, Semarang',
      'pekerjaan': 'Pengusaha',
      'institusi': 'CV. Berkah Mandiri',
    },
  ];

  List<dynamic> get filteredAlumni {
    if (_usesFallback) {
      var filtered = alumniData.where((alumni) {
        final matchesSearch = searchQuery.isEmpty ||
            alumni['nama'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            alumni['nisn'].toLowerCase().contains(searchQuery.toLowerCase());

        final matchesYear =
            selectedYear == null || alumni['tahun_lulus'] == selectedYear;

        return matchesSearch && matchesYear;
      }).toList();

      return filtered;
    } else {
      // Using API data (Santri list)
      var filtered = _alumniList.where((alumni) {
        final matchesSearch = searchQuery.isEmpty ||
            alumni.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
            alumni.nisn.toLowerCase().contains(searchQuery.toLowerCase());

        // Note: API Santri may not have tahun_lulus, so we'll skip year filter for API data
        // final matchesYear = selectedYear == null || alumni.tahunLulus == selectedYear;

        return matchesSearch;
      }).toList();

      return filtered;
    }
  }

  List<String> get availableYears {
    final years = alumniData
        .map((alumni) => alumni['tahun_lulus'] as String)
        .toSet()
        .toList();
    years.sort((a, b) => b.compareTo(a)); // Sort descending (newest first)
    return years;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
                  _buildAlumniCount(),
                  Expanded(child: _buildAlumniList()),
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
                    Icons.school_outlined,
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
                        'Data Alumni',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Daftar alumni pesantren',
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
                      hintText: 'Cari nama atau NISN alumni...',
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
          // Year filter
          Row(
            children: [
              const Text(
                'Filter Tahun Lulus:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedYear,
                      hint: const Text('Semua Tahun'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Semua Tahun'),
                        ),
                        ...availableYears
                            .map((year) => DropdownMenuItem<String>(
                                  value: year,
                                  child: Text('Lulus $year'),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlumniCount() {
    final count = filteredAlumni.length;
    final totalCount = alumniData.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Alumni',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (selectedYear != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Lulus Tahun',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  selectedYear!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Text(
              'dari $totalCount alumni',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlumniList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Alumni',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredAlumni.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _fetchAlumniData,
                    child: ListView.builder(
                      itemCount: filteredAlumni.length,
                      itemBuilder: (context, index) {
                        final alumni = filteredAlumni[index];
                        return _buildAlumniCard(alumni, index);
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
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Tidak ada alumni ditemukan',
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

  Widget _buildAlumniCard(dynamic alumni, int index) {
    // Handle both Santri model and Map (fallback data)
    final String nama = alumni is Santri ? alumni.nama : alumni['nama'];
    final String? nisn = alumni is Santri ? alumni.nisn : alumni['nisn'];
    final String? tahunLulus = alumni is Santri ? null : alumni['tahun_lulus'];
    final String? kelasAkhir =
        alumni is Santri ? null : alumni['kelas_terakhir'];

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
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGreen,
          child: Text(
            nama[0],
            style: TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          nama,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'NISN: ${nisn ?? '-'}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            if (tahunLulus != null)
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Lulus ${tahunLulus}',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    kelasAkhir ?? '-',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
          ],
        ),
        children: [
          _buildDetailInfo('Tempat, Tanggal Lahir',
              '${alumni['tempat_lahir']}, ${alumni['tanggal_lahir']}'),
          _buildDetailInfo('Alamat', alumni['alamat']),
          _buildDetailInfo('Pekerjaan Saat Ini', alumni['pekerjaan']),
          _buildDetailInfo('Institusi/Perusahaan', alumni['institusi']),
        ],
      ),
    );
  }

  Widget _buildDetailInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
}
