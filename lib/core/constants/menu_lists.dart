// Struktur menu bercabang (tree)
const Map<String, dynamic> menuTree = {
  'PPI': {
    'Organ Struktural': [
      'Pusat Kepegawaian & Pengawasan',
      'Pusat Pengawasan & Pembinaan SDM Putri',
      'Pusat Penjaminan Mutu Pendidikan & Pengajaran',
    ],
    'Organ Penyelenggara Pendidikan': [
      {
        'title': 'Formal',
        'indexBackgroundColor': 0xFF1976D2,
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
        'indexBackgroundColor': 0xFFD32F2F,
      },
      {
        'title': 'Madrasah Tahfizh Lil Ath Fal',
        'indexBackgroundColor': 0xFFD32F2F,
      },
      {
        'title': 'Institut Mujahadah & Pembibitan',
        'indexBackgroundColor': 0xFFD32F2F,
      },
      {
        'title': 'Haromain',
        'indexBackgroundColor': 0xFFD32F2F,
      },
      {
        'title': 'Al Ittifaqiah Language Center',
        'indexBackgroundColor': 0xFFD32F2F,
      },
    ],
    'Organ Penyelenggara Pendidikan Informal': [],
    'Organ Pengasuhan & Pengkaderan': [],
    'Organ Umam': [],
    'Organ Struktural Khusus': [],
  },
  // Tambah menu utama lain jika ada
};
