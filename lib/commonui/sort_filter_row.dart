import 'package:flutter/material.dart';

class SortFilterRow extends StatelessWidget {
  final VoidCallback? onSortPressed;
  final VoidCallback? onFilterPressed;

  const SortFilterRow({
    super.key,
    this.onSortPressed,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 87,
            height: 36,
            child: OutlinedButton(
              onPressed: onSortPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                side: const BorderSide(color: Color(0xFFC5C6CC), width: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swap_vert, size: 12, color: Color(0xFF8F9098)),
                  SizedBox(width: 4),
                  Text(
                    "Sort",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1F2024),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.keyboard_arrow_down, size: 10, color: Color(0xFF8F9098)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 102,
            height: 36,
            child: OutlinedButton(
              onPressed: onFilterPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                side: const BorderSide(color: Color(0xFFC5C6CC), width: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.filter_list, size: 12, color: Color(0xFF8F9098)),
                  SizedBox(width: 12),
                  Text(
                    "Filter",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1F2024),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
