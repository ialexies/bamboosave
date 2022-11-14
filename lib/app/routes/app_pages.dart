import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const providerConfigs = [EmailProviderConfiguration()];
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: _Paths.signin,
        page: () {
          return SignInScreen(
            providerConfigs: providerConfigs,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final uid = user?.uid;

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({})
                    .then((value) => print("User Details"))
                    .catchError((error) => print("Failed to add user: $error"));

                Navigator.pushReplacementNamed(context, AppPages.INITIAL);
              }),
            ],
          );
        }),
  ];
}
