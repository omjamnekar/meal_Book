import 'dart:math';

import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/controller/homeLogic.dart';
import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:MealBook/src/payments/pay_Op.dart';
import 'package:MealBook/src/payments/stepControl/Time_Con.dart';
import 'package:MealBook/src/payments/timeSetting/am.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popover/popover.dart';
import 'package:shimmer/shimmer.dart';

import '../../../respository/model/combo.dart';

class TimeSetter extends StatefulWidget {
  bool isCart;
  List<Combo> combo;
  Function(OrderTimeControl) onTimeSetted;
  TimeSetter({
    super.key,
    required this.isCart,
    required this.combo,
    required this.onTimeSetted,
  });

  @override
  State<TimeSetter> createState() => _TimeSetterState();
}

class _TimeSetterState extends State<TimeSetter> {
  // initial time setted
  TimeSet currentTime =
      TimeSet(hour: 0, minute: 0, timeOfDayLink: TimeOfDayLink.AM);

  PageController _pageController = PageController();
  int hour = 0;
  int minute = 0;
  TimeOfDayLink timeOfDayLink = TimeOfDayLink.AM;
  bool isValidationForSave = false;

  _loadTime() {
    DateTime time = DateTime.now().add(const Duration(minutes: 15));

    int hour12 = time.hour > 12 ? time.hour - 12 : time.hour;
    if (hour12 == 0) {
      hour12 = 12; // 12 AM should be represented as 12, not 0
    }

    currentTime = TimeSet(
      hour: hour12,
      minute: time.minute,
      timeOfDayLink: time.hour < 12 ? TimeOfDayLink.AM : TimeOfDayLink.PM,
    );

    //   current time
  }

  late TimeSet userSelectedTime =
      TimeSet(hour: 0, minute: 0, timeOfDayLink: TimeOfDayLink.AM);
  _timeCheckOfValidation() {
    // user time setted is not filled

    if (hour == 7 && timeOfDayLink == TimeOfDayLink.PM) {
      return "Invalid time, hour is 7 and time is PM";
    }
    if (hour == 6 && timeOfDayLink == TimeOfDayLink.PM && minute > 0) {
      return "Invalid time, canteen open till 6 o'clock";
    }
    if (hour == 0) {
      return "Please, set the time";
    } else if (hour <= 12 && minute > 59) {
      return "hours or minutes are invalid";
    } else if (timeOfDayLink == TimeOfDayLink.AM) {
      //userDefine time need to be less then  12
      if (hour > 12) {
        return "Invalid time, hour is more than 12";
      }
      //userdefin time should be more than 7.45 am
      else if (hour < 7 || (hour == 7 && minute < 45)) {
        return "Invalid time, hour is less than 7.45 am";
      }

      // userDefine time should be ahead of the current time
      else if (hour < currentTime.hour) {
        return "Invalid time, hour is less than current time hour";
      } else if (hour == currentTime.hour && minute < currentTime.minute) {
        return "Invalid time minute is less than current time minute";
      }

      if (hour == 12 && timeOfDayLink == TimeOfDayLink.AM) {
        return "Invalid time hour is 12 and time is AM";
      } else {
        setState(() {
          userSelectedTime = TimeSet(
            hour: hour,
            minute: minute,
            timeOfDayLink: timeOfDayLink,
          );
        });
        return null;
      }
    } else if ((hour > 0 && hour >= 12) && timeOfDayLink == TimeOfDayLink.PM) {
      //if hours are less then 6 it is valid at the same time if it is 12 pm then also we can say it is valid

      if (hour > 12 || hour < 6 || (hour == 6 && minute > 0)) {
        return "Invalid time. Canteen is open from 12 PM to 6 PM.";
      }
      if (hour != 12) {
        if (hour > 6) {
          return "Invalid time. Canteen is open from 12 PM to 6 PM.";
        }
      } else if (hour < currentTime.hour || (minute < currentTime.minute)) {
        return "Invalid time hour is less than current time hour";
      } else if (hour == currentTime.hour && minute < currentTime.minute) {
        return "Invalid time minute is less than current time minute";
      } else {
        userSelectedTime = TimeSet(
          hour: hour,
          minute: minute,
          timeOfDayLink: timeOfDayLink,
        );

        return null;
      }
    }
  }

  _verifyStateTime() {
    final state = _timeCheckOfValidation();

    if (state == null) {
      return true;
    } else {
      return state;
    }
  }

