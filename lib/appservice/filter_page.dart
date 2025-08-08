import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/appservice/product.dart';
import '../../network/api_client.dart';
import 'filter_bloc.dart';
import 'filter_event.dart';

class FilterPage extends StatefulWidget {
  final int? categoryId;
  final bool searchFlag;

  const FilterPage({
    Key? key,
    this.categoryId,
    this.searchFlag = false,
  })
      : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<String> colors = [
    'BLACK', 'WHITE', 'GREY', 'YELLOW',
    'BLUE', 'PURPLE', 'GREEN', 'RED', 'PINK',
    'ORANGE', 'GOLD', 'SILVER'
  ];
  Set<String> selectedColors = {};

  List<Category> categories = [];
  String? selectedCategorySlug;
  bool isLoadingCategories = true;

  bool categoryExpanded = false;
  bool priceExpanded = false;
  bool colorExpanded = false;
  bool sizeExpanded = false;
  bool reviewExpanded = false;


  RangeValues _currentRangeValues = const RangeValues(0, 1000);
  int _minPrice = 0;
  int _maxPrice = 1000;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      final fetched = await ApiClient(Dio()).getCategories();
      setState(() {
        categories = fetched;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => isLoadingCategories = false);
    }
  }

  void clearAll() {
    setState(() {
      selectedColors.clear();
      selectedCategorySlug = null;
      _currentRangeValues = const RangeValues(0, 1000);
      _minPrice = 0;
      _maxPrice = 1000;
    });
    context.read<FilterBloc>().add(ClearFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size(375, 56),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 20.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF0019FF),
                    ),
                  ),
                ),
                const Text(
                  "Filter",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1F2024),
                  ),
                ),
                TextButton(
                  onPressed: clearAll,
                  child: const Text(
                    "Clear All",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF0019FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: ListView(
          children: [
            if (widget.searchFlag)
                _buildExpansionTile(
                title: 'Category',
                expanded: categoryExpanded,
                onToggle: () =>
                    setState(() => categoryExpanded = !categoryExpanded),
                child: isLoadingCategories
                    ? const CircularProgressIndicator()
                    : Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: categories.map((category) {
                    final isSelected = selectedCategorySlug == category.slug;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategorySlug =
                          isSelected ? null : category.slug;
                        });
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 60, maxWidth: 100, minHeight: 28),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0019FF)
                              : const Color(0xFFE5E8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            category.slug.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              letterSpacing: 0.5,
                              color: isSelected ? Colors.white : const Color(
                                  0xFF0019FF),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

                const SizedBox(height: 2),
                _buildExpansionTile(
                  title: 'Price Range',
                  expanded: priceExpanded,
                  onToggle: () =>
                      setState(() => priceExpanded = !priceExpanded),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price Range: \$${_currentRangeValues.start
                            .round()} - \$${_currentRangeValues.end.round()}",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xFF1F2024),
                        ),
                      ),
                      const SizedBox(height: 12),
                      RangeSlider(
                        values: _currentRangeValues,
                        min: 0,
                        max: 2000,
                        activeColor: const Color(0xFF0019FF),
                        inactiveColor: const Color(0xFFD4D6DD),
                        labels: RangeLabels(
                          '\$${_currentRangeValues.start.round()}',
                          '\$${_currentRangeValues.end.round()}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _currentRangeValues = values;
                            _minPrice = values.start.round();
                            _maxPrice = values.end.round();
                          });
                        },
                      ),
                    ],
                  ),
                ),

            const SizedBox(height: 2),
            _buildExpansionTile(
              title: 'Color',
              expanded: colorExpanded,
              onToggle: () => setState(() => colorExpanded = !colorExpanded),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: colors.map((color) {
                  final isSelected = selectedColors.contains(color);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected ? selectedColors.remove(color) : selectedColors.add(color);
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0019FF) : const Color(0xFFE5E8FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        color.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          letterSpacing: 0.5,
                          color: isSelected ? Colors.white : const Color(0xFF0019FF),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 2),
            _buildExpansionTile(
              title: 'Size',
              expanded: sizeExpanded,
              onToggle: () => setState(() => sizeExpanded = !sizeExpanded),
              child: const Text('Size options go here'),
            ),
            const SizedBox(height: 2),
            _buildExpansionTile(
              title: 'Customer Review',
              expanded: reviewExpanded,
              onToggle: () => setState(() => reviewExpanded = !reviewExpanded),
              child: const Text('Star rating selection or sliders'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              final selectedCategory = selectedCategorySlug != null
                  ? categories.firstWhere((cat) => cat.slug == selectedCategorySlug)
                  : null;

              final categoryId = selectedCategory?.id ?? widget.categoryId;
              final categorySlug = selectedCategory?.slug ?? '';

              context.read<FilterBloc>().add(
                ApplyFilters(
                  categoryId: categoryId,
                  categorySlug: categorySlug,
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                ),
              );

              if (widget.searchFlag) {
                if (categoryId != null) {
                  Navigator.pop(context, {
                    'categoryId': categoryId,
                    'priceRange': _currentRangeValues,
                    'sortOption': null,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a category to view results.")),
                  );
                }
              } else {
                Navigator.pop(context);
              }

            },


            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0019FF),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Apply Filters",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF1F2024),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF8F9098),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: child,
          ),
        const Divider(
          thickness: 0.5,
          color: Color(0xFFD4D6DD),
        ),
      ],
    );
  }
}
