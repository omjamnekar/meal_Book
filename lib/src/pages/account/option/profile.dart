import 'package:MealBook/controller/accountInfo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Profile extends ConsumerStatefulWidget {
  Profile({super.key, required this.imageUrl, required this.userDataManager});

  final String imageUrl;
  final UserDataManager userDataManager;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController =
        TextEditingController(text: widget.userDataManager.name);
    TextEditingController emailController =
        TextEditingController(text: widget.userDataManager.email);
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: GetBuilder<AccountInfo>(
            init: AccountInfo(),
            builder: (ctlr) {
              return SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const Gap(30),

                      // image and edit icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: "profileImage",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(widget.imageUrl,
                                  width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            height: 70,
                            alignment: AlignmentDirectional.bottomStart,
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),

                      // Username and email
                      const Gap(40),

                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextField(
                          controller: usernameController,
                        ),
                      ),
                      const Gap(30),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextField(
                          controller: emailController,
                        ),
                      ),
                      const Spacer(),

                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ctlr.insertUser(
                                userData: UserDataManager(
                              widget.userDataManager.id,
                              email: emailController.text,
                              name: usernameController.text,
                              password: widget.userDataManager.password,
                              phone: widget.userDataManager.phone,
                              image: widget.userDataManager.image,
                            ));
                          },
                          child: Text('Save'),
                        ),
                      ),
                      Gap(20),
                    ],
                  ),
                ),
              );
            }));
  }
}
