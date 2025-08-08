import 'package:flutter/material.dart';
import 'package:my_app/appservice/sort_option.dart';

abstract class SearchEvent {}
class PerformSearch extends SearchEvent {
  final String query;
  PerformSearch(this.query);
}

class LoadCategoryProducts extends SearchEvent {
  final int? categoryId;
  LoadCategoryProducts({this.categoryId});
}
class SortProducts extends SearchEvent {
  final SortOption option;
  SortProducts(this.option);
}

class ApplyFilters extends SearchEvent {
  final int? categoryId;
  final RangeValues? priceRange;

  ApplyFilters({
    this.categoryId,
    this.priceRange,
  });
}






