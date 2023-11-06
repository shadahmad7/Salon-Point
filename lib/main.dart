import 'dart:async';
import 'package:barber_app/screens/homescreen.dart';
import 'package:barber_app/screens/loginscreen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:barber_app/constant/appconstant.dart';
import 'package:flutter/material.dart';

import 'constant/preferenceutils.dart';

Future<void> main() async {
  runApp(MyApp());
  Stripe.publishableKey = "demo";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
}
class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
      return GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/HomeScreen': (BuildContext context) => new HomeScreen(1),
          },
        ),
      );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    var isLogin=PreferenceUtils.getlogin(AppConstant.isLoggedIn);
      isLogin==true?Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new HomeScreen(0))):Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen(0)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    PreferenceUtils.init();
    initPlatformState();
    checkforpermission();
  }

  void checkforpermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      print("denied");
      startTime();
    } else if (permission == LocationPermission.whileInUse) {
      print("whileInUse56362");

      startTime();
    } else if (permission == LocationPermission.always) {
      print("always");

      startTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        body: new Container(
          padding: EdgeInsets.only(bottom: 50),
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new ExactAssetImage('images/splash.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> savetoken(String token) async {
    PreferenceUtils.setString(AppConstant.fcmtoken, token);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    OneSignal.shared.consentGranted(true);
    await OneSignal.shared.setAppId(PreferenceUtils.getString(appId).isEmpty?"":PreferenceUtils.getString(appId));
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    OneSignal.shared.promptLocationPermission();
    var status = await OneSignal.shared.getDeviceState();
    var pushtoken = status!.userId!;
    print("pushtoken123456:$pushtoken");
    PreferenceUtils.setString(AppConstant.fcmtoken, pushtoken);
  }
}
