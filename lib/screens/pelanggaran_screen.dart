import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _fetchPelanggaranData();
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
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: AppColors.primaryGreen,
        ),
        body: const Center(
          child: Text('Data lembaga tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Consumer<PelanggaranProvider>(
        builder: (context, provider, child) {
          final state = provider.pelanggaranState(slug);

          if (state.isLoading && state.data!.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
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
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchPelanggaranData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final pelanggaranList = state.data ?? [];

          if (pelanggaranList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 64,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada data pelanggaran',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // Group pelanggaran by santri and calculate total poin
          final groupedPelanggaran = _groupPelanggaranBySantri(pelanggaranList);

          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchPelanggaranByLembaga(slug,
                  forceRefresh: true);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedPelanggaran.length,
              itemBuilder: (context, index) {
                final entry = groupedPelanggaran.entries.elementAt(index);
                final santri = entry.key;
                final pelanggaranSantri = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header dengan nama santri dan total poin
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                santri.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getTotalPoinColor(
                                    pelanggaranSantri.totalPoin),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Total: ${pelanggaranSantri.totalPoin} poin',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // List detail pelanggaran
                        ...pelanggaranSantri.pelanggaran.map((pelanggaran) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pelanggaran.jenis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getPoinColor(pelanggaran.poin),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${pelanggaran.poin}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
              },
            ),
          );
        },
      ),
    );
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
      final totalPoin = pelanggaran.fold<int>(0, (sum, p) => sum + p.poin);
      return MapEntry(santri,
          PelanggaranSummary(pelanggaran: pelanggaran, totalPoin: totalPoin));
    });
  }

  Color _getPoinColor(int poin) {
    if (poin >= 25) return Colors.red;
    if (poin >= 15) return Colors.orange;
    if (poin >= 5) return Colors.yellow.shade700;
    return Colors.green;
  }

  Color _getTotalPoinColor(int totalPoin) {
    if (totalPoin >= 50) return Colors.red;
    if (totalPoin >= 30) return Colors.orange;
    if (totalPoin >= 15) return Colors.yellow.shade700;
    return Colors.green;
  }
}

class PelanggaranSummary {
  final List<Pelanggaran> pelanggaran;
  final int totalPoin;

  PelanggaranSummary({
    required this.pelanggaran,
    required this.totalPoin,
  });
}
