import 'package:pesantren_app/models/lembaga_model.dart';
import '../config.dart';

class LembagaRepository {
  /// Ambil daftar lembaga untuk menu (nama + slug + timestamp)
  Future<List<Lembaga>> fetchAll() async {
    final response = await AppConfig.dio.get('/api/lembagas', queryParameters: {
      'fields[0]': 'nama',
      'fields[1]': 'slug',
      'fields[2]': 'createdAt',
      'fields[3]': 'updatedAt',
      'sort': 'nama:asc',
      'pagination[pageSize]': AppConfig.defaultPageSize,
    });
    final body = response.data as Map<String, dynamic>;
    return Lembaga.listFromStrapiEnvelope(body);
  }

  /// Ambil detail lembaga by slug, lengkap dengan images/videos/kontak
  Future<Lembaga?> fetchBySlug(String slug) async {
    final response = await AppConfig.dio.get('/api/lembagas', queryParameters: {
      'filters[slug][\$eq]': slug,
      'populate[images][populate]': 'media',
      'populate[videos]': '*',
      'populate[kontak]': '*',
      'pagination[pageSize]': 1,
    });
    final body = response.data as Map<String, dynamic>;
    final data = (body['data'] as List?) ?? const [];
    if (data.isEmpty) return null;
    return Lembaga.fromJson(data.first as Map<String, dynamic>);
  }
}
