import 'package:flutter/material.dart';

class DetailLayout extends StatelessWidget {
  final String title;
  final List<String> imagePaths;
  final List<String> menuItems;

  const DetailLayout({
    Key? key,
    required this.title,
    this.imagePaths = const [],
    this.menuItems = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (imagePaths.isEmpty)
                    for (int i = 0; i < 6; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: const Placeholder(
                          fallbackHeight: 65,
                          fallbackWidth: 131,
                        ),
                      )
                  else
                    for (final img in imagePaths)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(img, width: 80, height: 80),
                      ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    if (menuItems.isEmpty)
                      for (int i = 0; i < 9; i++)
                        ListTile(
                          title: const Text('Menu'),
                          trailing: const Icon(Icons.arrow_right),
                        )
                    else
                      for (final item in menuItems)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Material(
                            color: Colors.green.shade50,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Kamu memilih "$title dan $item"'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 44,
                                    width: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade700,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: const Icon(Icons.arrow_right,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
