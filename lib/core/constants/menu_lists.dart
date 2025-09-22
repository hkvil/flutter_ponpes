// // Struktur menu bercabang (tree)
// const Map<String, dynamic> menuTree = {
//   'PPI': {
//     'Organ Struktural': [
//       'Pusat Kepegawaian dan Pengawasan',
//       'Pusat Pengawasan dan Pembinaan SDM Putri',
//       'Pusat Penjaminan Mutu Pendidikan dan Pengajaran',
//     ],
//     'Organ Penyelenggara Pendidikan Formal': [
//       'Taman Kanak-Kanak',
//       'Taman Pendidikan Al-Qur\'an',
//       'Madrasah Diniyah',
//       'Madrasah Ibtidaiyah',
//       'Madrasah Tsanawiyah Putra',
//       'Madrasah Tsanawiyah Putri',
//       'Madrasah Aliyah Putra',
//       'Madrasah Aliyah Putri',
//       'Madrasah Tahfizh Lil Athfal',
//       'Institut Mujahadah dan Pembibitan',
//       'Haromain',
//       'Al Ittifaqiah Language Center',
//     ],
//     'Organ Penyelenggara Pendidikan Informal': [
//       'LEMTATIQHI PA',
//       'LEMTATIQHI PI',
//       'LEBAH Putra',
//       'LEBAH Putri',
//       'LESGATRAM Putra',
//       'LESGATRAM Putri',
//       'Lembaga Muhadhoroh Putra',
//       'Lembaga Muhadhoroh Putri',
//       'LEMKAKIKU',
//       'LEMKAPPI',
//       'LERASI_LOGINTARU',
//       'LK2PPI',
//     ],
//     'Organ Pengasuhan & Pengkaderan': [
//       'DATSUHBINOSPI Putra',
//       'DATSUHBINOSPI Putri',
//       'Biro Pengkaderan, Beasiswa dan Kerjasama',
//     ],
//     'Organ Umum': [
//       'ADKEU',
//       'BIDDAPPMASSUL',
//       'Bidang Kebersihan, Perairan, Pertamanan dan Lingkungan Hidup',
//       'Bidang Sarana Prasarana, Perlistrikan dan Transportasi',
//       'KESLOGMESS',
//       'Klinik',
//       'Bidang Keamanan, Ketertiban',
//       'Hubungan Masyarakat dan Protokol',
//     ],
//     'Organ Struktural Otonom': [
//       'IWAPPI',
//       'PUSPAMAYA',
//       'PUSDEM',
//       'Avicenna Institute',
//       'PUSDAP',
//       'PBHU',
//       'LPBI',
//     ],
//     'Organ Struktural Khusus': [],
//   },
//   // Tambah menu utama lain jika ada
// };

// Struktur menu bercabang (tree)
const Map<String, dynamic> menuTree = {
  'PPI': {
    'Organ Struktural': [
      {'title': 'Pusat Kepegawaian dan Pengawasan'},
      {'title': 'Pusat Pengawasan dan Pembinaan SDM Putri'},
      {'title': 'Pusat Penjaminan Mutu Pendidikan dan Pengajaran'},
    ],
    'Organ Penyelenggara Pendidikan Formal': [
      {
        'title': 'Formal',
        'indexBackgroundColor': 0xFFFFFFFF,
      },
      {
        'title': 'Taman Kanak-Kanak',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Taman Pendidikan Al-Qur\'an',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Madrasah Diniyah',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Madrasah Ibtidaiyah',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Madrasah Tsanawiyah Putra',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Madrasah Tsanawiyah Putri',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Madrasah Aliyah Putra',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Madrasah Aliyah Putri',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Non Formal',
        'indexBackgroundColor': 0xFFFFFFFF,
      },
      {
        'title': 'Madrasah Tahfizh Lil Athfal',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Institut Mujahadah dan Pembibitan',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Haromain',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Al Ittifaqiah Language Center',
        'indexBackgroundColor': 0xFF43A047,
      },
    ],
    'Organ Penyelenggara Pendidikan Informal': [
      {'title': 'LEMTATIQHI PA'},
      {'title': 'LEMTATIQHI PI'},
      {'title': 'LEBAH Putra'},
      {'title': 'LEBAH Putri'},
      {'title': 'LESGATRAM Putra'},
      {'title': 'LESGATRAM Putri'},
      {'title': 'Lembaga Muhadhoroh Putra'},
      {'title': 'Lembaga Muhadhoroh Putri'},
      {'title': 'LEMKAKIKU'},
      {'title': 'LEMKAPPI'},
      {'title': 'LERASI_LOGINTARU'},
      {'title': 'LK2PPI'},
    ],
    'Organ Pengasuhan & Pengkaderan': [
      {'title': 'DATSUHBINOSPI Putra'},
      {'title': 'DATSUHBINOSPI Putri'},
      {'title': 'Biro Pengkaderan, Beasiswa dan Kerjasama'},
    ],
    'Organ Umum': [
      {'title': 'ADKEU'},
      {'title': 'BIDDAPPMASSUL'},
      {'title': 'Bidang Kebersihan, Perairan, Pertamanan dan Lingkungan Hidup'},
      {'title': 'Bidang Sarana Prasarana, Perlistrikan dan Transportasi'},
      {'title': 'KESLOGMESS'},
      {'title': 'Klinik'},
      {'title': 'Bidang Keamanan, Ketertiban'},
      {'title': 'Hubungan Masyarakat dan Protokol'},
    ],
    'Organ Struktural Otonom': [
      {'title': 'IWAPPI'},
      {'title': 'PUSPAMAYA'},
      {'title': 'PUSDEM'},
      {'title': 'Avicenna Institute'},
      {'title': 'PUSDAP'},
      {'title': 'PBHU'},
      {'title': 'LPBI'},
    ],
    'Organ Struktural Khusus': [],
  },
  // Tambah menu utama lain jika ada
};
