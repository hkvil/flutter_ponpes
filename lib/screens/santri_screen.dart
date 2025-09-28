import 'package:flutter/material.dart';

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

class _SantriScreenState extends State<SantriScreen> {
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
      'nama': 'Muhammad Arkia Bin Wazdan', 
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'kelas': 'Kelas 1',
      'nisn': '0123456790',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '22 Februari 2010',
      'namaAyah': 'Ahmad Bin Sulaiman',
      'namaIbu': 'Aminah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2024-002',
      'tahunIjazah': '2024'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel', 
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'kelas': 'Kelas 1',
      'nisn': '0123456791',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '08 Maret 2010',
      'namaAyah': 'Usman Bin Ali',
      'namaIbu': 'Khadijah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2024-003',
      'tahunIjazah': '2024'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'kelas': 'Kelas 1',
      'nisn': '0123456792',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '14 April 2010',
      'namaAyah': 'Yusuf Bin Ibrahim',
      'namaIbu': 'Asiyah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2024-004',
      'tahunIjazah': '2024'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'kelas': 'Kelas 1',
      'nisn': '0123456793',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '30 Mei 2010',
      'namaAyah': 'Hasan Bin Muhammad',
      'namaIbu': 'Ruqayyah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2024-005',
      'tahunIjazah': '2024'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'kelas': 'Kelas 1',
      'nisn': '0123456794',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '07 Juni 2010',
      'namaAyah': 'Omar Bin Khattab',
      'namaIbu': 'Ummu Salamah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2024-006',
      'tahunIjazah': '2024'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'kelas': 'Kelas 1',
      'nisn': '0123456795',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '23 Juli 2010',
      'namaAyah': 'Abdullah Bin Zubair',
      'namaIbu': 'Sakinah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2024-007',
      'tahunIjazah': '2024'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'kelas': 'Kelas 1'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=9',
      'kelas': 'Kelas 1'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'kelas': 'Kelas 1'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'kelas': 'Kelas 1'
    },
    {
      'nama': 'Muhammad Arkia Bin Wazdan',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'kelas': 'Kelas 1'
    },
    // Tambah data untuk kelas lain dengan data lengkap
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
    {
      'nama': 'Umar Abdillah Bin Sulaiman',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=14',
      'kelas': 'Kelas 2',
      'nisn': '0123456814',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '25 Mei 2009',
      'namaAyah': 'Sulaiman Bin Omar',
      'namaIbu': 'Zainab',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2023-014',
      'tahunIjazah': '2023'
    },
    {
      'nama': 'Ali Hasan Bin Ahmad',
      'subtitle': 'Inaralaya Ujian Ilir Sumasel',
      'avatar': 'https://i.pravatar.cc/150?img=15',
      'kelas': 'Kelas 3',
      'nisn': '0123456815',
      'lembaga': 'Taman Pendidikan Al-Quran Al-Ittifaqiah',
      'gender': 'Laki-laki',
      'tempatLahir': 'Palembang',
      'tanggalLahir': '18 Juni 2008',
      'namaAyah': 'Ahmad Bin Hassan',
      'namaIbu': 'Hafsah',
      'kelurahan': 'Inaralaya',
      'kecamatan': 'Ujian Ilir',
      'kota': 'Palembang',
      'nomorIjazah': 'IJ-2022-015',
      'tahunIjazah': '2022'
    },
  ];

  List<Map<String, dynamic>> get filteredSantri {
    var filtered = santriData.where((santri) => santri['kelas'] == selectedKelas).toList();
    
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((santri) =>
        santri['nama'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
        santri['subtitle'].toString().toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
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
      barrierColor: Colors.black.withOpacity(0.7), // Semi-transparent overlay
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
                      colors: [Colors.green, Colors.green.shade300],
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
                        backgroundImage: NetworkImage(santri['avatar']),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Fallback handled by child
                        },
                        child: santri['avatar'] == null 
                          ? const Icon(Icons.person, color: Colors.white, size: 30)
                          : null,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Santri',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              santri['kelas'],
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
                          _buildDetailRow('Nama Lengkap', santri['nama']),
                          _buildDetailRow('NISN', santri['nisn']),
                          _buildDetailRow('Jenis Kelamin', santri['gender']),
                          _buildDetailRow('Tempat Lahir', santri['tempatLahir']),
                          _buildDetailRow('Tanggal Lahir', santri['tanggalLahir']),
                        ]),
                        
                        const SizedBox(height: 20),
                        
                        _buildDetailSection('Data Orang Tua', [
                          _buildDetailRow('Nama Ayah', santri['namaAyah']),
                          _buildDetailRow('Nama Ibu', santri['namaIbu']),
                        ]),
                        
                        const SizedBox(height: 20),
                        
                        _buildDetailSection('Alamat', [
                          _buildDetailRow('Kelurahan', santri['kelurahan']),
                          _buildDetailRow('Kecamatan', santri['kecamatan']),
                          _buildDetailRow('Kota', santri['kota']),
                        ]),
                        
                        const SizedBox(height: 20),
                        
                        _buildDetailSection('Data Pendidikan', [
                          _buildDetailRow('Lembaga', santri['lembaga']),
                          _buildDetailRow('Nomor Ijazah', santri['nomorIjazah']),
                          _buildDetailRow('Tahun Ijazah', santri['tahunIjazah']),
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
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header dengan background hijau dan logo
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade300],
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
                        Icons.school,
                        color: Colors.green,
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
                
                // Filter dan Info section
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
                      // Dropdown Kelas
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedKelas,
                              dropdownColor: Colors.black,
                              style: const TextStyle(color: Colors.white),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
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
                      
                      // Jumlah Santri
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green,
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
          
          // List Santri
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
                            'Mencari: "$searchQuery" di $selectedKelas',
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
                              _updateJumlahSantri();
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
                    child: filteredSantri.isEmpty 
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
                                  ? 'Tidak ditemukan santri dengan kata kunci "$searchQuery"'
                                  : 'Tidak ada santri di kelas ini',
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
                          itemCount: filteredSantri.length,
                          itemBuilder: (context, index) {
                            final santri = filteredSantri[index];
                            return _buildSantriCard(santri, index);
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

  Widget _buildSantriCard(Map<String, dynamic> santri, int index) {
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
          onBackgroundImageError: (exception, stackTrace) {
            // Fallback to default avatar
          },
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
        onTap: () => _showSantriDetail(santri), // ← Tambahkan onTap
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
              color: Colors.green,
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