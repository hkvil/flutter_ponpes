import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_app/widgets/responsive_wrapper.dart';

import '../models/donasi_model.dart';

class DonasiDetailScreen extends StatelessWidget {
  final DonasiModel donasi;

  const DonasiDetailScreen({
    super.key,
    required this.donasi,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Detail Donasi',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan gambar dan info dasar
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(donasi.getImageUrl(
                      'http://localhost:1337',
                      size: 'medium',
                    )),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donasi.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            'Target: ${donasi.getFormattedTarget()}',
                            Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            'Terkumpul: ${donasi.getFormattedTerkumpul()}',
                            Colors.green.shade300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildInfoChip(
                            'Sisa: ${donasi.getFormattedSisaTarget()}',
                            Colors.orange.shade300,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            '${donasi.sisaHari} hari lagi',
                            Colors.blue.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Progress bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Donasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: donasi.progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          donasi.isTargetReached ? Colors.green : const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(donasi.progress * 100).toStringAsFixed(1)}% tercapai',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Daftar Transaksi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Transaksi (${donasi.transaksi.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: donasi.status == 'Aktif'
                                ? Colors.green.shade100
                                : donasi.status == 'Tercapai'
                                    ? Colors.blue.shade100
                                    : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            donasi.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: donasi.status == 'Aktif'
                                  ? Colors.green.shade800
                                  : donasi.status == 'Tercapai'
                                      ? Colors.blue.shade800
                                      : Colors.red.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (donasi.transaksi.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada transaksi donasi',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: donasi.transaksi.length,
                        itemBuilder: (context, index) {
                          final transaksi = donasi.transaksi[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Avatar dengan inisial
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      transaksi.name.isNotEmpty
                                          ? transaksi.name[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaksi.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        _formatDate(transaksi.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  transaksi.getFormattedAmount(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }
}