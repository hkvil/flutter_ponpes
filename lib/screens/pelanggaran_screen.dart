import 'package:flutter/material.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../models/models.dart';
import '../providers/pelanggaran_provider.dart';

class PelanggaranScreen extends StatefulWidget {
  final String title;
  final String? lembagaName;

  const PelanggaranScreen({
    super.key,
    required this.title,
    this.lembagaName,
  });

  @override
  State<PelanggaranScreen> createState() => _PelanggaranScreenState();
}

class _PelanggaranScreenState extends State<PelanggaranScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Defer the data fetching to after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPelanggaranData();
    });
  }

  void _fetchPelanggaranData() {
    final slug = MenuSlugMapper.getSlugByMenuTitle(widget.lembagaName ?? '');
    if (slug != null) {
      context.read<PelanggaranProvider>().fetchPelanggaranByLembaga(slug);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slug = MenuSlugMapper.getSlugByMenuTitle(widget.lembagaName ?? '');
    if (slug == null) {
      return ResponsiveWrapper(
        child: Scaffold(
          backgroundColor: AppColors.primaryGreen,
          body: const Center(
            child: Text(
              'Data lembaga tidak ditemukan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: Consumer<PelanggaranProvider>(
          builder: (context, provider, child) {
            final state = provider.pelanggaranState(slug);

            if (state.isLoading && state.data!.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Terjadi Kesalahan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Gagal memuat data',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _fetchPelanggaranData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final pelanggaranList = state.data ?? [];

            if (pelanggaranList.isEmpty) {
              return Column(
                children: [
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Colors.green.shade300,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tidak ada data pelanggaran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Semua santri berkelakuan baik! 🎉',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Group pelanggaran by santri and calculate total poin
            final groupedPelanggaran =
                _groupPelanggaranBySantri(pelanggaranList);

            // Filter pelanggaran based on search query
            final filteredPelanggaranList = searchQuery.isEmpty
                ? groupedPelanggaran.entries.toList()
                : groupedPelanggaran.entries.where((entry) {
                    final santri = entry.key;
                    return santri.nama.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

            return Column(
              children: [
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
                        _buildSummaryStats(groupedPelanggaran),
                        _buildSearchField(),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await provider.fetchPelanggaranByLembaga(slug,
                                  forceRefresh: true);
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: filteredPelanggaranList.length,
                              itemBuilder: (context, index) {
                                final entry = filteredPelanggaranList[index];
                                final santri = entry.key;
                                final pelanggaranSantri = entry.value;

                                return _buildSantriCard(santri, pelanggaranSantri);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<MapEntry<Santri, PelanggaranSummary>> get filteredPelanggaran {
    // This getter needs to be called within the Consumer context
    // We'll implement filtering in the build method instead
    return [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pelanggaran Santri',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pantau dan kelola pelanggaran santri ${widget.lembagaName ?? ''}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
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

  Widget _buildSummaryStats(Map<Santri, PelanggaranSummary> groupedPelanggaran) {
    final totalSantri = groupedPelanggaran.length;
    final totalPelanggaran = groupedPelanggaran.values
        .fold(0, (sum, summary) => sum + summary.pelanggaran.length);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade50, Colors.orange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.people,
            value: totalSantri.toString(),
            label: 'Santri\nBermasalah',
            color: Colors.red,
          ),
          _buildStatItem(
            icon: Icons.warning,
            value: totalPelanggaran.toString(),
            label: 'Total\nPelanggaran',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari nama santri...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade500),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSantriCard(Santri santri, PelanggaranSummary pelanggaranSantri) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan nama santri
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.red.shade100,
                  child: Icon(
                    Icons.person,
                    color: Colors.red.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        santri.nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${pelanggaranSantri.pelanggaran.length} pelanggaran',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),
            // List detail pelanggaran
            ...pelanggaranSantri.pelanggaran.map((pelanggaran) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getPoinColor(pelanggaran.poin).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getPoinColor(pelanggaran.poin).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getPelanggaranIcon(pelanggaran.jenis),
                        color: _getPoinColor(pelanggaran.poin),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pelanggaran.jenis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pelanggaran.tanggal,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getPoinColor(pelanggaran.poin),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: _getPoinColor(pelanggaran.poin).withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${pelanggaran.poin}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  IconData _getPelanggaranIcon(String jenis) {
    final jenisLower = jenis.toLowerCase();
    if (jenisLower.contains('terlambat')) return Icons.access_time;
    if (jenisLower.contains('bolos') || jenisLower.contains('absen')) return Icons.person_off;
    if (jenisLower.contains('merokok')) return Icons.smoking_rooms;
    if (jenisLower.contains('ribut') || jenisLower.contains('gaduh')) return Icons.volume_up;
    if (jenisLower.contains('baju') || jenisLower.contains('seragam')) return Icons.checkroom;
    if (jenisLower.contains('telepon') || jenisLower.contains('hp')) return Icons.phone_android;
    return Icons.warning;
  }

  Map<Santri, PelanggaranSummary> _groupPelanggaranBySantri(
      List<Pelanggaran> pelanggaranList) {
    final grouped = <Santri, List<Pelanggaran>>{};

    for (final pelanggaran in pelanggaranList) {
      if (pelanggaran.santri != null) {
        grouped.putIfAbsent(pelanggaran.santri!, () => []).add(pelanggaran);
      }
    }

    return grouped.map((santri, pelanggaran) {
      return MapEntry(santri,
          PelanggaranSummary(pelanggaran: pelanggaran));
    });
  }

  Color _getPoinColor(int poin) {
    if (poin >= 25) return Colors.red;
    if (poin >= 15) return Colors.orange;
    if (poin >= 5) return Colors.yellow.shade700;
    return Colors.green;
  }
}

class PelanggaranSummary {
  final List<Pelanggaran> pelanggaran;

  PelanggaranSummary({
    required this.pelanggaran,
  });
}
