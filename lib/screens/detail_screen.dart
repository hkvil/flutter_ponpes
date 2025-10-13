import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pesantren_app/widgets/top_banner.dart';
import 'package:pesantren_app/widgets/bottom_banner.dart';
import 'package:pesantren_app/widgets/detail_layout.dart';
import 'package:pesantren_app/widgets/banner_widget.dart';
import 'package:pesantren_app/models/banner_config.dart';

import '../widgets/responsive_wrapper.dart';
import '../core/utils/menu_slug_mapper.dart';
import '../models/lembaga_model.dart';
import '../providers/lembaga_provider.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final List<String> menuItems;

  const DetailScreen({
    Key? key,
    required this.title,
    required this.menuItems,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _lembagaSlug;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _lembagaSlug = MenuSlugMapper.getSlugByMenuTitle(widget.title);

    if (_lembagaSlug != null && _lembagaSlug!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LembagaProvider>().fetchBySlug(_lembagaSlug!);
      });
    }
  }

  BannerConfig _createBannerConfig(Lembaga? lembaga) {
    if (lembaga != null) {
      return BannerConfig.fromLembaga(
        lembaga.topBanner,
        lembaga.botBanner,
      );
    }

    return const BannerConfig();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 12.0 : 16.0;
    final verticalPadding = isMobile ? 8.0 : 16.0;

    final provider = context.watch<LembagaProvider>();
    final lembagaState =
        _lembagaSlug != null ? provider.lembagaState(_lembagaSlug!) : null;
    final lembaga = lembagaState?.data;
    final isLoadingData = lembagaState?.isLoading ?? false;
    final loadingError = lembagaState?.errorMessage;
    final bannerConfig = _createBannerConfig(lembaga);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            (lembaga != null && bannerConfig.hasTopBanner)
                ? BannerWidget(
                    bannerConfig: bannerConfig,
                    isTopBanner: true,
                    height: 150,
                  )
                : TopBanner(
                    assetPath: 'assets/banners/top.png',
                    height: 150,
                  ),
            Expanded(
              child: ListView(
                children: [
                  if (isLoadingData)
                    Container(
                      padding: EdgeInsets.all(horizontalPadding),
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: horizontalPadding,
                            height: horizontalPadding,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: horizontalPadding),
                          Expanded(
                            child: Text(
                              'Memuat data ${widget.title}...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (loadingError != null && !isLoadingData)
                    Container(
                      padding: EdgeInsets.all(horizontalPadding),
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange.shade700),
                          SizedBox(width: horizontalPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gagal memuat data online',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  loadingError,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: DetailLayout(
                      title: widget.title,
                      menuItems: widget.menuItems,
                      lembagaSlug: _lembagaSlug,
                      cachedLembaga: lembaga,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: (lembaga != null && bannerConfig.hasBottomBanner)
            ? BannerWidget(
                bannerConfig: bannerConfig,
                isTopBanner: false,
                height: 100,
              )
            : const BottomBanner(assetPath: 'assets/banners/bottom.png'),
      ),
    );
  }
}
