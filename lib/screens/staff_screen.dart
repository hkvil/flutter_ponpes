import 'package:flutter/material.dart';

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

class _StaffScreenState extends State<StaffScreen> {
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
      'sertifikasi': ['Sertifikat Pendidik', 'Sertifikat Tahfidz', 'Sertifikat Kepemimpinan']
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
      'sertifikasi': ['Sertifikat Tahfidz 30 Juz', 'Sertifikat Qira\'at', 'Pelatihan Metode Tilawah']
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
      'sertifikasi': ['Sertifikat Pendidik', 'Workshop Kurikulum 2013', 'Pelatihan Bahasa Arab']
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
      'sertifikasi': ['Sertifikat Microsoft Office', 'Pelatihan Sistem Informasi Sekolah']
    },
    {
      'nama': 'Ustadz Abdullah Yusuf, Lc',
      'subtitle': 'Guru Bahasa Arab',
      'avatar': 'https://i.pravatar.cc/150?img=54',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '12 November 1982',
      'gender': 'Laki-laki',
      'agama': 'Islam',
      'noTelephone': '0816-7890-1234',
      'namaIbu': 'Ummu Salamah',
      'nik': '1671051211820001',
      'kategoriPersonil': 'Tenaga Pendidik',
      'keteranganTugas': 'Mengajar Bahasa Arab, Fiqh',
      'statusKepegawaian': 'Tetap',
      'mulaiTugas': '10 Januari 2008',
      'aktif': true,
      'pendidikanTerakhir': 'S1',
      'lulusan': 'Universitas Al-Azhar Kairo',
      'statusPNS': 'Non PNS',
      'statusGuruTetap': 'Guru Tetap',
      'sertifikasi': ['Ijazah Bahasa Arab', 'Sertifikat Fiqh', 'Sertifikat Da\'wah']
    },
    {
      'nama': 'Ustadzah Asiyah, S.Pd.I',
      'subtitle': 'Guru Tahfidz',
      'avatar': 'https://i.pravatar.cc/150?img=45',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '18 April 1987',
      'gender': 'Perempuan',
      'agama': 'Islam',
      'noTelephone': '0817-8901-2345',
      'namaIbu': 'Hafsah',
      'nik': '1671055804870001',
      'kategoriPersonil': 'Tenaga Pendidik',
      'keteranganTugas': 'Mengajar Tahfidz Al-Quran',
      'statusKepegawaian': 'Tetap',
      'mulaiTugas': '01 September 2011',
      'aktif': true,
      'pendidikanTerakhir': 'S1',
      'lulusan': 'UIN Raden Fatah Palembang',
      'statusPNS': 'Non PNS',
      'statusGuruTetap': 'Guru Tetap',
      'sertifikasi': ['Hafidzah 30 Juz', 'Sertifikat Qira\'at Sab\'ah', 'Ijazah Tahfidz']
    },
  ];

  List<Map<String, dynamic>> get filteredStaff {
    if (searchQuery.isEmpty) {
      return staffData;
    }
    
    return staffData.where((staff) =>
      staff['nama'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
      staff['subtitle'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
      staff['kategoriPersonil'].toString().toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
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
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                        onBackgroundImageError: (exception, stackTrace) {},
                        child: staff['avatar'] == null 
                          ? const Icon(Icons.person, color: Colors.white, size: 30)
                          : null,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Staff',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              staff['subtitle'],
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
                        _buildDetailSection('Data Pribadi', [
                          _buildDetailRow('Nama Lengkap', staff['nama']),
                          _buildDetailRow('Tempat Lahir', staff['tempatLahir']),
                          _buildDetailRow('Tanggal Lahir', staff['tanggalLahir']),
                          _buildDetailRow('Jenis Kelamin', staff['gender']),
                          _buildDetailRow('Agama', staff['agama']),
                          _buildDetailRow('No. Telepon', staff['noTelephone']),
                          _buildDetailRow('Nama Ibu', staff['namaIbu']),
                          _buildDetailRow('NIK', staff['nik']),
                        ]),
                        
                        const SizedBox(height: 20),
                        
                        _buildDetailSection('Data Kepegawaian', [
                          _buildDetailRow('Lembaga', staff['lembaga']),
                          _buildDetailRow('Kategori Personil', staff['kategoriPersonil']),
                          _buildDetailRow('Keterangan Tugas', staff['keteranganTugas']),
                          _buildDetailRow('Status Kepegawaian', staff['statusKepegawaian']),
                          _buildDetailRow('Mulai Tugas', staff['mulaiTugas']),
                          _buildDetailRow('Status Aktif', staff['aktif'] ? 'Aktif' : 'Tidak Aktif'),
                          _buildDetailRow('Status PNS', staff['statusPNS']),
                          _buildDetailRow('Status Guru Tetap', staff['statusGuruTetap']),
                        ]),
                        
                        const SizedBox(height: 20),
                        
                        _buildDetailSection('Data Pendidikan', [
                          _buildDetailRow('Pendidikan Terakhir', staff['pendidikanTerakhir']),
                          _buildDetailRow('Lulusan', staff['lulusan']),
                        ]),
                        
                        const SizedBox(height: 20),
                        
                        _buildDetailSection('Sertifikasi', [
                          _buildSertifikasiList(staff['sertifikasi']),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header dengan background biru
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo dan title
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
                
                // Info section dengan search
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
                      // Info Total Staff
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      
                      // Search Icon
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
                          child: Stack(
                            children: [
                              Icon(
                                Icons.search,
                                color: searchQuery.isNotEmpty 
                                  ? Colors.blue.shade600 
                                  : Colors.grey.shade600,
                                size: 24,
                              ),
                              if (searchQuery.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
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
          
          // List Staff
          Expanded(
            child: Column(
              children: [
                // Search indicator
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
                
                // Content area
                Expanded(
                  child: Container(
                    color: Colors.grey.shade50,
                    child: filteredStaff.isEmpty 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                searchQuery.isNotEmpty 
                                  ? Icons.search_off
                                  : Icons.people_outline,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                searchQuery.isNotEmpty
                                  ? 'Tidak ditemukan Staff dengan kata kunci "$searchQuery"'
                                  : 'Tidak ada data Staff',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: filteredStaff.length,
                          itemBuilder: (context, index) {
                            final staff = filteredStaff[index];
                            return _buildStaffCard(staff, index);
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff, int index) {
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
          backgroundImage: NetworkImage(staff['avatar']),
          onBackgroundImageError: (exception, stackTrace) {},
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: staff['aktif'] ? Colors.green : Colors.red,
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

  Widget _buildSertifikasiList(List<dynamic> sertifikasi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sertifikasi.map((sert) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: Colors.blue, fontSize: 16)),
              Expanded(
                child: Text(
                  sert.toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}