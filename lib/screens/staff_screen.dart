import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../models/staff.dart';
import '../models/kehadiran_guru.dart';
import '../providers/staff_provider.dart';
import '../providers/kehadiran_provider.dart';
import '../data/fallback/staff_fallback.dart';
import '../data/fallback/kehadiran_fallback.dart';

class StaffScreen extends StatefulWidget {
  final String title;
  final String? lembagaName;

  const StaffScreen({
    super.key,
    required this.title,
    this.lembagaName,
  });

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen>
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
        backgroundColor: Colors.blue,
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
          DaftarStaffTab(
            title: widget.title,
            lembagaName: widget.lembagaName,
          ),
          KehadiranStaffTab(lembagaName: widget.lembagaName),
        ],
      ),
    );
  }
}

class DaftarStaffTab extends StatefulWidget {
  final String title;
  final String? lembagaName;

  const DaftarStaffTab({
    super.key,
    required this.title,
    this.lembagaName,
  });

  @override
  State<DaftarStaffTab> createState() => _DaftarStaffTabState();
}

class _DaftarStaffTabState extends State<DaftarStaffTab> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Staff> _staffList = [];
  bool _usesFallback = false;

  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStaffData();
  }

  Future<void> _fetchStaffData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final slug = _getLembagaSlug(widget.lembagaName);
      if (slug.isEmpty) {
        throw Exception('Slug lembaga tidak ditemukan');
      }

      final provider = context.read<StaffProvider>();
      final staffList = await provider.fetchStaffByLembaga(
        slug,
        forceRefresh: true,
      );
      final state = provider.staffState(slug);

      if (state.errorMessage != null && staffList.isEmpty) {
        setState(() {
          _staffList =
              fallbackStaffData.map((json) => Staff.fromJson(json)).toList();
          _usesFallback = true;
          _errorMessage = state.errorMessage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _staffList = staffList;
          _usesFallback = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching staff: $e');
      // Use fallback data
      setState(() {
        _staffList =
            fallbackStaffData.map((json) => Staff.fromJson(json)).toList();
        _usesFallback = true;
        _errorMessage = 'Using offline data';
        _isLoading = false;
      });
    }
  }

  String _getLembagaSlug(String? lembagaName) {
    if (lembagaName == null) return '';

    final slug = MenuSlugMapper.getSlugByMenuTitle(lembagaName);
    return slug ?? ''; // Return empty string if no mapping found
  }

  Widget _buildStaffCard(dynamic staffData) {
    // Handle both API Staff object and fallback Map
    String nama;
    String? subtitle;
    String? avatarUrl;
    String? tugasInfo;
    String? nipInfo;

    if (staffData is Staff) {
      // API data
      nama = staffData.nama;
      subtitle = staffData.kategoriPersonil;
      avatarUrl = null;
      tugasInfo = staffData.keteranganTugas;
      nipInfo = staffData.nip;
    } else if (staffData is Map<String, dynamic>) {
      // Fallback data
      nama = staffData['nama'] ?? '';
      subtitle = staffData['subtitle'] ?? 'Staff';
      avatarUrl = staffData['avatar'];
      tugasInfo = null;
      nipInfo = null;
    } else {
      nama = 'Unknown';
      subtitle = null;
      avatarUrl = null;
      tugasInfo = null;
      nipInfo = null;
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
          backgroundColor: Colors.blue.shade100,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
          child: avatarUrl == null
              ? Icon(
                  Icons.person,
                  color: Colors.blue.shade700,
                  size: 30,
                )
              : null,
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
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
            if (tugasInfo != null && tugasInfo.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                tugasInfo,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (nipInfo != null && nipInfo.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  'NIP: $nipInfo',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          if (staffData is Map<String, dynamic>) {
            _showStaffDetail(staffData);
          } else if (staffData is Staff) {
            _showStaffDetailFromModel(staffData);
          }
        },
      ),
    );
  }

  // Data static Staff
  final List<Map<String, dynamic>> staffData = [
    {
      'nama': 'Dr. Ahmad Fauzi, M.Pd',
      'subtitle': 'Kepala Madrasah',
      'avatar': 'https://i.pravatar.cc/150?img=51',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '15 Juni 1975',
      'gender': 'Laki-laki',
      'agama': 'Islam',
      'noTelephone': '0812-3456-7890',
      'namaIbu': 'Siti Aminah',
      'nik': '1671051506750001',
      'kategoriPersonil': 'Tenaga Pendidik',
      'keteranganTugas': 'Kepala Madrasah, Mengajar Al-Quran',
      'statusKepegawaian': 'Tetap',
      'mulaiTugas': '01 Januari 2005',
      'aktif': true,
      'pendidikanTerakhir': 'S2',
      'lulusan': 'UIN Raden Fatah Palembang',
      'statusPNS': 'PNS',
      'statusGuruTetap': 'Guru Tetap',
    },
    {
      'nama': 'Ustadz Muhammad Hakim, S.Pd.I',
      'subtitle': 'Guru Al-Quran',
      'avatar': 'https://i.pravatar.cc/150?img=52',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '22 Agustus 1985',
      'gender': 'Laki-laki',
      'agama': 'Islam',
      'noTelephone': '0813-4567-8901',
      'namaIbu': 'Fatimah',
      'nik': '1671052208850001',
      'kategoriPersonil': 'Tenaga Pendidik',
      'keteranganTugas': 'Mengajar Tahfidz Al-Quran, Tajwid',
      'statusKepegawaian': 'Tetap',
      'mulaiTugas': '15 Agustus 2010',
      'aktif': true,
      'pendidikanTerakhir': 'S1',
      'lulusan': 'IAIN Raden Fatah Palembang',
      'statusPNS': 'Non PNS',
      'statusGuruTetap': 'Guru Tetap',
    },
    {
      'nama': 'Ustadzah Khadijah, S.Pd',
      'subtitle': 'Guru Kelas',
      'avatar': 'https://i.pravatar.cc/150?img=44',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '10 Maret 1988',
      'gender': 'Perempuan',
      'agama': 'Islam',
      'noTelephone': '0814-5678-9012',
      'namaIbu': 'Maryam',
      'nik': '1671055003880001',
      'kategoriPersonil': 'Tenaga Pendidik',
      'keteranganTugas': 'Guru Kelas 1, Mengajar Bahasa Arab',
      'statusKepegawaian': 'Tetap',
      'mulaiTugas': '01 Juli 2012',
      'aktif': true,
      'pendidikanTerakhir': 'S1',
      'lulusan': 'UNSRI Palembang',
      'statusPNS': 'Non PNS',
      'statusGuruTetap': 'Guru Tetap',
    },
    {
      'nama': 'Ahmad Subhan, S.Kom',
      'subtitle': 'Staff Administrasi',
      'avatar': 'https://i.pravatar.cc/150?img=53',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '25 September 1990',
      'gender': 'Laki-laki',
      'agama': 'Islam',
      'noTelephone': '0815-6789-0123',
      'namaIbu': 'Zainab',
      'nik': '1671052509900001',
      'kategoriPersonil': 'Tenaga Kependidikan',
      'keteranganTugas': 'Administrasi Umum, IT Support',
      'statusKepegawaian': 'Kontrak',
      'mulaiTugas': '01 Februari 2015',
      'aktif': true,
      'pendidikanTerakhir': 'S1',
      'lulusan': 'STMIK MDP Palembang',
      'statusPNS': 'Non PNS',
      'statusGuruTetap': 'Non Guru',
    },
  ];

  List<dynamic> get filteredStaff {
    if (searchQuery.isEmpty) {
      return _usesFallback ? staffData : _staffList;
    }

    if (_usesFallback) {
      return staffData
          .where((staff) =>
              staff['nama']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              staff['subtitle']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              staff['kategoriPersonil']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      return _staffList
          .where((staff) =>
              staff.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
              staff.kategoriPersonil
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cari Staff'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama atau jabatan...',
              prefixIcon: Icon(Icons.search),
            ),
            autofocus: true,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  _searchController.clear();
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

  void _showStaffDetail(Map<String, dynamic> staff) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(staff['avatar']),
                        child: staff['avatar'] == null
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detail Staff',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              staff['subtitle'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailSection('Data Pribadi', [
                          _buildDetailRow('Nama Lengkap', staff['nama']),
                          _buildDetailRow('Tempat Lahir', staff['tempatLahir']),
                          _buildDetailRow(
                              'Tanggal Lahir', staff['tanggalLahir']),
                          _buildDetailRow('Jenis Kelamin', staff['gender']),
                          _buildDetailRow('Agama', staff['agama']),
                          _buildDetailRow('No. Telepon', staff['noTelephone']),
                          _buildDetailRow('NIK', staff['nik']),
                        ]),
                        const SizedBox(height: 20),
                        _buildDetailSection('Data Kepegawaian', [
                          _buildDetailRow(
                              'Kategori Personil', staff['kategoriPersonil']),
                          _buildDetailRow(
                              'Keterangan Tugas', staff['keteranganTugas']),
                          _buildDetailRow(
                              'Status Kepegawaian', staff['statusKepegawaian']),
                          _buildDetailRow('Mulai Tugas', staff['mulaiTugas']),
                          _buildDetailRow('Status Aktif',
                              staff['aktif'] ? 'Aktif' : 'Tidak Aktif'),
                          _buildDetailRow('Status PNS', staff['statusPNS']),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStaffDetailFromModel(Staff staff) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detail Staff',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (staff.kategoriPersonil.isNotEmpty)
                              Text(
                                staff.kategoriPersonil,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Data Pribadi
                        _buildDetailSection('Data Pribadi', [
                          _buildDetailRow('Nama Lengkap', staff.nama),
                          _buildDetailRow('NIP', staff.nip),
                          _buildDetailRow('NIK', staff.nik),
                          _buildDetailRow('Tempat, Tanggal Lahir',
                              '${staff.tempatLahir}, ${_formatDateString(staff.tanggalLahir)}'),
                          _buildDetailRow('Jenis Kelamin',
                              staff.gender == 'L' ? 'Laki-laki' : 'Perempuan'),
                          _buildDetailRow('Agama', staff.agama),
                          if (staff.noTelepon != null &&
                              staff.noTelepon!.isNotEmpty)
                            _buildDetailRow('No. Telepon', staff.noTelepon!),
                          if (staff.namaIbu != null &&
                              staff.namaIbu!.isNotEmpty)
                            _buildDetailRow('Nama Ibu', staff.namaIbu!),
                        ]),
                        const SizedBox(height: 20),
                        // Data Kepegawaian
                        _buildDetailSection('Data Kepegawaian', [
                          _buildDetailRow(
                              'Kategori Personil', staff.kategoriPersonil),
                          if (staff.keteranganTugas.isNotEmpty)
                            _buildDetailRow(
                                'Keterangan Tugas', staff.keteranganTugas),
                          if (staff.statusKepegawaian != null &&
                              staff.statusKepegawaian!.isNotEmpty)
                            _buildDetailRow(
                                'Status Kepegawaian', staff.statusKepegawaian!),
                          if (staff.mulaiTugas != null)
                            _buildDetailRow('Mulai Tugas',
                                _formatDateString(staff.mulaiTugas!)),
                          _buildDetailRow(
                              'Status', staff.aktif ? 'Aktif' : 'Tidak Aktif'),
                        ]),
                        const SizedBox(height: 20),
                        // Data Pendidikan
                        _buildDetailSection('Data Pendidikan', [
                          if (staff.pendidikanTerakhir != null &&
                              staff.pendidikanTerakhir!.isNotEmpty)
                            _buildDetailRow('Pendidikan Terakhir',
                                staff.pendidikanTerakhir!),
                          if (staff.lulusan != null &&
                              staff.lulusan!.isNotEmpty)
                            _buildDetailRow('Lulusan', staff.lulusan!),
                          if (staff.statusPNS != null &&
                              staff.statusPNS!.isNotEmpty)
                            _buildDetailRow('Status PNS', staff.statusPNS!),
                          if (staff.statusGuruTetap != null &&
                              staff.statusGuruTetap!.isNotEmpty)
                            _buildDetailRow(
                                'Status Guru', staff.statusGuruTetap!),
                          if (staff.sertifikasi != null &&
                              staff.sertifikasi!.isNotEmpty)
                            _buildDetailRow('Sertifikasi', staff.sertifikasi!),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
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
                    style:
                        TextStyle(color: Colors.orange.shade900, fontSize: 12),
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
            color: Colors.blue,
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
                    child: const Icon(
                      Icons.people,
                      color: Colors.blue,
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
                        const Text(
                          'AL-ITTIFAQIAH',
                          style: TextStyle(
                            color: Colors.white70,
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
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Staff',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              filteredStaff.length.toString(),
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
          child: Column(
            children: [
              if (searchQuery.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.blue.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mencari: "$searchQuery"',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.blue.shade600,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade50,
                  child: filteredStaff.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada data Staff',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchStaffData,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: filteredStaff.length,
                            itemBuilder: (context, index) {
                              final staff = filteredStaff[index];
                              return _buildStaffCard(staff);
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KehadiranStaffTab extends StatefulWidget {
  final String? lembagaName;

  const KehadiranStaffTab({super.key, this.lembagaName});

  @override
  State<KehadiranStaffTab> createState() => _KehadiranStaffTabState();
}

class _KehadiranStaffTabState extends State<KehadiranStaffTab> {
  bool _isLoading = true;
  String? _errorMessage;
  List<KehadiranGuru> _kehadiranList = [];
  bool _usesFallback = false;

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
      final kehadiranList = await provider.fetchGuruByLembaga(
        slug,
        forceRefresh: true,
      );
      final state = provider.guruState(slug);

      if (state.errorMessage != null && kehadiranList.isEmpty) {
        setState(() {
          _kehadiranList = fallbackKehadiranGuruData
              .map((json) => KehadiranGuru.fromJson(json))
              .toList();
          _usesFallback = true;
          _errorMessage = state.errorMessage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _kehadiranList = kehadiranList;
          _usesFallback = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching kehadiran guru: $e');
      setState(() {
        _kehadiranList = fallbackKehadiranGuruData
            .map((json) => KehadiranGuru.fromJson(json))
            .toList();
        _usesFallback = true;
        _errorMessage = 'Using offline data';
        _isLoading = false;
      });
    }
  }

  String _getLembagaSlug(String? lembagaName) {
    if (lembagaName == null) return '';

    final slug = MenuSlugMapper.getSlugByMenuTitle(lembagaName);
    return slug ?? ''; // Return empty string if no mapping found
  }

  // Data static kehadiran staff
  final List<Map<String, dynamic>> kehadiranData = [
    {
      'nama': 'Dr. Ahmad Fauzi, M.Pd',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=51',
    },
    {
      'nama': 'Ustadz Muhammad Hakim, S.Pd.I',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Izin rapat dinas',
      'jenis': 'Izin',
      'avatar': 'https://i.pravatar.cc/150?img=52',
    },
    {
      'nama': 'Ustadzah Khadijah, S.Pd',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Hadir, terlambat 10 menit',
      'jenis': 'Terlambat',
      'avatar': 'https://i.pravatar.cc/150?img=44',
    },
    {
      'nama': 'Ahmad Subhan, S.Kom',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Sakit flu',
      'jenis': 'Sakit',
      'avatar': 'https://i.pravatar.cc/150?img=53',
    },
    {
      'nama': 'Ustadz Abdullah Yusuf, Lc',
      'tanggal': '28 September 2025',
      'tanggalObj': DateTime(2025, 9, 28),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=54',
    },
    {
      'nama': 'Ustadzah Asiyah, S.Pd.I',
      'tanggal': '28 September 2025',
      'tanggalObj': DateTime(2025, 9, 28),
      'keterangan': 'Alpha tanpa keterangan',
      'jenis': 'Alpha',
      'avatar': 'https://i.pravatar.cc/150?img=45',
    },
    {
      'nama': 'Dr. Ahmad Fauzi, M.Pd',
      'tanggal': '27 September 2025',
      'tanggalObj': DateTime(2025, 9, 27),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=51',
    },
    {
      'nama': 'Ustadz Muhammad Hakim, S.Pd.I',
      'tanggal': '26 September 2025',
      'tanggalObj': DateTime(2025, 9, 26),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=52',
    },
  ];

  List<dynamic> get filteredKehadiran {
    if (_usesFallback) {
      if (startDate == null || endDate == null) {
        return kehadiranData;
      }

      return kehadiranData.where((kehadiran) {
        final tanggal = kehadiran['tanggalObj'] as DateTime;
        return tanggal.isAfter(startDate!.subtract(const Duration(days: 1))) &&
            tanggal.isBefore(endDate!.add(const Duration(days: 1)));
      }).toList();
    } else {
      // Using API data
      if (startDate == null || endDate == null) {
        return _kehadiranList;
      }

      return _kehadiranList.where((kehadiran) {
        final tanggal = DateTime.parse(kehadiran.tanggal);
        return tanggal.isAfter(startDate!.subtract(const Duration(days: 1))) &&
            tanggal.isBefore(endDate!.add(const Duration(days: 1)));
      }).toList();
    }
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

      // Fetch data with date range if using API
      if (!_usesFallback) {
        await _fetchKehadiranDataByDateRange();
      }
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
      final kehadiranList = await provider.fetchGuruByDateRange(
        slug,
        startDate!,
        endDate!,
        forceRefresh: true,
      );
      final state = provider.guruState(
        slug,
        startDate: startDate,
        endDate: endDate,
      );

      if (state.errorMessage != null && kehadiranList.isEmpty) {
        setState(() {
          _kehadiranList = fallbackKehadiranGuruData
              .map((json) => KehadiranGuru.fromJson(json))
              .toList();
          _usesFallback = true;
          _errorMessage = state.errorMessage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _kehadiranList = kehadiranList;
          _usesFallback = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching kehadiran guru by date range: $e');
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

    // Reload all data if using API
    if (!_usesFallback) {
      _fetchKehadiranData();
    }
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
              color: Colors.blue,
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
                      child: const Icon(
                        Icons.assignment_turned_in,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KEHADIRAN STAFF',
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
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: Colors.blue.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      startDate!.isAtSameMomentAs(endDate!)
                          ? 'Tanggal: ${_formatDate(startDate!)}'
                          : 'Periode: ${_formatDate(startDate!)} - ${_formatDate(endDate!)}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${filteredKehadiran.length} data',
                    style: TextStyle(
                      color: Colors.blue.shade600,
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

                  // Handle both KehadiranGuru model and Map (fallback)
                  String nama;
                  String tanggal;
                  String jenis;
                  String keterangan;
                  String? avatar;
                  String? tugasInfo;

                  if (kehadiran is KehadiranGuru) {
                    // API data
                    nama = kehadiran.namaStaff;
                    tanggal = _formatTanggalKehadiran(kehadiran.tanggal);
                    jenis = kehadiran.jenis;
                    keterangan = kehadiran.keterangan;
                    avatar = null;
                    tugasInfo = kehadiran.staff?.keteranganTugas;
                  } else if (kehadiran is Map<String, dynamic>) {
                    // Fallback data
                    nama = kehadiran['nama'] ?? '';
                    tanggal = kehadiran['tanggal'] ?? '';
                    jenis = kehadiran['jenis'] ?? '';
                    keterangan = kehadiran['keterangan'] ?? '';
                    avatar = kehadiran['avatar'];
                    tugasInfo = null;
                  } else {
                    nama = 'Unknown';
                    tanggal = '';
                    jenis = '';
                    keterangan = '';
                    avatar = null;
                    tugasInfo = null;
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
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blue.shade100,
                            backgroundImage:
                                avatar != null ? NetworkImage(avatar) : null,
                            child: avatar == null
                                ? Icon(
                                    Icons.person,
                                    color: Colors.blue.shade700,
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
                          if (tugasInfo != null && tugasInfo.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                tugasInfo,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
