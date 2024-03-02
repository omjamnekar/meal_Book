import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            Gap(50),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width / 1.4,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.1),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  // Filter
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.dashboard_outlined),
                  ),
                ],
              ),
            ),
            Gap(10),
            Container(
              margin: const EdgeInsets.only(left: 27, right: 27),
              width: MediaQuery.sizeOf(context).width,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategorySearch(
                    icon: Icons.emoji_food_beverage,
                    title: "Breakfast",
                  ),
                  Gap(20),
// Dessert
                  CategorySearch(
                    icon: Icons.icecream,
                    title: "Dessert",
                  ),

                  Gap(20),
                  CategorySearch(
                    icon: Icons.fastfood_rounded,
                    title: "Meal",
                  ),

                  Gap(20),
                  Material(
                    color: Colors.transparent,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 20),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer
                              .withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "More",
                          style: GoogleFonts.poppins(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant),
                        )),
                  ),
                ],
              ),
            ),
            //heading
            Gap(50),
            Container(
              margin: const EdgeInsets.only(left: 27, right: 27),
              width: MediaQuery.sizeOf(context).width,
              child: Text(
                "FOOD MENU",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.5),
                ),
              ),
            ),

            Gap(20),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 150,
              alignment: Alignment.center,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 35),
                itemBuilder: (context, index) {
                  return Container(
                    width: 130,
                    height: 110,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "PAV BHAJI",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class CategorySearch extends StatelessWidget {
  CategorySearch({
    super.key,
    required this.icon,
    required this.title,
  });

  IconData icon;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(onPressed: () {}, icon: Icon(icon)),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