  _pageNextCtrl() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTime();
    _opacity();
  }

  _opacity() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isOpacity = true;
      });
    });
  }

  bool isOpacity = false;
  OrderTimeControl orderTimeControl = OrderTimeControl();
  @override
  Widget build(BuildContext context) {
    _loadTime();
    return Scaffold(
      body: GetBuilder<OrderTimeControl>(
        init: orderTimeControl,
        builder: (ctrl) {
          return SingleChildScrollView(
            child: SafeArea(
              child: AnimatedOpacity(
                opacity: isOpacity ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 237, 237, 237),
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                ),
                              ],
                              color: const Color.fromARGB(255, 255, 251, 251),
                            ),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const Gap(20),
                          const Text(
                            'Setup Time',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w400),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: _infoDialogSetter,
                              icon: const Icon(Icons.info_outline)),
                        ],
                      ),
                      const Gap(20),
                      //description for the start
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Column(
                          children: [
                            // time comup which is 30 minutes after the current time
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentTime.time.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                // Text(currentTime.timeOfDayLink.name)
                                Gap(30),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  child: Icon(
                                    Icons.question_mark_outlined,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
                            // description for the time
                            Text(
                              "After ${currentTime.hour}:${currentTime.hour} ${currentTime.timeOfDayLink.name}, you're welcome to specify your arrival time.",
                              style: GoogleFonts.poppins(
                                  fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      //TextField input for the time
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 80,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                onSaved: (value) {
                                  if (value!.isEmpty ||
                                      value.length <= 1 ||
                                      value.length >= 12) {
                                    return;
                                  }
                                },
                                onFieldSubmitted: (_) {
                                  // Focus on the next text field
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                  hintText: "00",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isValidationForSave = false;
                                    hour = int.parse(value);
                                  });
                                },
                              ),
                            ),
                            const Gap(10),

                            // colon
                            Text(
                              ":",
                              style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  color: Theme.of(context).colorScheme.primary),
                            ),

                            const Gap(10),
                            // minutes
                            Container(
                              width: 70,
                              height: 80,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                onSaved: (value) {
                                  if (value!.isEmpty || value.length <= 59) {
                                    return;
                                  }
                                },
                                onFieldSubmitted: (_) {
                                  // Focus on the next text field
                                  FocusScope.of(context).nextFocus();
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                  hintText: "00",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isValidationForSave = false;
                                    minute = int.parse(value);
                                  });
                                },
                              ),
                            ),
                            const Gap(10),

                            //am or pm
                            Container(
                              width: 90,
                              height: 80,
                              child: DropdownButtonFormField<String>(
                                value: "am",
                                borderRadius: BorderRadius.circular(10),
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                onChanged: (value) {
                                  setState(() {
                                    isValidationForSave = false;
                                    timeOfDayLink = value == "am"
                                        ? TimeOfDayLink.AM
                                        : TimeOfDayLink.PM;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: "am",
                                    child: Text(
                                      "AM",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "pm",
                                    child: Text(
                                      "PM",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: 90,
                          alignment: Alignment.center,
                          child: Text(
                            "please, set time when you will arrive for meal !",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      //button for the time
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final variefy = _verifyStateTime();

                            if (variefy.runtimeType == bool &&
                                variefy == true) {
                              setState(() {
                                isValidationForSave = true;
                              });
                            } else if (variefy != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(variefy.toString()),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ));
                            }
                          },
                          label: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.save_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Gap(40),
                      //Navigator of container
                      Container(
                        margin: const EdgeInsets.only(
                            top: 10, left: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Orders",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6)),
                            ),
                            TextButton(
                              onPressed: () {
                                _pageNextCtrl();
                              },
                              child: const Text("Next"),
                            ),
                          ],
                        ),
                      ),
                      //Container for the Product we about to order
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: PageView.builder(
                          itemCount: widget.combo.length,
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return FutureBuilder<String>(
                                future: ComboLogic().fullDataImage(
                                    widget.combo[index].type,
                                    widget.combo[index].image,
                                    (image) {}),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> image) {
                                  if (image.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                60,
                                        height: 190,
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.withOpacity(0.5),
                                          Colors.grey.withOpacity(0.2)
                                        ],
                                      ),
                                    );
                                  } else if (image.connectionState ==
                                      ConnectionState.none) {
                                    return Shimmer(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                60,
                                        height: 190,
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.withOpacity(0.5),
                                          Colors.grey.withOpacity(0.2)
                                        ],
                                      ),
                                    );
                                  } else if (image.connectionState ==
                                          ConnectionState.done &&
                                      image.hasData) {
                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 237, 237, 237),
                                            offset: Offset(0, 0),
                                            blurRadius: 10,
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            image.data ??
                                                "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fphotos%2Fburger&psig=AOvVaw3Q6Z   ",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                      height: 150,
                                      child: Container(
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer
                                              .withOpacity(0.5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      "${widget.combo[index].likes} likes",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .background),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: double.maxFinite,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 180,
                                                            child: Text(
                                                              "${widget.combo[index].items}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .tertiary
                                                                      .withOpacity(
                                                                          0.7)),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Price: ${widget.combo[index].rate}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                      0.6),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              "popularity:",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .tertiaryFixed
                                                                      .withOpacity(
                                                                          0.6),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                      0.8),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "${23}%",
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        20,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .background),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Shimmer(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      height: 190,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.withOpacity(0.5),
                                        Colors.grey.withOpacity(0.2)
                                      ],
                                    ),
                                  );
                                  ;
                                });
                          },
                        ),
                      ),
                      const Gap(30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 190,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _heading.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    _icons[index],
                                    size: 30,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const Gap(5),
                                  Text(
                                    _heading[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Gap(2),
                                  Text(
                                    _description[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const Gap(55),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomSheet: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: isOpacity ? 1.0 : 0.0,
        child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: isValidationForSave
                ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                : Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: GestureDetector(
            onTap: _proceedToOrderPay,
            // onTap: () {
            //   widget.onTimeSetted(orderTimeControl);
            // },
            child: Center(
              child: Text(
                "Proceed to Payment",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _infoDialogSetter() {
    return showDialog(
        context: context,
        barrierColor: Theme.of(context).colorScheme.background.withOpacity(0.9),
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Info",
              style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.primary),
            ),
            surfaceTintColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            // dialog color
            content: InfoSetUp(time: currentTime),
            shadowColor: Theme.of(context).backgroundColor,
          );
        });
  }

  final List<String> _heading = [
    "Order Accuracy",
    "Data Integrity",
    "Accountability",
    "Fairness to Others",
    "Service Improvement",
    "Community Contribution",
  ];

  final List<String> _description = [
    "Explain how accurate time reporting ensures that orders are processed and delivered promptly. ",
    "Emphasize the significance of accurate time data in maintaining the integrity of your app's data. ",
    "providing truthful information fosters trust between users and the app/service provider, and helps uphold the credibility of the platform.",
    "Explain that providing honest time entries ensures fairness to other users and helps maintain a level playing field for all.",
    "Highlight that accurate time data allows you to identify areas for service improvement.",
    " Encourage users to see accurate time reporting as a way to contribute positively to the community."
  ];
  final List<IconData> _icons = [
    Icons.room_service_outlined,
    Icons.data_array,
    Icons.switch_account_outlined,
    Icons.favorite_rounded,
    Icons.self_improvement_rounded,
    Icons.group_add_outlined,
  ];

  void _proceedToOrderPay() {
    if (isValidationForSave == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              title: const Text("Info"),
              content: const Text("Please select appropriate time"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          });
    } else {
      int hour24 = hour;
      if (userSelectedTime.timeOfDayLink == TimeOfDayLink.PM && hour != 12) {
        hour24 += 12;
      } else if (userSelectedTime.timeOfDayLink == TimeOfDayLink.AM &&
          hour == 12) {
        hour24 = 0; // 12 AM should be represented as 0 hour in 24-hour format
      }

      DateTime orderUserTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour24,
        minute,
      );
      orderTimeControl.setValue(
        DateTime.now(),
        orderUserTime,
      );
    }

    widget.onTimeSetted(orderTimeControl);
  }
}

class InfoSetUp extends StatelessWidget {
  InfoSetUp({
    super.key,
    required this.time,
  });
  TimeSet time;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 300,
        child: Column(
          children: [
            // time comup which is 30 minutes after the current time
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${time.hour}:${time.minute}",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    )),
                Text(time.timeOfDayLink.name),
              ],
            ),
            const Gap(30),
            // description for the time
            Text(
                "After ${time.hour}:${time.minute} ${time.timeOfDayLink.name}, you're welcome to specify your arrival time."),
            const Gap(10),
            const Text(
                "when your order is placed it goes to the canteen 15 minutes before the consumer's specificed time, so that you can injoy it fresh when you arrive on your time."),
            const Gap(20),
            const Text("Canteen will be closed at 6:00 AM."),
          ],
        ));
  }
}

