class Paginator<T> {
  static const int DEFAULT_ITEM_PER_PAGE = 20;

  final List<T> items;
  final int totalItems;

  Paginator({
    required this.items,
    required this.totalItems,
  });

  int get totalPages => (totalItems / Paginator.DEFAULT_ITEM_PER_PAGE).ceil();
  bool hasMore(int currentPage) => currentPage < totalPages;
}