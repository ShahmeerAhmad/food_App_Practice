import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/client/constants/providerValueSet.dart';
import 'package:food_app/client/model/User.dart';
import 'package:food_app/client/model/profiledata.dart';
import 'package:food_app/client/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_app/client/provider/LoaderProvider.dart';
import 'package:food_app/client/services/AuthServices.dart';
import 'package:food_app/client/services/DatabaseService.dart';
import 'package:food_app/client/utils/logintoggle.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loginState = prefs.getBool("loginState") ?? false;

  runApp(MultiProvider(
    providers: [
      StreamProvider<UserId>.value(
        initialData: UserId(),
        value: AuthService().user,
      ),
      ChangeNotifierProvider<LoaderProvider>(
        create: (contnext) => LoaderProvider(),
      )
    ],
    child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) {
          return GetMaterialApp(
            title: "Bread & Butter",

            locale: DevicePreview.locale(context), // Add the locale here
            builder: DevicePreview.appBuilder,
            theme: ThemeData(
                appBarTheme: AppBarTheme(backgroundColor: Colors.red)),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(
                seconds: 3,
                navigateAfterSeconds: loginState ? HomeScreen() : LoginToggle(),
                title: new Text(
                  'Welcome In Bread & Butter',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                image: new Image.asset('images/logo.png'),
                backgroundColor: Colors.white,
                styleTextUnderTheLoader: new TextStyle(),
                photoSize: 80.0,
                loaderColor: Colors.red),
          );
        }),
  ));
}