class TimeSet {
  int hour;
  int minute;
  TimeOfDayLink timeOfDayLink;
  TimeSet(
      {required this.hour, required this.minute, required this.timeOfDayLink});

  String get time {
    return "${hour.toString().padLeft(2, '0')}.${minute.toString().padLeft(2, '0')} ${timeOfDayLink.toString().split(".")[1]}";
  }

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
      'timeOfDayLink': timeOfDayLink.toString(),
    };
  }

  static TimeSet fromMap(Map<String, dynamic> map) {
    return TimeSet(
      hour: map['hour'],
      minute: map['minute'],
      timeOfDayLink: TimeOfDayLink.values.firstWhere(
        (value) => value.toString() == map['timeOfDayLink'],
      ),
    );
  }
}

class InfoSetUp2 extends StatelessWidget {
  InfoSetUp2({
    super.key,
    required this.time,
  });
  TimeSet time;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 300,
        child: Column(
          children: [
            // time comup which is 30 minutes after the current time
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${time.hour}:${time.minute}",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    )),
                Text(time.timeOfDayLink.name),
              ],
            ),
            const Gap(30),
            // description for the time
            Text(
                "we always welcome you to specify your arrival time, due to the time take for cooking this food takes time."),
            const Gap(10),
            const Text(
                "So, when your order is placed it goes to the canteen 15 minutes before the consumer's specificed time, so that you can injoy it fresh when you arrive on your time."),
            const Gap(20),
            const Text("Even if you are late, we will keep your order ready."),
          ],
        ));
  }
}
