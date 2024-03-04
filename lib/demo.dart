import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cdeom extends ConsumerStatefulWidget {
  const Cdeom({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CdeomState();
}

class _CdeomState extends ConsumerState<Cdeom> {
  Text sd = Text('sdsd');

  de() async {
    UserDataManager userState = await UserState.getUser();
    print("name:${userState.name}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("objectddddddddddddddddddddddddddd");
    de();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
