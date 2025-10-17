class PaginationMeta {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  const PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] as Map<String, dynamic>;
    return PaginationMeta(
      page: pagination['page'] as int,
      pageSize: pagination['pageSize'] as int,
      pageCount: pagination['pageCount'] as int,
      total: pagination['total'] as int,
    );
  }

  bool get hasNextPage => page < pageCount;
  bool get hasPreviousPage => page > 1;
  int get nextPage => hasNextPage ? page + 1 : page;
  int get previousPage => hasPreviousPage ? page - 1 : page;
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  const PaginatedResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final dataList = (json['data'] as List<dynamic>?) ?? const [];
    final meta = PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>);

    return PaginatedResponse(
      data: dataList.whereType<Map<String, dynamic>>().map(fromJson).toList(),
      meta: meta,
    );
  }
}
