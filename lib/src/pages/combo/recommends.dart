import 'package:MealBook/controller/comboLogic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionBuilder extends StatelessWidget {
  OptionBuilder({
    super.key,
    required String selectedFoodCategory,
    required this.ctrl,
  }) : _selectedFoodCategory = selectedFoodCategory;

  final String _selectedFoodCategory;

  final ComboLogic ctrl;
  @override
  Widget build(BuildContext context) {
    print(_selectedFoodCategory);
    return FutureBuilder<List<dynamic>>(
        future: ctrl.fullData(_selectedFoodCategory),
        builder: (context, AsyncSnapshot<List> _recData) {
          if (_recData.connectionState == ConnectionState.waiting &&
              !_recData.hasData) {
            return AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: MediaQuery.of(context).size.width,
              height: 200 * 10,
              margin: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      margin: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 200,
                      color: Theme.of(context).focusColor,
                    );
                  }),
            );
          } else if (_recData.connectionState == ConnectionState.done &&
              _recData.hasData) {
            return AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: MediaQuery.of(context).size.width,
              height: 170 * _recData.data!.length.toDouble(),
              child: ListView.builder(
                itemCount: _recData.data!.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        FutureBuilder(
                            future: ctrl.fullDataImage(
                                _recData.data![index]["TYPE"],
                                _recData.data![index]["IMAGE"]),
                            builder:
                                (context, AsyncSnapshot<String> _imageData) {
                              if (_imageData.connectionState ==
                                      ConnectionState.waiting &&
                                  !_imageData.hasData) {
                                return AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  width: 120,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    color: Colors.grey,
                                  ),
                                );
                              } else if (_imageData.connectionState ==
                                      ConnectionState.active &&
                                  !_imageData.hasData) {
                                return AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  width: 120,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    color: Colors.grey,
                                  ),
                                );
                              } else if (_imageData.connectionState ==
                                      ConnectionState.done &&
                                  _imageData.hasData) {
                                return AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  width: 120,
                                  height: 120,
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          _imageData.data!,
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                );
                              }
                              return AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                width: 120,
                                height: 150,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  color: Colors.grey,
                                ),
                              );
                            }),
                        //Details
                        Container(
                          margin: const EdgeInsets.only(
                            left: 15,
                            top: 13,
                            bottom: 13,
                          ),
                          width: 230,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_recData.data![index]["ITEMS"]}",
                                maxLines: 1,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${_recData.data![index]["DESCRIPTION"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  Text(
                                    "${_recData.data![index]["RATE"]}Rs",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  Text(
                                    " / 1 Piece",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  Text(
                                    " ${_recData.data![index]["LIKES"]} likes",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                  ),
                                ],
                              ),
                              Container(
                                width: 230,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.1),
                                height: 1,
                                margin:
                                    const EdgeInsets.only(top: 3, bottom: 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.star,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5)),
                                  const Gap(2),
                                  Text(
                                      "${_recData.data![index]["OVERALL_RATING"]}"),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Add",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                          )),
                                      const Gap(6),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .tertiaryContainer,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer
                                                .withOpacity(0.7),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            "Order",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onTertiaryContainer,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    color: Theme.of(context).focusColor,
                  );
                });
          }
        });
  }
}
