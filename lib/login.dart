import 'dart:convert';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:flutter_html/flutter_html.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId: 'AIzaSyAWCLK49-U6YV86YG7C0ni3SSfXZt_Rjz0',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;

  //   final OAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<dynamic> signInWithKakao() async {
    final clientState = Uuid().v4();
    final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      'response_type': 'code',
      'client_id': "cbcf3b2966001da88fad274768672dfc",
      'response_mode': 'form_post',
      'redirect_uri':
          'https://economic-phrygian-wallflower.glitch.me/callbacks/kakao/sign_in',
      'state': clientState,
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: "webauthcallback");

    final body = Uri.parse(result).queryParameters;
    print(body);
    final tokenUrl = Uri.https('kauth.kakao.com', '/oauth/token', {
      'grant_type': 'authorization_code',
      'client_id': "cbcf3b2966001da88fad274768672dfc",
      'redirect_uri':
          'https://economic-phrygian-wallflower.glitch.me/callbacks/kakao/sign_in',
      'code': body['code'],
    });
    var response = await http.post(Uri.parse(tokenUrl.toString()));
    Map<String, dynamic> accessTokenResult = jsonDecode(response.body);
    var responseCustomToken = await http.post(
        Uri.parse(
            "https://economic-phrygian-wallflower.glitch.me/callbacks/kakao/token"),
        body: {"accessToken": accessTokenResult['access_token']});

    return await FirebaseAuthWeb.instance.signInWithCustomToken(response.body);
  }

/////////////
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SNS Login'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                _handleSignIn();
                //signInWithGoogle();
              },
              child: Text('Google Login'),
              style: TextButton.styleFrom(primary: Colors.blueAccent),
            ),
            TextButton(
                onPressed: signInWithKakao,
                child: Text('Kakao Login'),
                style: TextButton.styleFrom(primary: Colors.blueAccent))
          ],
        ),
      ),
    );
  }
}
