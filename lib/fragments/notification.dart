import 'package:barber_app/ResponseModel/notificationResponse.dart';
import 'package:barber_app/appbar/app_bar_only.dart';
import 'package:barber_app/constant/appconstant.dart';
import 'package:barber_app/constant/color_constant.dart';
import 'package:barber_app/constant/constant_font.dart';
import 'package:barber_app/constant/dymmyimages.dart';
import 'package:barber_app/constant/preferenceutils.dart';
import 'package:barber_app/constant/string_constant.dart';
import 'package:barber_app/constant/toast_message.dart';
import 'package:barber_app/drawer/drawer_only.dart';
import 'package:barber_app/network/Apiservice.dart';
import 'package:barber_app/network/Retro_Api.dart';
import 'package:barber_app/screens/homescreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:barber_app/screens/loginscreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Notification1 extends StatefulWidget {
  Notification1({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _Notification1 createState() => _Notification1();
}

class _Notification1 extends State<Notification1> {
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  List<NotificationDataList> notidatalist = <NotificationDataList>[];
  bool datavisible = false;
  bool nodatavisible = true;
  bool _loading = false;
  String name = "User";

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      PreferenceUtils.init();
      if (PreferenceUtils.getlogin(AppConstant.isLoggedIn) == true) {
        AppConstant.checkNetwork().whenComplete(() => callApiForNotification());
        name = PreferenceUtils.getString(AppConstant.username);
      } else {
        Future.delayed(
          Duration(seconds: 0),
              () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen(3))),
        );
      }
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    if (mounted) {
      PreferenceUtils.init();
      if (PreferenceUtils.getlogin(AppConstant.isLoggedIn) == true) {
        AppConstant.checkNetwork().whenComplete(() => callApiForNotification());
        name = PreferenceUtils.getString(AppConstant.username);
      } else {
        Future.delayed(
          Duration(seconds: 0),
          () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen(3))),
        );
      }
    }
  }

  void callApiForNotification() {
    setState(() {
      _loading = true;
    });
    notidatalist.clear();
    Future.delayed(Duration(seconds: 0)).then((value) {

    });

    RestClient(RetroApi().dioData()).notification().then((response) {
      Future.delayed(Duration(seconds: 0)).then((value) {

      });

      setState(() {
        _loading = false;
        if (mounted) {

          Future.delayed(Duration(seconds: 0)).then((value) {


          });

          if (response.success = true) {
            Future.delayed(Duration(seconds: 0)).then((value) {

            });

            print(response.success);
            print(response.data!.length);

            if (response.data!.length > 0) {
              notidatalist.addAll(response.data!);
              datavisible = true;
              nodatavisible = false;
            } else if (response.data!.length == 0) {
              print("datavalue:$datavisible");

              datavisible = false;
              nodatavisible = true;
            }

          } else {
            datavisible = false;
            nodatavisible = true;
            ToastMessage.toastMessage("No Data");
          }


        }
      });
    }).catchError((Object obj) {

      setState(() {
        _loading = false;
      });

      print("error:$obj");
      print(obj.runtimeType);

    });
  }

  List offerdatalist = [
    {
      "discount": "10%",
      "dark_color": const Color(0xFFffb5cc),
      "light_color": const Color(0xFFffc8de),
    },
    {
      "discount": "50%",
      "dark_color": const Color(0xFFb5b8ff),
      "light_color": const Color(0xFFc8caff)
    },
    {
      "discount": "30%",
      "dark_color": const Color(0xFFffb5b5),
      "light_color": const Color(0xFFffc8c8)
    },
  ];
  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenwidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: ModalProgressHUD(
          inAsyncCall: _loading,
          opacity: 1.0,
          color: Colors.transparent.withOpacity(0.2),
          progressIndicator:
              SpinKitFadingCircle(color: pinkColor),
          child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                key: _drawerscaffoldkey,
                backgroundColor: whiteColor,
                appBar:
                    appbar(context, StringConstant.notifications, _drawerscaffoldkey, false)
                        as PreferredSizeWidget?,
                drawer: new DrawerOnly(),
                body: new Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: new ListView(
                        children: [
                          Column(
                            children: <Widget>[
                              Visibility(
                                visible: datavisible,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 0.0, left: 10, right: 10),
                                  color: whiteColor,

                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: notidatalist.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return new Container(
                                          color: whiteColor,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            width: double.infinity,
                                            height: 80,
                                            child: new Row(
                                              children: <Widget>[
                                                new Container(
                                                  height: 50,
                                                  width: screenwidth * .12,
                                                  alignment: Alignment.topLeft,

                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        PreferenceUtils.getString(
                                                            AppConstant.salonImage),
                                                    imageBuilder:
                                                        (context, imageProvider) =>
                                                            Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                          alignment:
                                                              Alignment.topCenter,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    width: screenwidth * .75,
                                                    height: 80,
                                                    margin: EdgeInsets.only(
                                                        left: 1.0, top: 1),
                                                    alignment: Alignment.topLeft,
                                                    child: ListView(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      children: <Widget>[
                                                        Container(
                                                          transform: Matrix4
                                                              .translationValues(
                                                                  5.0, 0.0, 0.0),
                                                          child: Text(
                                                            notidatalist[index]
                                                                .title!,
                                                            style: TextStyle(
                                                                color: blackColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                fontFamily:
                                                                ConstantFont.montserratSemiBold),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              left: 5),
                                                          child: Text(
                                                            notidatalist[index]
                                                                .msg!,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 4,
                                                            style: TextStyle(
                                                                color: greyColor,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                fontFamily:
                                                                ConstantFont.montserratRegular),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),

                                            // color: greyColor,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // height: 50,
                                ),
                              ),
                              Visibility(
                                visible: nodatavisible,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top: 0, bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height * 0.75,
                                    alignment: Alignment.center,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        Image.asset(
                                          DummyImage.noData,
                                          alignment: Alignment.center,
                                          width: 150,
                                          height: 100,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            StringConstant.noData,
                                            style: TextStyle(
                                                color: whiteA3,
                                                fontFamily: ConstantFont.montserratMedium,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);

    return (await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => new HomeScreen(0)))) ??
        false;
  }
}
