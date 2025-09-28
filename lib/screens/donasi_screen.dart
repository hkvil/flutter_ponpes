import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class DonationScreen extends StatelessWidget {
  DonationScreen({super.key});

  final List<Map<String, String>> sliderImages = [
    {
      "image":
          "https://images.unsplash.com/photo-1564769662615-0caa1edec2b4?w=600&h=300&fit=crop",
      "title": "WAKAF\nPEMBANGUNAN\nMASJID KH. AHMAD QORI NURI"
    },
    {
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&h=300&fit=crop",
      "title": "WAKAF\nPEMBANGUNAN\nASRAMA SANTRIWATI"
    },
    {
      "image":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=600&h=300&fit=crop",
      "title": "SHADAQAH\nANAK YATIM"
    },
  ];

  final List<Map<String, dynamic>> donations = [
    {
      "title": "Wakaf Pembangunan\nMasjid KH. Ahmad Qori Nuri",
      "image":
          "https://images.unsplash.com/photo-1564769662615-0caa1edec2b4?w=120&h=80&fit=crop",
      "collected": 500000000,
      "target": 2000000000,
      "daysLeft": 100,
    },
    {
      "title": "Wakaf Pembangunan\nAsrama Santriwati",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=120&h=80&fit=crop",
      "collected": 200000000,
      "target": 800000000,
      "daysLeft": 90,
    },
    {
      "title": "Shadaqah\nAnak Yatim",
      "image":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=120&h=80&fit=crop",
      "collected": 900000000,
      "target": 900000000,
      "daysLeft": 100,
    },
  ];

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Penggalangan Donasi"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slider
            Container(
              margin: const EdgeInsets.all(16),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 250, // Increased from 200 to 250
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                ),
                items: sliderImages.map((item) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      item["image"]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade700,
                                Colors.green.shade400,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // List Donasi
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final item = donations[index];
                double progress = item["collected"] / item["target"];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 80, // Reduced from 95 to 80 to prevent overflow
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Thumbnail image - full height container
                      Container(
                        width: 120, // Reduced from 140 to 120
                        height: double.infinity, // Full height of the card
                        child: Image.network(
                          item["image"],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.green.shade100,
                              child: Icon(
                                Icons.mosque,
                                color: Colors.green,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),

                      // Content
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(8), // Reduced from 10 to 8
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title - simplified without Flexible
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  fontSize: 12, // Reduced from 13 to 12
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines:
                                    1, // Reduced from 2 to 1 to save space
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 3), // Reduced from 4 to 3

                              // Progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 3, // Reduced from 4 to 3
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green,
                                  ),
                                ),
                              ),

                              const Spacer(), // Use Spacer to push content to bottom

                              // Bottom info - simplified
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Terkumpul",
                                          style: TextStyle(
                                            fontSize: 8, // Reduced from 9 to 8
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          formatCurrency(item["collected"]),
                                          style: const TextStyle(
                                            fontSize: 9, // Reduced from 10 to 9
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Sisa hari",
                                        style: TextStyle(
                                          fontSize: 8, // Reduced from 9 to 8
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        "${item["daysLeft"]}",
                                        style: const TextStyle(
                                          fontSize: 9, // Reduced from 10 to 9
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
