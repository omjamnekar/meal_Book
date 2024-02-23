import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthClass {
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

  Future<UserCredential> signInWithGitHub() async {
    // Create a new provider
    OAuthProvider oAuthProvider = new OAuthProvider("github.com");

    // Once signed in, return the UserCredential

    return await _auth.signInWithPopup(oAuthProvider);
  }

  Future<UserCredential> signInWithApple() async {
    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    final AuthCredential authCredential = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    return await FirebaseAuth.instance.signInWithCredential(authCredential);
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
