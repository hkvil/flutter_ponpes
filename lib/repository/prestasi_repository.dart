import 'package:dio/dio.dart';

import '../models/prestasi.dart';
import 'base_repository.dart';

class PrestasiRepository extends BaseRepository {
  PrestasiRepository({Dio? dio}) : super(dio: dio);

  Future<List<Prestasi>> getPrestasiByLembaga(
    String lembagaSlug, {
    int? page,
    int? pageSize,
    String? tahun,
    String? tingkat,
    String? type,
  }) {
    final prestasiType = type ?? 'santri';
    final populateSantri = prestasiType == 'santri';
    final populateStaff = prestasiType == 'staff';
    return _fetchPrestasi(
      'lembaga:$lembagaSlug:$prestasiType',
      {
        'populate[santri]': populateSantri,
        'populate[staff]': populateStaff,
        'populate[sertifikat]': true,
        'filters[$prestasiType][lembaga][slug][\$eq]': lembagaSlug,
        if (tahun != null) 'filters[tahun][\$eq]': tahun,
        if (tingkat != null) 'filters[tingkat][\$eq]': tingkat,
        'sort': 'tahun:desc',
        'pagination[pageSize]': pageSize ?? 100,
        if (page != null) 'pagination[page]': page,
      },
    );
  }

  /// Get prestasi by kategori and lembaga
  Future<List<Prestasi>> getPrestasiByKategori(
    String lembagaSlug,
    String kategori, {
    int? page,
    int? pageSize,
  }) {
    return _fetchPrestasi(
      'kategori:$kategori',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[kategori][\$eq]': kategori,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
    );
  }

  /// Get prestasi by tingkat (level) and lembaga
  Future<List<Prestasi>> getPrestasiByTingkat(
    String lembagaSlug,
    String tingkat, {
    int? page,
    int? pageSize,
  }) {
    return _fetchPrestasi(
      'tingkat:$tingkat',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tingkat][\$eq]': tingkat,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
    );
  }

  /// Get prestasi by tahun ajaran and lembaga
  Future<List<Prestasi>> getPrestasiByTahunAjaran(
    String lembagaSlug,
    String tahunAjaranName, {
    int? page,
    int? pageSize,
  }) {
    return _fetchPrestasi(
      'tahun:$tahunAjaranName',
      {
        'filters[lembaga][slug][\$eq]': lembagaSlug,
        'filters[tahunAjaran][nama][\$eq]': tahunAjaranName,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
    );
  }

  /// Get prestasi by santri ID
  Future<List<Prestasi>> getPrestasiBySantriId(
    int santriId, {
    int? page,
    int? pageSize,
  }) {
    return _fetchPrestasi(
      'santri:$santriId',
      {
        'filters[santri][id][\$eq]': santriId,
        'pagination[pageSize]': pageSize ?? 25,
        if (page != null) 'pagination[page]': page,
        'populate': 'deep',
        'sort': 'tanggal:desc',
      },
    );
  }

  Future<List<Prestasi>> _fetchPrestasi(
    String context,
    Map<String, dynamic> queryParameters,
  ) async {
    try {
      final response = await dio.get(
        '/api/prestasis',
        queryParameters: queryParameters,
        options: await buildAuthenticatedOptions(),
      );

      final body = ensureMap(response.data);
      final dataList = (body['data'] as List<dynamic>?) ?? const [];

      if (dataList.isEmpty) {
        return [];
      }

      return dataList
          .whereType<Map<String, dynamic>>()
          .map(Prestasi.fromJson)
          .toList();
    } on DioException catch (e) {
      final message = mapDioError(e);
      print('Error fetching prestasi ($context): $message');
      throw Exception('Failed to fetch prestasi: $message');
    }
  }
}
