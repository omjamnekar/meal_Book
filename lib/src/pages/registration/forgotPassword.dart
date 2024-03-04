import 'package:MealBook/controller/authLogic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (ctrl) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Gap(50),
            const Text(
              "Forgot Password",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: ctrl.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),
            ),
            const Gap(20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 140,
                      vertical: 20,
                    )),
                onPressed: () {
                  ctrl.changepassword(context);
                },
                child: const Text('Submit'),
              ),
            ),
            const Gap(20),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  widget.onPressed();
                },
                child: const Text('Back to login'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
