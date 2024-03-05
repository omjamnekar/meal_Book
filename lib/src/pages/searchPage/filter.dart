import 'package:MealBook/respository/model/filter.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterDialog extends ConsumerStatefulWidget {
  FilterDialog({Key? key, required this.callback}) : super(key: key);

  Function(FilterManager) callback;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog> {
  bool onStateChange = false;
  SfRangeValues _currentValues = SfRangeValues(50.0, 150.0);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Filters",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ))
              ],
            ),
            Gap(10),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Divider(
                height: 1,
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
              ),
            ),
            ////////////

            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20),
                  Text("Price Range",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w600)),
                  Text("The  average price of meals: 100/-",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w300)),
                  Gap(10),
                  SfRangeSlider(
                    min: 0.0,
                    max: 200.0,
                    values: _currentValues,
                    interval: 50.0,
                    showLabels: true,
                    enableIntervalSelection: true,
                    showTicks: true,
                    enableTooltip: true,
                    numberFormat: NumberFormat.currency(
                        locale: 'en_IN', symbol: '₹', decimalDigits: 0),
                    onChanged: (SfRangeValues newValues) {
                      setState(() {
                        _currentValues = newValues;

                        onStateChange = true;
                      });

                      if (newValues.start != newValues.end) {
                        // Call a method to update your graph based on new slider values
                        //updateGraph(newValues.start, newValues.end);
                      }
                    },
                  ),
                  Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Min price",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Text("₹${_currentValues.start.toInt()}"),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Max price",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Text("₹${_currentValues.end.toInt()}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ////////////////
            Spacer(),
            Center(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                child: TextButton.icon(
                    onPressed: () {
                      if (onStateChange) {
                        widget.callback(FilterManager(
                          isActive: onStateChange,
                          minPrice: _currentValues.start.toInt(),
                          maxPrice: _currentValues.end.toInt(),
                        ));
                      }

                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 150, vertical: 10)),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.onSecondaryContainer),
                    ),
                    icon: Icon(
                      Icons.filter_b_and_w_rounded,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    label: Text("Apply",
                        style: GoogleFonts.poppins(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
