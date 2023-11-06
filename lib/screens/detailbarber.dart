import 'package:barber_app/ResponseModel/salonDetailResponse.dart';
import 'package:barber_app/appbar/app_bar_only.dart';
import 'package:barber_app/common/common_view.dart';
import 'package:barber_app/common/inndicator.dart';
import 'package:barber_app/constant/appconstant.dart';
import 'package:barber_app/constant/color_constant.dart';
import 'package:barber_app/constant/constant_font.dart';
import 'package:barber_app/constant/dymmyimages.dart';
import 'package:barber_app/constant/preferenceutils.dart';
import 'package:barber_app/constant/string_constant.dart';
import 'package:barber_app/constant/toast_message.dart';
import 'package:barber_app/detailtabscreen/galleryview.dart';
import 'package:barber_app/detailtabscreen/reviewtab.dart';
import 'package:barber_app/detailtabscreen/servicetab.dart';
import 'package:barber_app/detailtabscreen/tababout.dart';
import 'package:barber_app/drawer/drawer_only.dart';
import 'package:barber_app/network/Apiservice.dart';
import 'package:barber_app/network/Retro_Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'homescreen.dart';

class DetailBarber extends StatefulWidget {
  final int? catId;
  DetailBarber(this.catId);

  @override
  _DetailBarber createState() => new _DetailBarber();
}

