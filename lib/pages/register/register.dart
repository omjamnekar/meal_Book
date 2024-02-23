import 'package:MealBook/controller/authLogic.dart';
import 'package:MealBook/pages/register/forgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  PageController _pageController = PageController(initialPage: 0);

  double _opacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (ctrl) {
        List<Widget> list = [
          ragister(context, ctrl),
          ForgotPasswordPage(onPressed: () {
            _pageController.animateToPage(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          }),
        ];
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: list[index],
                  );
                }),
          ),
        );
      },
    );
  }

  Padding ragister(BuildContext context, AuthController ctrl) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 1.2,
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 700),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Gap(70),
                  TweenAnimate(
                    child: Text(
                      ctrl.isLogin ? "Login" : 'Register',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TweenAnimate(
                    child: TextField(
                      controller: ctrl.emailController,
                      decoration: InputDecoration(
                        border: border,
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  TweenAnimate(
                    child: TextFormField(
                      controller: ctrl.passwordController,
                      obscureText: ctrl.isOpen,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              ctrl.isOpen = !ctrl.isOpen;
                            });
                          },
                          child: ctrl.isOpen
                              ? Icon(Icons.enhanced_encryption)
                              : Icon(Icons.no_encryption_outlined),
                        ),
                        border: border,
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!ctrl.isLogin)
                    TextField(
                      controller: ctrl.confirmPassword,
                      obscureText: ctrl.isOpen1,
                      decoration: InputDecoration(
                        border: border,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              ctrl.isOpen1 = !ctrl.isOpen1;
                            });
                          },
                          child: ctrl.isOpen1
                              ? Icon(Icons.enhanced_encryption)
                              : Icon(Icons.no_encryption_outlined),
                        ),
                        labelText: 'Confirm Password',
                      ),
                    ),
                  Gap(30),
                  ElevatedButton(
                    onPressed: () {
                      ctrl.onMainButtonPress(context);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 20,
                    )),
                    child: const Text('Sign Up'),
                  ),
                  Gap(40),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        ctrl.isLogin = !ctrl.isLogin;
                      });
                    },
                    child: Text(
                      'Already have an account? ${ctrl.isLogin ? 'Register' : 'Login'}',
                      style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 63, 63, 63)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _pageController.animateToPage(2,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                  Gap(20),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "meal Book@2025",
                            style: G,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "|| ",
                            style: G,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Terms and Conditions",
                            style: G,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // external login getways

                  // Gap(20),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ctrl.googleSignIn(context);
                        },
                        child: const Text('Google'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // ctrl.facebookSignIn();
                        },
                        child: const Text('gitHub'),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget TweenAnimate({required Widget child}) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 10),
        duration: Duration(seconds: 2),
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.only(top: value),
            child: child,
          );
        },
        child: child,
      );

  TextStyle get G => GoogleFonts.poppins(
        color: Color.fromARGB(255, 210, 208, 208),
        fontSize: 12,
      );

  OutlineInputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 183, 182, 182),
        ),
      );
}
