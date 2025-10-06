import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pesantren_app/core/constants/lembaga_slugs.dart';
import 'package:pesantren_app/screens/content_screen.dart';

import '../models/lembaga_model.dart';
import '../providers/lembaga_provider.dart';
import '../widgets/responsive_wrapper.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Debug Menu'),
          backgroundColor: Colors.green.shade700,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            _DebugMenuTab(),
            _SlugTestTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Debug Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bug_report),
              label: 'Slug Test',
            ),
          ],
        ),
      ),
    );
  }

  // Method untuk switch tab dari outside class
  void _switchToTab(int index) {
    setState(() => _selectedIndex = index);
  }
}

// Tab 1: Debug Menu
class _DebugMenuTab extends StatelessWidget {
  const _DebugMenuTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.red),
            title: const Text('Test All Slugs'),
            subtitle: const Text('Test semua 45+ slug lembaga API'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Switch to slug test tab
              final debugState =
                  context.findAncestorStateOfType<_DebugScreenState>();
              debugState?._switchToTab(1);
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.api, color: Colors.blue),
            title: const Text('API Status'),
            subtitle: const Text('Check API connectivity'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showApiStatus(context),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info, color: Colors.green),
            title: const Text('App Info'),
            subtitle: const Text('Version & build info'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showAppInfo(context),
          ),
        ),
      ],
    );
  }

  void _showApiStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Status'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 8),
                Text('Slider API: Active'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 8),
                Text('Achievement API: Active'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.orange, size: 12),
                SizedBox(width: 8),
                Text('Lembaga API: Testing...'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Info'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Name: Pesantren App'),
            Text('Version: 1.0.0'),
            Text('Build: Debug'),
            Text('Flutter: 3.x'),
            Text('Dart: 3.x'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Tab 2: Slug Test
class _SlugTestTab extends StatefulWidget {
  const _SlugTestTab();

  @override
  State<_SlugTestTab> createState() => _SlugTestTabState();
}

class _SlugTestTabState extends State<_SlugTestTab> {
  Map<String, String> testResults = {};
  bool isTestingAll = false;
  int currentTestIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header actions
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade50,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isTestingAll ? null : _testAllSlugs,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(isTestingAll ? 'Testing...' : 'Test All Slugs'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _clearResults,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),

        // Progress indicator
        if (isTestingAll)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Text(
                  'Testing... ($currentTestIndex/${LembagaSlugs.allSlugs.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: currentTestIndex / LembagaSlugs.allSlugs.length,
                ),
              ],
            ),
          ),

        // Results summary
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard(
                'Total',
                LembagaSlugs.allSlugs.length.toString(),
                Colors.blue,
              ),
              _buildSummaryCard(
                'Success',
                testResults.values.where((v) => v == '✅').length.toString(),
                Colors.green,
              ),
              _buildSummaryCard(
                'Error',
                testResults.values
                    .where((v) => v.startsWith('❌'))
                    .length
                    .toString(),
                Colors.red,
              ),
              _buildSummaryCard(
                'Empty',
                testResults.values.where((v) => v == '⚪').length.toString(),
                Colors.orange,
              ),
            ],
          ),
        ),

        // Slug list
        Expanded(
          child: ListView.builder(
            itemCount: LembagaSlugs.allSlugs.length,
            itemBuilder: (context, index) {
              final slug = LembagaSlugs.allSlugs[index];
              final nama = LembagaSlugs.getNamaBySlug(slug);
              final status = testResults[slug] ?? '⏳';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(status),
                    child: Text(
                      status,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(
                    nama ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(slug),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Test single slug
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline),
                        onPressed: () => _testSingleSlug(slug),
                      ),
                      // View content
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: status == '✅'
                            ? () => _viewContent(slug, nama ?? '')
                            : null,
                      ),
                      // View raw data
                      IconButton(
                        icon: const Icon(Icons.data_object),
                        onPressed: status == '✅'
                            ? () => _viewRawData(slug, nama ?? '')
                            : null,
                      ),
                    ],
                  ),
                  onTap: () => _showSlugDetails(slug, nama ?? '', status),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '✅':
        return Colors.green;
      case '⚪':
        return Colors.orange;
      case '⏳':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  Future<void> _testAllSlugs() async {
    setState(() {
      isTestingAll = true;
      currentTestIndex = 0;
      testResults.clear();
    });

    for (int i = 0; i < LembagaSlugs.allSlugs.length; i++) {
      final slug = LembagaSlugs.allSlugs[i];
      setState(() => currentTestIndex = i + 1);

      await _testSingleSlug(slug);

      // Small delay to prevent overwhelming the API
      await Future.delayed(const Duration(milliseconds: 200));
    }

    setState(() => isTestingAll = false);

    _showTestCompleteDialog();
  }

  Future<void> _testSingleSlug(String slug) async {
    try {
      print('🧪 Testing slug: $slug');

      final provider = context.read<LembagaProvider>();
      final lembaga =
          await provider.fetchBySlug(slug, forceRefresh: true);
      final errorMessage = provider.lembagaState(slug).errorMessage;

      if (lembaga != null) {
        final hasContent = (lembaga.profilMd?.isNotEmpty == true) ||
            (lembaga.programKerjaMd?.isNotEmpty == true);

        setState(() {
          testResults[slug] = hasContent ? '✅' : '⚪';
        });

        print(
            '✅ Success: $slug ${hasContent ? "(has content)" : "(empty content)"}');
      } else {
        setState(() {
          testResults[slug] =
              errorMessage != null ? '❌ ${_truncateError(errorMessage)}' : '❌ Not found';
        });
        print('❌ Not found: $slug');
      }
    } catch (e) {
      setState(() {
        testResults[slug] = '❌ Error: ${_truncateError(e.toString())}';
      });
      print('❌ Error testing $slug: $e');
    }
  }

  void _clearResults() {
    setState(() {
      testResults.clear();
    });
  }

  void _viewContent(String slug, String nama) async {
    try {
      final lembaga = await context.read<LembagaProvider>().fetchBySlug(slug);
      if (lembaga != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentScreen(
              title: '$nama - Profil',
              markdownContent: lembaga.profilMd ?? 'Tidak ada konten profil',
              type: ContentScreenType.minimal,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _viewRawData(String slug, String nama) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Loading data...'),
            ],
          ),
        ),
      );

      final lembaga = await context.read<LembagaProvider>().fetchBySlug(slug);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        if (lembaga != null) {
          _showRawDataDialog(slug, nama, lembaga);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No data found')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showRawDataDialog(String slug, String nama, Lembaga lembaga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Raw Data: $nama'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataField('ID', lembaga.id?.toString() ?? 'N/A'),
                _buildDataField('Document ID', lembaga.documentId ?? 'N/A'),
                _buildDataField('Nama', lembaga.nama ?? 'N/A'),
                _buildDataField('Slug', lembaga.slug ?? 'N/A'),
                const Divider(),
                const Text('Profil Content:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    lembaga.profilMd ?? 'No profil content',
                    style:
                        const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Characters: ${lembaga.profilMd?.length ?? 0}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                const Text('Program Kerja Content:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    lembaga.programKerjaMd ?? 'No program kerja content',
                    style:
                        const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Characters: ${lembaga.programKerjaMd?.length ?? 0}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                const Divider(),
                _buildDataField(
                    'Created At', lembaga.createdAt?.toString() ?? 'N/A'),
                _buildDataField(
                    'Updated At', lembaga.updatedAt?.toString() ?? 'N/A'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _viewContent(slug, nama);
            },
            child: const Text('View Content'),
          ),
        ],
      ),
    );
  }

  String _truncateError(String message) {
    if (message.length <= 20) return message;
    return message.substring(0, 20) + '...';
  }

  Widget _buildDataField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showSlugDetails(String slug, String nama, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(nama),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Slug: $slug'),
            const SizedBox(height: 8),
            Text('Status: $status'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (status == '✅')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _viewContent(slug, nama);
              },
              child: const Text('View Content'),
            ),
        ],
      ),
    );
  }

  void _showTestCompleteDialog() {
    final total = LembagaSlugs.allSlugs.length;
    final success = testResults.values.where((v) => v == '✅').length;
    final empty = testResults.values.where((v) => v == '⚪').length;
    final errors = testResults.values.where((v) => v.startsWith('❌')).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total Tested: $total'),
            Text('✅ Success with Content: $success'),
            Text('⚪ Success but Empty: $empty'),
            Text('❌ Errors: $errors'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
