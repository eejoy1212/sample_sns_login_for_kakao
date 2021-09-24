import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("firebase sns login"),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // builder: (context, snapshot) {
          print('Stream');
          if (snapshot.hasError) {
            return Text("오류에요");
          } else if (snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  Text("${snapshot.data!.displayName}님 환영합니다."),
                ],
              ),
            );
          }
          return LoginWidget();
        },
      ),
    );
  }
}
