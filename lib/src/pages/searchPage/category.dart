import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySearch extends StatefulWidget {
  CategorySearch({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
  });

  IconData icon;
  String title;
  bool isSelected;

  @override
  State<CategorySearch> createState() => _CategorySearchState();
}

class _CategorySearchState extends State<CategorySearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: !widget.isSelected
                ? Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.1)
                : Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.icon,
            color: !widget.isSelected
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
