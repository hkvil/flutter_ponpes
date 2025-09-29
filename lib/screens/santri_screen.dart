import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

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
  String selectedKelas = 'Kelas 1';
  int jumlahSantri = 12;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> kelasList = [
    'Kelas 1',
    'Kelas 2',
    'Kelas 3',
    'Kelas 4',
    'Kelas 5',
    'Kelas 6'
  ];

  // Data static santri
  final List<Map<String, dynamic>> santriData = [
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'kelas': 'Kelas 1',
      'nisn': '0123456789',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '15 Januari 2010',
      'namaAyah': 'Wazdan Bin Abdullah',
      'namaIbu': 'Siti Fatimah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2024-001',
      'tahunIjazah': '2024'
    },
    {
      'nama': 'Ahmad Fadhil Bin Ibrahim',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=13',
      'kelas': 'Kelas 2',
      'nisn': '0123456813',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '12 April 2009',
      'namaAyah': 'Ibrahim Bin Yusuf',
      'namaIbu': 'Maryam',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2023-013',
      'tahunIjazah': '2023'
    },
  ];

  List<Map<String, dynamic>> get filteredSantri {
    var filtered =
        santriData.where((santri) => santri['kelas'] == selectedKelas).toList();

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((santri) =>
              santri['nama']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              santri['subtitle']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _updateJumlahSantri();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateJumlahSantri() {
    setState(() {
      jumlahSantri = filteredSantri.length;
    });
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

  void _showSantriDetail(Map<String, dynamic> santri) {
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
                    color: AppColors.primaryGreen,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(santri['avatar']),
                        child: santri['avatar'] == null
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
                              'Detail Santri',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              santri['kelas'] ?? '-',
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailSection('Data Pribadi', [
                          _buildDetailRow('Nama Lengkap', santri['nama']),
                          _buildDetailRow('NISN', santri['nisn']),
                          _buildDetailRow('Jenis Kelamin', santri['gender']),
                          _buildDetailRow(
                              'Tempat Lahir', santri['tempatLahir']),
                          _buildDetailRow(
                              'Tanggal Lahir', santri['tanggalLahir']),
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
                              if (newValue != null) {
                                setState(() {
                                  selectedKelas = newValue;
                                  _updateJumlahSantri();
                                });
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
            child: filteredSantri.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada santri di kelas ini',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredSantri.length,
                    itemBuilder: (context, index) {
                      final santri = filteredSantri[index];
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
                            backgroundImage: NetworkImage(santri['avatar']),
                            child: santri['avatar'] == null
                                ? Icon(
                                    Icons.person,
                                    color: Colors.grey.shade400,
                                    size: 30,
                                  )
                                : null,
                          ),
                          title: Text(
                            santri['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            santri['subtitle'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index.isEven ? Colors.red : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          onTap: () => _showSantriDetail(santri),
                        ),
                      );
                    },
                  ),
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
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
            width: 120,
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

class KehadiranSantriTab extends StatefulWidget {
  final String? lembagaName;

  const KehadiranSantriTab({super.key, this.lembagaName});

  @override
  State<KehadiranSantriTab> createState() => _KehadiranSantriTabState();
}

class _KehadiranSantriTabState extends State<KehadiranSantriTab> {
  DateTime? startDate;
  DateTime? endDate;

  // Data static kehadiran
  final List<Map<String, dynamic>> kehadiranData = [
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'nama': 'Ahmad Fadhil Bin Ibrahim',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Izin karena sakit',
      'jenis': 'Izin',
      'avatar': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'nama': 'Umar Abdillah Bin Sulaiman',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Tidak hadir tanpa keterangan',
      'jenis': 'Alpha',
      'avatar': 'https://i.pravatar.cc/150?img=3',
    },
    {
      'nama': 'Ali Hasan Bin Ahmad',
      'tanggal': '29 September 2025',
      'tanggalObj': DateTime(2025, 9, 29),
      'keterangan': 'Hadir, terlambat 15 menit',
      'jenis': 'Terlambat',
      'avatar': 'https://i.pravatar.cc/150?img=4',
    },
    {
      'nama': 'Muhammad Yusuf Bin Omar',
      'tanggal': '28 September 2025',
      'tanggalObj': DateTime(2025, 9, 28),
      'keterangan': 'Izin keperluan keluarga',
      'jenis': 'Izin',
      'avatar': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'nama': 'Abdullah Rahman Bin Ali',
      'tanggal': '28 September 2025',
      'tanggalObj': DateTime(2025, 9, 28),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=6',
    },
    {
      'nama': 'Hassan Bin Muhammad',
      'tanggal': '28 September 2025',
      'tanggalObj': DateTime(2025, 9, 28),
      'keterangan': 'Sakit demam',
      'jenis': 'Sakit',
      'avatar': 'https://i.pravatar.cc/150?img=7',
    },
    {
      'nama': 'Ibrahim Bin Yusuf',
      'tanggal': '27 September 2025',
      'tanggalObj': DateTime(2025, 9, 27),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=8',
    },
    {
      'nama': 'Omar Bin Khattab',
      'tanggal': '27 September 2025',
      'tanggalObj': DateTime(2025, 9, 27),
      'keterangan': 'Alpha tanpa keterangan',
      'jenis': 'Alpha',
      'avatar': 'https://i.pravatar.cc/150?img=9',
    },
    {
      'nama': 'Sulaiman Bin Ahmad',
      'tanggal': '27 September 2025',
      'tanggalObj': DateTime(2025, 9, 27),
      'keterangan': 'Terlambat 10 menit',
      'jenis': 'Terlambat',
      'avatar': 'https://i.pravatar.cc/150?img=10',
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'tanggal': '26 September 2025',
      'tanggalObj': DateTime(2025, 9, 26),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'nama': 'Ahmad Fadhil Bin Ibrahim',
      'tanggal': '25 September 2025',
      'tanggalObj': DateTime(2025, 9, 25),
      'keterangan': 'Hadir tepat waktu',
      'jenis': 'Hadir',
      'avatar': 'https://i.pravatar.cc/150?img=2',
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
