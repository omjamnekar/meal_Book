import 'dart:convert';

import 'package:MealBook/controller/authLogic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

enum SignUpPlatform {
  google,
  github,
  email,
  defaultPlatform,
  // Add other platforms as needed.
}

class AuthClass {
  Future<void> signOut(BuildContext context) async {
    try {
      _auth.signOut();
    } on FirebaseAuthException catch (e) {
      snackbarCon(context, e.message!);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return null; // The user canceled the sign-in process
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);
    }

    return authResult;
  }

  Future<void> signOutWithGoogle() {
    return googleSignIn.signOut();
  }

  Future<UserCredential> signInWithGitHub() async {
    final githubProvider = OAuthProvider('github.com');

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(githubProvider);

    // Now, use the UserCredential object.
    return userCredential;
  }

  Future<UserCredential> registerWithEmailPassword(
      String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<bool> sendVerification(BuildContext context) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user is signed in.');
      }

      // Check if the user's email is already verified.
      if (currentUser.emailVerified) {
        print('User\'s email is already verified.');
        return true;
      }

      // Send email verification and start a timer to periodically check the verification status.
      await currentUser.sendEmailVerification();

      // Check verification status with a timeout of 60 seconds.
      bool isVerified =
          await waitForEmailVerification(currentUser, context, timeout: 60);

      return isVerified;
    } on FirebaseAuthException catch (e) {
      // snackbarCon(context, e.message!);
      return false;
    }
  }

  Future<bool> waitForEmailVerification(
    User user,
    BuildContext context, {
    int timeout = 60,
    int interval = 5,
  }) async {
    try {
      int elapsed = 0;
      while (elapsed <= timeout) {
        await Future.delayed(Duration(seconds: interval));
        elapsed += interval;

        // Reload the user to get the latest email verification status.
        await user.reload();

        if (user.emailVerified) {
          print('Your email has been verified.');
          return true;
        }
      }

      print(
          'Email verification timeout. Your email has not been verified yet.');
      return false;
    } catch (e) {
      print('Error checking email verification: $e');
      return false;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      snackbarCon(context, error.toString());
      return null;
    }
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail(
      String email, BuildContext context, Function sd) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      sd;
      snackbarCon(context, "Password reset email sent, check your email.");
    } on FirebaseAuthException catch (error) {
      snackbarCon(context, error.toString());
      // You might want to handle and log the error more gracefully.
      throw error;
    }
  }

  Future<bool> isEmailAvailable(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If the user is created successfully, then the email is not in use.
      // Delete the user immediately.
      await userCredential.user!.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return false;
      } else {
        // An unknown error occurred.
        throw e;
      }
    }
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        // The code has been sent to the user's phone.
        // You'll need to ask the user to enter this code and then create a `PhoneAuthCredential`
        // For example:
        String smsCode =
            'xxxx'; // replace with the code sent to the user's phone
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        _auth.signInWithCredential(phoneAuthCredential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
