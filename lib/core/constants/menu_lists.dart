// Struktur menu bercabang (tree)
const Map<String, dynamic> menuTree = {
  'PPI': {
    'Organ Struktural': [
      'Pusat Kepegawaian & Pengawasan',
      'Pusat Pengawasan & Pembinaan SDM Putri',
      'Pusat Penjaminan Mutu Pendidikan & Pengajaran',
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
        'title': 'Madrasah Tahfizh Lil Ath Fal',
        'indexBackgroundColor': 0xFF43A047,
      },
      {
        'title': 'Institut Mujahadah & Pembibitan',
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
    'Organ Penyelenggara Pendidikan Informal': [],
    'Organ Pengasuhan & Pengkaderan': [],
    'Organ Umam': [],
    'Organ Struktural Khusus': [],
  },
  // Tambah menu utama lain jika ada
};
