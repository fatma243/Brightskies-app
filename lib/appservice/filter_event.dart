import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class ApplyFilters extends FilterEvent {
  final int? categoryId;
  final String? categorySlug;
  final int? minPrice;
  final int? maxPrice;

  const ApplyFilters({
    this.categoryId,
    this.categorySlug,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [
    categoryId,
    categorySlug,
    minPrice,
    maxPrice,
  ];
}

class ClearFilter extends FilterEvent {
  @override
  List<Object?> get props => [];
}
