import 'package:MealBook/controller/authLogic.dart';
import 'package:MealBook/model/user.dart';
import 'package:MealBook/pages/registration/forgotPassword.dart';
import 'package:MealBook/pages/registration/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  double _opacity = 0.0;
  @override
  Widget build(
    BuildContext context,
  ) {
    return GetBuilder<AuthController>(
      builder: (ctrl) {
        List<Widget> list = [
          ragister(context, ctrl),
          ForgotPasswordPage(onPressed: () {
            ctrl.pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          }),
          Verification(
            user: UserDataManager(
              Uuid().v4(),
              email: ctrl.emailController.text,
              name: ctrl.usernameController.text,
              password: ctrl.passwordController.text,
            ),
          ),
        ];
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: ctrl.pageController,
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
    var styleFrom = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      primary: const Color.fromARGB(255, 255, 255, 255),
      onPrimary: const Color.fromARGB(255, 0, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1.2,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Gap(70),
                TweenAnimate(
                  child: Text(
                    ctrl.isLogin ? "Login" : 'Register',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                if (!ctrl.isLogin)
                  TweenAnimate(
                    child: TextField(
                      controller: ctrl.usernameController,
                      decoration: InputDecoration(
                        border: border,
                        labelText: 'Username',
                      ),
                    ),
                  ),
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
                            ? const Icon(Icons.enhanced_encryption)
                            : const Icon(Icons.no_encryption_outlined),
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
                            ? const Icon(Icons.enhanced_encryption)
                            : const Icon(Icons.no_encryption_outlined),
                      ),
                      labelText: 'Confirm Password',
                    ),
                  ),
                const Gap(30),
                ElevatedButton(
                  onPressed: () {
                    ctrl.onMainButtonPress(context, ref);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                    horizontal: 150,
                    vertical: 20,
                  )),
                  child: ctrl.isLogin
                      ? const Text('Login In')
                      : const Text("Register"),
                ),
                const Gap(10),
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
                    ctrl.pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  child: const Text('Forgot Password?'),
                ),
                const Gap(30),

                // external login getways

                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ctrl.googleSignIn(context, ref);
                      },
                      style: styleFrom,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/image/auth/google.png',
                            height: 20,
                            width: 20,
                          ),
                          const Gap(15),
                          const Text(
                            'Google',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () {
                        ctrl.gitSignIn(
                          context,
                          ref,
                        );
                      },
                      style: styleFrom,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/image/auth/github.png',
                            height: 20,
                            width: 20,
                          ),
                          const Gap(15),
                          const Text(
                            'Github',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                const Gap(10),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget TweenAnimate({required Widget child}) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 10),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.only(top: value),
            child: child,
          );
        },
        child: child,
      );

  TextStyle get G => GoogleFonts.poppins(
        color: const Color.fromARGB(255, 210, 208, 208),
        fontSize: 12,
      );

  OutlineInputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 183, 182, 182),
        ),
      );
}
