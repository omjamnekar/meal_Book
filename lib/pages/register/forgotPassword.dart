import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gap(50),
          Text(
            "Forgot Password",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Gap(20),
          Container(
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: _emailController,
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
          Gap(20),
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
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sending password reset email')));
                  // TODO: Send password reset email
                }
              },
              child: Text('Submit'),
            ),
          ),
          Gap(20),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                widget.onPressed();
              },
              child: Text('Back to login'),
            ),
          ),
        ],
      ),
    );
  }
}