class _DetailBarber extends State<DetailBarber>
    with SingleTickerProviderStateMixin {
  int index = 0;
  List<SalonData> categorydataList = <SalonData>[];
  List<SalonGallery> galleydataList = <SalonGallery>[];
  List<SalonCategory> categorylist = <SalonCategory>[];
  List<SalonReview> reviewlist = <SalonReview>[];
  SalonDetails salonData=SalonDetails(createdAt: "",updatedAt: "",status: 0,name: "",address: "",image: "",city: "",country: "",desc: "",fri: "",friday:Sunday(close: "",open: ""),gender: "",imagePath: "",latitude: "",logo: "",longitude: "",mon: "",monday: Sunday(open: "",close: "",),
      ownerDetails: SalonOwnerDetails(imagePath: "",image: "",name: "",status: 0,updatedAt: "",createdAt: "",id: 0,otp:null ,email: "",deviceToken: "",addedBy: null,code: "",emailVerifiedAt: null,mail: 0,notification: 0,phone: "",role: 0,salonName: "",verify: 0));

  var salonId;
  String? salonName = "The Barber";
  String? salonaddress = "No Address found";
  bool datavisible = false;
  bool nodatavisible = true;
  bool _loading = false;
  String name = "User";
  String distance = "0";
  var salontime;
  String openlable = "OPEN";
  var day;
  String rating = "0";

  TabController? _controller;
  @override
  void initState() {
    super.initState();

    if (mounted) {
      var day = DateFormat('EEEE').format(DateTime.now());
      print("Todayis:$day");

      setState(() {
        _controller = new TabController(length: 4, vsync: this);
        int? catidd = widget.catId;
        print("catidd:$catidd");
        PreferenceUtils.init();

        AppConstant.checkNetwork().whenComplete(() => callApiForBarberDetail());
        name = PreferenceUtils.getString(AppConstant.username);
      });
    }
  }

  void callApiForBarberDetail() {
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData()).salondetail().then((response) {
      setState(() {
        _loading = false;
        print(response.success);

        if (response.success = true) {
          print("detailResponse:${response.msg}");

          datavisible = true;
          nodatavisible = false;
          print(response.data!.category!.length);

          salonId = response.data!.salon!.salonId;
          salonName = response.data!.salon!.name;
          salonaddress = response.data!.salon!.address;
          rating = response.data!.salon!.rate.toString();

          if (day == "Sunday") {
            if (response.data!.salon!.sunday!.open == null &&
                response.data!.salon!.sunday!.close == null) {
              salontime = "Close";
              openlable = "CLOSE";
              print(salontime);
            } else {
              DateTime tempStartTime=DateFormat("hh:mm").parse(response.data!.salon!.sunday!.open!);
              DateTime tempEndTime=DateFormat("hh:mm").parse(response.data!.salon!.sunday!.close!);
              var startTimeFormat=DateFormat("h:mm a");
              salontime = startTimeFormat.format(tempStartTime) + " to " + startTimeFormat.format(tempEndTime);
              openlable = "OPEN";

              print(salontime);
            }
          }
          day = DateFormat('EEEE').format(DateTime.now());
          if (day == "Saturday") {
            if (response.data!.salon!.saturday!.open == null &&
                response.data!.salon!.saturday!.close == null) {
              salontime = "Close";
              openlable = "CLOSE";
              print(salontime);
            } else {
              DateTime tempStartTime=DateFormat("hh:mm").parse(response.data!.salon!.saturday!.open!);
              DateTime tempEndTime=DateFormat("hh:mm").parse(response.data!.salon!.saturday!.close!);
              var startTimeFormat=DateFormat("h:mm a");
              salontime = startTimeFormat.format(tempStartTime) + " to " + startTimeFormat.format(tempEndTime);
              openlable = "OPEN";
              print(salontime);
            }
          }

          if (day == "Friday") {
            if (response.data!.salon!.friday!.open == null &&
                response.data!.salon!.friday!.close == null) {
              salontime = "Close";
              openlable = "CLOSE";
              print(salontime);
            } else {
              DateTime tempStartTime=DateFormat("hh:mm").parse(response.data!.salon!.friday!.open!);
              DateTime tempEndTime=DateFormat("hh:mm").parse(response.data!.salon!.friday!.close!);
              var startTimeFormat=DateFormat("h:mm a");
              salontime = startTimeFormat.format(tempStartTime) + " to " + startTimeFormat.format(tempEndTime);
              openlable = "OPEN";
              print(salontime);
            }
          }

          if (day == "Thursday") {
            if (response.data!.salon!.thursday!.open == null &&
                response.data!.salon!.thursday!.close == null) {
              salontime = "Close";
              openlable = "CLOSE";
              print(salontime);
            } else {
              DateTime tempStartTime=DateFormat("hh:mm").parse(response.data!.salon!.thursday!.open!);
              DateTime tempEndTime=DateFormat("hh:mm").parse(response.data!.salon!.thursday!.close!);
              var startTimeFormat=DateFormat("h:mm a");
              salontime = startTimeFormat.format(tempStartTime) + " to " + startTimeFormat.format(tempEndTime);
              openlable = "OPEN";
              print(salontime);
            }
          }

          if (day == "Wednesday") {
            if (response.data!.salon!.wednesday!.open == null &&
                response.data!.salon!.wednesday!.close == null) {
              salontime = "Close";
              openlable = "CLOSE";
              print(salontime);
            } else {
              DateTime tempStartTime=DateFormat("hh:mm").parse(response.data!.salon!.wednesday!.open!);
              DateTime tempEndTime=DateFormat("hh:mm").parse(response.data!.salon!.wednesday!.close!);
              var startTimeFormat=DateFormat("h:mm a");
              salontime = startTimeFormat.format(tempStartTime) + " to " + startTimeFormat.format(tempEndTime);
              openlable = "OPEN";
              print(salontime);
            }
          }

          if (day == "Tuesday") {
            if (response.data!.salon!.tuesday!.open == null &&
                response.data!.salon!.tuesday!.close == null) {
              salontime = "Close";
              openlable = "CLOSE";
              print(salontime);
            } else {
              DateTime tempStartTime=DateFormat("hh:mm").parse(response.data!.salon!.tuesday!.open!);
              DateTime tempEndTime=DateFormat("hh:mm").parse(response.data!.salon!.tuesday!.close!);
              var startTimeFormat=DateFormat("h:mm a");
              salontime = startTimeFormat.format(tempStartTime) + " to " + startTimeFormat.format(tempEndTime);
              openlable = "OPEN";
              print(salontime);
            }
          }
          if (day == "Monday") {
            if (response.data!.salon!.monday!.open == null &&
                response.data!.salon!.monday!.close == null) {
              salontime = "Close";
              openlable = "CLOSE";
              print(salontime);
            } else {
              DateTime tempStartTime=DateFormat("hh:mm").parse(response.data!.salon!.monday!.open!);
              DateTime tempEndTime=DateFormat("hh:mm").parse(response.data!.salon!.monday!.close!);
              var startTimeFormat=DateFormat("h:mm a");
              salontime = startTimeFormat.format(tempStartTime) + " to " + startTimeFormat.format(tempEndTime);
              openlable = "OPEN";
              print(salontime);
            }
          }

          double salonLat = double.parse(response.data!.salon!.latitude!);
          double salonLong = double.parse(response.data!.salon!.longitude!);
          assert(salonLat is double);
          assert(salonLong is double);

          AppConstant.getDistance(salonLat, salonLong).whenComplete(() =>
              AppConstant.getDistance(salonLat, salonLong).then((value) {
                distance = value;
                print("Detail_Distance123896:$distance");
              }));

          print("SalonId:$salonId");

          if (response.data!.gallery!.length > 0) {
            galleydataList.clear();
            galleydataList.addAll(response.data!.gallery!);
          }

          if (response.data!.category!.length > 0) {
            categorylist.clear();
            categorylist.addAll(response.data!.category!);
          }

          if (response.data!.review!.length > 0) {
            reviewlist.clear();
            reviewlist.addAll(response.data!.review!);
          }

          salonData = response.data!.salon!;
          print(response.data!.salon!.ownerId);

          int catsize = categorylist.length;
          print("catsize:$catsize");

        } else {
          datavisible = false;
          nodatavisible = true;

          ToastMessage.toastMessage("No Data");
        }
      });
    }).catchError((Object obj) {

      setState(() {
        _loading = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      ToastMessage.toastMessage("Internal Server Error");
    });
  }

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
        inAsyncCall: _loading,
        opacity: 1.0,
        color: Colors.transparent.withOpacity(0.2),
        progressIndicator: SpinKitFadingCircle(color: pinkColor),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: appbar(context, salonName!, _drawerscaffoldkey, false)
                as PreferredSizeWidget?,
            body: Scaffold(
                resizeToAvoidBottomInset: true,
                key: _drawerscaffoldkey,
                drawer: new DrawerOnly(),
                body: new Stack(
                  children: <Widget>[
                    Visibility(
                      visible: datavisible,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            clipBehavior: Clip.none, children: <Widget>[
                              Container(
                                height: 200,
                                width: double.infinity,
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  DummyImage.loginBG,
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Container(
                                      height: 70,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 50, left: 15),
                                                child: Text(
                                                  salonName!,
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontFamily: ConstantFont.montserratSemiBold,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, left: 5),
                                                padding: EdgeInsets.all(1),

                                                child: Image.asset(
                                                  DummyImage.rightArrow,
                                                  width: 20,
                                                  height: 20,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Container(
                                    height: 15,
                                    color: Colors.transparent,
                                    margin: EdgeInsets.only(
                                        top: 8, left: 15, right: 5),
                                    child: Text(
                                      salonaddress!,
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontFamily: ConstantFont.montserratMedium,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: greenColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(3),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    3),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    3),
                                                            topRight:
                                                                Radius.circular(
                                                                    3)),
                                                    border: Border.all(
                                                        width: 3,
                                                        color: greenColor,
                                                        style:
                                                            BorderStyle.solid)),

                                                height: 20,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.12,
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 15),

                                                child: Text(
                                                  openlable,
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontFamily:ConstantFont.montserratBold,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Container(
                                                height: 20,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                alignment: Alignment.centerLeft,
                                                color: Colors.transparent,
                                                margin: EdgeInsets.only(
                                                    top: 10, left: 5),
                                                child: Text("Till " + salontime.toString(),
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontFamily: ConstantFont.montserratMedium,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Container(
                                                height: 20,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                alignment: Alignment.topLeft,
                                                color: Colors.transparent,
                                                margin: EdgeInsets.only(
                                                    top: 5, left: 0, bottom: 2),
                                                child: Text(
                                                  ".",
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontFamily: ConstantFont.montserratMedium,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Container(
                                                  height: 20,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  alignment: Alignment.center,
                                                  color: Colors.transparent,
                                                  margin: EdgeInsets.only(
                                                      top: 5,
                                                      left: 10,
                                                      bottom: 0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              left: 0, top: 5),
                                                          child: SvgPicture.asset(
                                                            DummyImage.star,
                                                            width: 10,
                                                            height: 10,
                                                          )),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5, top: 5),
                                                        child: Text(
                                                          rating.toString() +
                                                              " Rating",
                                                          style: TextStyle(
                                                              color: whiteColor,
                                                              fontFamily:
                                                              ConstantFont.montserratMedium,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              Positioned(
                                right: 0,
                                left: 0,
                                bottom: 10,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: greyColor,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 10.0,
                                      ),
                                    ],
                                  ),

                                  child: TabBar(
                                    controller: _controller,
                                    tabs: [
                                      new Tab(
                                        text: StringConstant.about,
                                      ),
                                      new Tab(
                                        text: StringConstant.gallery,
                                      ),
                                      new Tab(
                                        text: StringConstant.service,
                                      ),
                                      new Tab(
                                        text: StringConstant.review,
                                      ),
                                    ],
                                    labelColor: pinkColor,
                                    unselectedLabelColor: greyColor,
                                    unselectedLabelStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantFont.montserratMedium
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantFont.montserratBold),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorPadding: EdgeInsets.all(0.0),
                                    indicatorColor: pinkColor,
                                    indicatorWeight: 5.0,
                                    indicator: MD2Indicator(
                                      indicatorSize: MD2IndicatorSize.full,
                                      indicatorHeight: 8.0,
                                      indicatorColor:
                                      pinkColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              color: whiteColor,
                              child: new TabBarView(
                                controller: _controller,
                                children: <Widget>[
                                  TabAbout(salonData, widget.catId, distance),
                                  GalleryView(galleydataList),
                                  ServiceTab(categorylist, salonId, salonData),
                                  ReViewTab(reviewlist),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: nodatavisible,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 60),
                        child: Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.75,
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
                      ),
                    ),
                    new Container(child: Body())
                  ],
                )),
          ),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    Navigator.pop(context);

    return (await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => new HomeScreen(0)))) ??
        false;
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: CustomView(),
      ),
    );
  }
}
