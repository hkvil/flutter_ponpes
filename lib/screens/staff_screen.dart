import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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

  List<Map<String, dynamic>> get filteredStaff {
    if (searchQuery.isEmpty) {
      return staffData;
    }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: filteredStaff.length,
                          itemBuilder: (context, index) {
                            final staff = filteredStaff[index];
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
                                  backgroundImage:
                                      NetworkImage(staff['avatar']),
                                  child: staff['avatar'] == null
                                      ? Icon(
                                          Icons.person,
                                          color: Colors.grey.shade400,
                                          size: 30,
                                        )
                                      : null,
                                ),
                                title: Text(
                                  staff['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      staff['subtitle'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      staff['kategoriPersonil'],
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: staff['aktif']
                                        ? AppColors.primaryGreen
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    staff['aktif'] ? 'Aktif' : 'Non-Aktif',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () => _showStaffDetail(staff),
                              ),
                            );
                          },
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
  DateTime? startDate;
  DateTime? endDate;

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

  List<Map<String, dynamic>> get filteredKehadiran {
    if (startDate == null || endDate == null) {
      return kehadiranData;
    }

    return kehadiranData.where((kehadiran) {
      final tanggal = kehadiran['tanggalObj'] as DateTime;
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
    }
  }

  void _clearDateFilter() {
    setState(() {
      startDate = null;
      endDate = null;
    });
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
    switch (jenis) {
      case 'Hadir':
        return AppColors.primaryGreen;
      case 'Izin':
        return Colors.blue;
      case 'Sakit':
        return Colors.orange;
      case 'Alpha':
        return Colors.red;
      case 'Terlambat':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getJenisIcon(String jenis) {
    switch (jenis) {
      case 'Hadir':
        return Icons.check_circle;
      case 'Izin':
        return Icons.info;
      case 'Sakit':
        return Icons.local_hospital;
      case 'Alpha':
        return Icons.cancel;
      case 'Terlambat':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
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
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredKehadiran.length,
              itemBuilder: (context, index) {
                final kehadiran = filteredKehadiran[index];
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
                          backgroundImage: NetworkImage(kehadiran['avatar']),
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
                              _getJenisIcon(kehadiran['jenis']),
                              color: _getJenisColor(kehadiran['jenis']),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      kehadiran['nama'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          kehadiran['tanggal'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          kehadiran['keterangan'],
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
                        color: _getJenisColor(kehadiran['jenis']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        kehadiran['jenis'],
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
        ],
      ),
    );
  }
}
