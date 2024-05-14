import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/asynceChecker.dart';
import 'package:MealBook/src/components/navigateTodetail.dart';
import 'package:MealBook/src/pages/cart/cartMode.dart';
import 'package:MealBook/src/pages/proD/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionBuilder extends ConsumerStatefulWidget {
  OptionBuilder({
    super.key,
    required String selectedFoodCategory,
    required this.ctrl,
  }) : _selectedFoodCategory = selectedFoodCategory;

  final String _selectedFoodCategory;

  final ComboLogic ctrl;

  @override
  ConsumerState<OptionBuilder> createState() => _OptionBuilderState();
}

class _OptionBuilderState extends ConsumerState<OptionBuilder> {
  String image = "";
  @override
  Widget build(
    BuildContext context,
  ) {
    return FutureBuilder<List<dynamic>>(
        future: widget.ctrl.fullData(widget._selectedFoodCategory),
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
                            future: widget.ctrl.fullDataImage(
                                _recData.data![index]["TYPE"],
                                _recData.data![index]["IMAGE"],
                                (imagde) {}),
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
                                          onPressed: () {
                                            Combo combo =
                                                _combo(_recData, index);
                                            ShowCartMode().showCartMode(
                                              ref,
                                              context,
                                              combo,
                                            );
                                          },
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
                                                .onPrimaryContainer,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer
                                                .withOpacity(0.7),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            Combo combo =
                                                _combo(_recData, index);

                                            NavigatorToDetail()
                                                .navigatorToProDetail(
                                                    context,
                                                    [combo],
                                                    _recData.data!,
                                                    false);
                                          },
                                          child: Text(
                                            "Order",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
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

  Combo _combo(AsyncSnapshot<List<dynamic>> _recData, int index) {
    List<String> _ingredients = [];
    _recData.data![index]["INGREDIENTS"].forEach((element) {
      _ingredients.add(element);
    });

    return Combo(
        id: _recData.data![index]["ID"],
        items: _recData.data![index]["ITEMS"],
        rate: _recData.data![index]["RATE"],
        description: _recData.data![index]["DESCRIPTION"],
        category: _recData.data![index]["CATEGORY"],
        available: _recData.data![index]["AVAILABLE"] != "true" ? false : true,
        likes: _recData.data![index]["LIKES"],
        overallRating: _recData.data![index]["OVERALL_RATING"],
        image: _recData.data![index]["IMAGE"],
        isPopular: _recData.data![index]["POPULAR"] != "true" ? false : true,
        isVeg: _recData.data![index]["IS_VEG"] != "true" ? false : true,
        type: _recData.data![index]["TYPE"],
        ingredients: _ingredients);
  }

  void _imageloader(AsyncSnapshot<String> _imageData) {
    setState(() {
      image = _imageData.data!;
    });
  }
}
