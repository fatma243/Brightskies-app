import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_app/appservice/product.dart';
import 'filter_event.dart';
import 'filter_state.dart';

@injectable
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc()
      : super(
    FilterState(
      categoryId: null,
      filter: ProductFilter(
        categorySlug: null,
        minPrice: 0,
        maxPrice: 1000,
      ),
    ),
  ) {
    on<ApplyFilters>((event, emit) {

      final updatedFilter = ProductFilter(
        categorySlug: event.categorySlug ?? state.filter.categorySlug,
        minPrice: event.minPrice ?? state.filter.minPrice,
        maxPrice: event.maxPrice ?? state.filter.maxPrice,
      );

      emit(FilterState(
        categoryId: event.categoryId ?? state.categoryId,
        filter: updatedFilter,
      ));
    });

    on<ClearFilter>((event, emit) {
      emit(
        FilterState(
          categoryId: null,
          filter: ProductFilter(
            categorySlug: null,
            minPrice: 0,
            maxPrice: 1000,
          ),
        ),
      );
    });
  }
}
