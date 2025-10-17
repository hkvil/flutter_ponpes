import 'package:flutter/foundation.dart';

import '../models/santri.dart';
import '../models/pagination.dart';
import '../repository/santri_repository.dart';
import 'async_value.dart';

class SantriProvider extends ChangeNotifier {
  SantriProvider({SantriRepository? repository})
      : _repository = repository ?? SantriRepository();

  final SantriRepository _repository;
  final Map<String, AsyncValue<List<Santri>>> _santriStates = {};
  final Map<String, AsyncValue<List<Santri>>> _alumniStates = {};

  // Pagination states
  final Map<String, PaginationMeta?> _santriPagination = {};
  final Map<String, PaginationMeta?> _alumniPagination = {};
  final Map<String, bool> _santriHasMorePages = {};
  final Map<String, bool> _alumniHasMorePages = {};

  AsyncValue<List<Santri>> santriState(String slug) {
    return _santriStates.putIfAbsent(
      slug,
      () => AsyncValue<List<Santri>>(data: const []),
    );
  }

  AsyncValue<List<Santri>> alumniState(String slug, {String? tahunMasuk}) {
    final key = _alumniKey(slug, tahunMasuk);
    return _alumniStates.putIfAbsent(
      key,
      () => AsyncValue<List<Santri>>(data: const []),
    );
  }

  PaginationMeta? santriPagination(String slug) => _santriPagination[slug];
  PaginationMeta? alumniPagination(String slug, {String? tahunMasuk}) =>
      _alumniPagination[_alumniKey(slug, tahunMasuk)];

  bool santriHasMorePages(String slug) => _santriHasMorePages[slug] ?? true;
  bool alumniHasMorePages(String slug, {String? tahunMasuk}) =>
      _alumniHasMorePages[_alumniKey(slug, tahunMasuk)] ?? true;

  Future<List<Santri>> fetchSantriByLembaga(
    String slug, {
    bool forceRefresh = false,
    int page = 1,
    int pageSize = 20,
  }) async {
    final state = santriState(slug);
    if (state.isLoading) return state.data ?? const [];

    // If not force refresh and we have data, check if we need to load more
    if (!forceRefresh && state.hasLoaded && page == 1) {
      return state.data ?? const [];
    }

    // For pagination, we always load when requested
    if (page == 1) {
      state.startLoading();
    }

    notifyListeners();

    try {
      final response = await _repository.getSantriByLembaga(
        slug,
        page: page,
        pageSize: pageSize,
      );

      final currentData = page == 1 ? <Santri>[] : (state.data ?? <Santri>[]);
      final newData = [...currentData, ...response.data];

      state.setData(List.unmodifiable(newData));

      // Update pagination info
      _santriPagination[slug] = response.meta;
      _santriHasMorePages[slug] = response.meta.page < response.meta.pageCount;

      return newData;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMoreSantri(String slug) async {
    final currentPage = santriPagination(slug)?.page ?? 1;
    if (!santriHasMorePages(slug)) return;

    await fetchSantriByLembaga(slug, page: currentPage + 1);
  }

  Future<List<Santri>> fetchAlumniByLembaga(
    String slug, {
    String? tahunMasuk,
    bool forceRefresh = false,
    int page = 1,
    int pageSize = 20,
  }) async {
    final state = alumniState(slug, tahunMasuk: tahunMasuk);
    if (state.isLoading) return state.data ?? const [];

    // If not force refresh and we have data, check if we need to load more
    if (!forceRefresh && state.hasLoaded && page == 1) {
      return state.data ?? const [];
    }

    // For pagination, we always load when requested
    if (page == 1) {
      state.startLoading();
    }

    notifyListeners();

    try {
      final response = await _repository.getAlumniByLembaga(
        slug,
        page: page,
        pageSize: pageSize,
        tahunMasuk: tahunMasuk,
      );

      final currentData = page == 1 ? <Santri>[] : (state.data ?? <Santri>[]);
      final newData = [...currentData, ...response.data];

      state.setData(List.unmodifiable(newData));

      // Update pagination info
      final key = _alumniKey(slug, tahunMasuk);
      _alumniPagination[key] = response.meta;
      _alumniHasMorePages[key] = response.meta.page < response.meta.pageCount;

      return newData;
    } catch (error) {
      state.setError(error);
      return state.data ?? const [];
    } finally {
      notifyListeners();
    }
  }

  Future<List<Santri>> loadMoreAlumni(String slug, {String? tahunMasuk}) async {
    final currentPage =
        alumniPagination(slug, tahunMasuk: tahunMasuk)?.page ?? 1;
    if (!alumniHasMorePages(slug, tahunMasuk: tahunMasuk)) return [];

    await fetchAlumniByLembaga(slug,
        tahunMasuk: tahunMasuk, page: currentPage + 1);
    return alumniState(slug, tahunMasuk: tahunMasuk).data ?? [];
  }

  Future<PaginatedResponse<Santri>> getSantriByLembagaAndKelas(
    String lembagaSlug,
    String kelasName, {
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getSantriByLembagaAndKelas(
      lembagaSlug,
      kelasName,
      page: page,
      pageSize: pageSize,
    );
  }

  String _alumniKey(String slug, String? tahunMasuk) {
    final tahunKey = tahunMasuk ?? 'all';
    return '$slug|$tahunKey';
  }
}
