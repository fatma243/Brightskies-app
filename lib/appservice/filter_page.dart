import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

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

  bool categoryExpanded = false;
  bool priceExpanded = false;
  bool colorExpanded = false;
  bool sizeExpanded = false;
  bool reviewExpanded = false;

  void clearAll() {
    setState(() {
      selectedColors.clear();
      categoryExpanded = false;
      priceExpanded = false;
      colorExpanded = false;
      sizeExpanded = false;
      reviewExpanded = false;
    });
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
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(41, 15),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.0,
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
                    height: 1.0,
                    color: Color(0xFF1F2024),
                  ),
                ),
                TextButton(
                  onPressed: clearAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(49, 15),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Clear All",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.0,
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
            _buildExpansionTile(
              title: 'Category',
              expanded: categoryExpanded,
              onToggle: () => setState(() => categoryExpanded = !categoryExpanded),
              child: const Text('Category options go here'),
            ),
            const SizedBox(height: 2),
            _buildExpansionTile(
              title: 'Price Range',
              expanded: priceExpanded,
              onToggle: () => setState(() => priceExpanded = !priceExpanded),
              child: const Text('Price range sliders or options'),
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
                        isSelected
                            ? selectedColors.remove(color)
                            : selectedColors.add(color);
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0019FF)
                            : const Color(0xFFE5E8FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        color.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          height: 1.0,
                          letterSpacing: 0.5,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF0019FF),
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
            onPressed: () {},
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
                height: 1.0,
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
                    height: 1.43,
                    color: Color(0xFF1F2024),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFF8F9098),
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
