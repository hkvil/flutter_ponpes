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
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (imagePaths.isEmpty)
                    for (int i = 0; i < 4; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: const Placeholder(
                          fallbackHeight: 80,
                          fallbackWidth: 80,
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
                        ListTile(
                          title: Text(item),
                          trailing: const Icon(Icons.arrow_right),
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
