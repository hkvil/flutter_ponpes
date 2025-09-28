import 'donasi_model.dart';

class PaginationMeta {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 25,
      pageCount: json['pageCount'] ?? 1,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'pageCount': pageCount,
      'total': total,
    };
  }
}

class DonasiApiResponse {
  final List<DonasiModel> data;
  final PaginationMeta meta;

  DonasiApiResponse({
    required this.data,
    required this.meta,
  });

  factory DonasiApiResponse.fromJson(Map<String, dynamic> json) {
    return DonasiApiResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => DonasiModel.fromJson(item))
              .toList() ??
          [],
      meta: PaginationMeta.fromJson(json['meta']?['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'meta': {
        'pagination': meta.toJson(),
      },
    };
  }
}
