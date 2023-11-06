import 'dart:convert';

import 'package:barber_app/ResponseModel/appointmentResponse.dart';
import 'package:barber_app/appbar/app_bar_only.dart';
import 'package:barber_app/common/inndicator.dart';
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
import 'package:barber_app/separator/separator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:barber_app/screens/loginscreen.dart';
import 'package:dio/dio.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Appoinment extends StatefulWidget {
  @override
  _Appoinment createState() => new _Appoinment();
}

class _Appoinment extends State<Appoinment>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  List<Completed> completeddataList = <Completed>[];
  List<Cancel> canceldataList = <Cancel>[];
  List<UpcomingOrder> upcomingorderdataList = <UpcomingOrder>[];
  List<Services> servicelist = <Services>[];
  bool noupdatavisible = true;
  bool uplistvisible = false;

  bool nocanceldatavisible = true;
  bool cancellistvisible = false;

  bool nocompletedatavisible = true;
  bool completelistvisible = false;

  bool isShowReview = false;
  bool _loading = false;

  List<String?> upcomingServiceList = <String?>[];
  List<String?> cancelServiceList = <String?>[];
  List<String?> completedServiceList = <String?>[];

  TextEditingController reviewTextController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var rating = 0.0;

  String name = "User";

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _controller =
            new TabController(length: 3, vsync: this, initialIndex: tabindex);
        PreferenceUtils.init();
        name = PreferenceUtils.getString(AppConstant.username);

        if (PreferenceUtils.getlogin(AppConstant.isLoggedIn) == true) {
          AppConstant.checkNetwork()
              .whenComplete(() => CallApiforAppointment());
        } else {
          Future.delayed(
            Duration(seconds: 0),
            () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginScreen(0))),
          );
        }
      });
    }
  }
  void CallApiforAppointment() {
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData()).appointment().then((response) {
      if (mounted) {
        setState(() {
          _loading = false;
          if (response.success = true) {
            upcomingorderdataList.clear();
            canceldataList.clear();
            completeddataList.clear();
            if (response.data!.upcomingOrder!.length > 0) {
              upcomingorderdataList.addAll(response.data!.upcomingOrder!);
              uplistvisible = true;
              noupdatavisible = false;
            } else {
              uplistvisible = false;
              noupdatavisible = true;
            }
            if (response.data!.cancel!.length > 0) {
              canceldataList.addAll(response.data!.cancel!);
              nocanceldatavisible = false;
              cancellistvisible = true;
            } else {
              cancellistvisible = false;
              nocanceldatavisible = true;
            }

            if (response.data!.completed!.length > 0) {
              completeddataList.addAll(response.data!.completed!);
              nocompletedatavisible = false;
              completelistvisible = true;
            } else {
              completelistvisible = false;
              nocompletedatavisible = true;
            }
          } else {
            ToastMessage.toastMessage("No Data");
          }
        });
      }
    }).catchError((Object obj) {
      setState(() {
        _loading = false;
      });
      print("error123456:$obj");
      print(obj.runtimeType);
      ToastMessage.toastMessage("Internal Server Error");
    });
  }

  void callApiForCancelBooking(int id) {
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData()).removeappointment(id).then((response) {
      setState(() {
        _loading = false;
        if (response.success = true) {
          ToastMessage.toastMessage(response.msg!);

          AppConstant.checkNetwork()
              .whenComplete(() => CallApiforAppointment());
        } else {
          ToastMessage.toastMessage("No Data");
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

  TabController? _controller;

  int tabindex = 0;

  List appoinmentdatalist = [
    {
      "discount": "10%",
      "dark_color": const Color(0xFFffb5cc),
      "light_color": const Color(0xFFffc8de),
    },
    {
      "discount": "10%",
      "dark_color": const Color(0xFFffb5cc),
      "light_color": const Color(0xFFffc8de),
    },
  ];

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _controller =
        new TabController(length: 3, vsync: this, initialIndex: tabindex);
        PreferenceUtils.init();
        name = PreferenceUtils.getString(AppConstant.username);

        if (PreferenceUtils.getlogin(AppConstant.isLoggedIn) == true) {
          AppConstant.checkNetwork()
              .whenComplete(() => CallApiforAppointment());
        } else {
          Future.delayed(
            Duration(seconds: 0),
                () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginScreen(0))),
          );
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;

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
              resizeToAvoidBottomInset: true,
              appBar: appbar(context, StringConstant.appointment,
                  _drawerscaffoldkey, true) as PreferredSizeWidget?,
              key: _drawerscaffoldkey,
              drawer: new DrawerOnly(),
              body: new Stack(
                children: <Widget>[
                  new SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: screenHeight * 0.055,
                          color: whiteColor,
                          margin:
                              EdgeInsets.only(top: 0.0, left: 10, right: 10),
                          child: TabBar(
                            controller: _controller,
                            isScrollable: false,
                            physics: NeverScrollableScrollPhysics(),
                            tabs: [
                              new Tab(
                                text: StringConstant.upcoming,
                              ),
                              new Tab(
                                text: StringConstant.cancel,
                              ),
                              new Tab(
                                text: StringConstant.completed,
                              ),
                            ],
                            labelColor: pinkColor,
                            unselectedLabelColor: greyColor,
                            labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: ConstantFont.montserratMedium),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorPadding: EdgeInsets.all(0.0),
                            indicatorColor: pinkColor,
                            indicatorWeight: 5.0,
                            indicator: MD2Indicator(
                              indicatorSize: MD2IndicatorSize.full,
                              indicatorHeight: 8.0,
                              indicatorColor: pinkColor,
                            ),
                          ),
                        ),
                        Container(
                          color: whiteColor,
                          height: screenHeight * 0.75,
                          margin: EdgeInsets.only(bottom: 50),
                          child: new TabBarView(
                            controller: _controller,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              ///upcoming list
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10),
                                color: whiteColor,
                                child: RefreshIndicator(
                                  onRefresh: _onRefresh,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Visibility(
                                        visible: uplistvisible,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: upcomingorderdataList.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            var parsedDate;
                                            parsedDate = DateTime.parse(
                                                upcomingorderdataList[index]
                                                    .date!);
                                            var df =
                                                new DateFormat('MMM dd,yyyy');
                                            parsedDate = df.format(parsedDate);
                                            print(upcomingorderdataList[index]
                                                .bookingStatus);
                                            upcomingServiceList.clear();
                                            for (int i = 0; i < upcomingorderdataList[index].services!.length; i++) {
                                              upcomingServiceList.add(upcomingorderdataList[index].services![i].name);
                                            }

                                            return Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: whiteF1, width: 3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: new Container(
                                                            height: 75,
                                                            alignment:
                                                                Alignment.topLeft,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),

                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: PreferenceUtils
                                                                  .getString(
                                                                      AppConstant
                                                                          .salonImage),
                                                              imageBuilder: (context,
                                                                      imageProvider) =>
                                                                  Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        new Container(
                                                            // height: 100.0,
                                                            width:
                                                                screenwidth * .65,
                                                            height: 110,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5.0,
                                                                    top: 0.0),
                                                            alignment:
                                                                Alignment.topLeft,
                                                            color: whiteColor,
                                                            child: ListView(
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              children: <Widget>[
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              25.0),
                                                                  child: Text(
                                                                    PreferenceUtils
                                                                        .getString(
                                                                            AppConstant
                                                                                .singlesalonName),
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF1e1e1e),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontFamily:
                                                                            ConstantFont
                                                                                .montserratSemiBold),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5.0,
                                                                          left:
                                                                              0.0),
                                                                  child: Text(
                                                                    PreferenceUtils
                                                                        .getString(
                                                                            AppConstant
                                                                                .salonAddress),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        color:
                                                                            greyColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontFamily:
                                                                            ConstantFont
                                                                                .montserratRegular),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: 2,
                                                                          left:
                                                                              0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        DummyImage
                                                                            .star,
                                                                        width: 10,
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                2,
                                                                            left:
                                                                                2),
                                                                        child: Text(
                                                                            PreferenceUtils.getString(AppConstant.salonRating) +
                                                                                StringConstant
                                                                                    .rating,
                                                                            style: TextStyle(
                                                                                color: grey99,
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: ConstantFont.montserratMedium)),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 5.0,
                                                                      height: 5.0,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              5.0,
                                                                          top:
                                                                              5.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color:
                                                                            greyColor,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5.0,
                                                                            top:
                                                                                5.0,
                                                                            right:
                                                                                0),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textScaleFactor:
                                                                              1,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          text:
                                                                              TextSpan(
                                                                            children: [
                                                                              WidgetSpan(
                                                                                child: Icon(
                                                                                  Icons.calendar_today,
                                                                                  size: 14,
                                                                                  color: pinkColor,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                  text: upcomingorderdataList[index].startTime! + " - " + parsedDate,
                                                                                  style: TextStyle(color: greyColor, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium)),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(0),
                                                      child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin: EdgeInsets.only(
                                                              left: 5.0,
                                                              right: 5.0),
                                                          color: whiteColor,
                                                          child: ListView(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      StringConstant
                                                                          .serviceType,
                                                                      style: TextStyle(
                                                                          color:
                                                                              whiteB3,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          fontFamily:
                                                                              ConstantFont.montserratMedium),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(
                                                                            StringConstant
                                                                                .bookingStatus,
                                                                            style: TextStyle(
                                                                                color:
                                                                                    whiteB3,
                                                                                fontSize:
                                                                                    12,
                                                                                fontWeight:
                                                                                    FontWeight.w600,
                                                                                fontFamily: ConstantFont.montserratMedium),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Text(
                                                                            " : " +
                                                                                upcomingorderdataList[index].bookingStatus!,
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color:
                                                                                    whiteB3,
                                                                                fontSize:
                                                                                    12,
                                                                                fontWeight:
                                                                                    FontWeight.w600,
                                                                                fontFamily: ConstantFont.montserratMedium),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Visibility(
                                                                visible: upcomingorderdataList[index].serlistvisible,
                                                                child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    upcomingorderdataList[
                                                                            index]
                                                                        .services![
                                                                            0]
                                                                        .name!,
                                                                    style: TextStyle(
                                                                        color:
                                                                            white4B,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontFamily:
                                                                            ConstantFont
                                                                                .montserratMedium),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                upcomingorderdataList[
                                                                index]
                                                                    .newlistvisible,
                                                                child:
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      print(
                                                                          "sellallTap");
                                                                      upcomingorderdataList[
                                                                      index]
                                                                          .seeallvisible = true;
                                                                      upcomingorderdataList[
                                                                      index]
                                                                          .serlistvisible = true;
                                                                      upcomingorderdataList[
                                                                      index]
                                                                          .newlistvisible = false;
                                                                    });
                                                                  },
                                                                  child: ListView(
                                                                    shrinkWrap:
                                                                    true,
                                                                    physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                            5,
                                                                            top:
                                                                            5),
                                                                        child:
                                                                        Text(
                                                                          upcomingServiceList
                                                                              .join(" , "),
                                                                          maxLines:
                                                                          5,
                                                                          overflow:
                                                                          TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color:
                                                                              white4B,
                                                                              fontSize:
                                                                              12,
                                                                              fontWeight:
                                                                              FontWeight.w600,
                                                                              fontFamily: ConstantFont.montserratMedium),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              upcomingorderdataList[index].services!.length == 1 ?
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 10),
                                                                child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .end,
                                                                        children: [
                                                                          GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                showcancledialog1(upcomingorderdataList[index].id);
                                                                              },
                                                                              child:
                                                                                  RichText(
                                                                                text:
                                                                                    TextSpan(
                                                                                  children: [
                                                                                    WidgetSpan(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(top: 5),
                                                                                        child: SvgPicture.asset(
                                                                                          DummyImage.delete,
                                                                                          color: redFF,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    WidgetSpan(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(top: 5, left: 5),
                                                                                        child: Text(StringConstant.cancelBooking, style: TextStyle(color: redFF, fontSize: 12, fontFamily: ConstantFont.montserratMedium, fontWeight: FontWeight.w700)),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )),
                                                                        ],
                                                                      ),
                                                              )
                                                                  : Padding(
                                                                    padding: const EdgeInsets.only(bottom: 10),
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  upcomingorderdataList[index].seeallvisible,
                                                                              child:
                                                                                  GestureDetector(
                                                                                onTap:
                                                                                    () {
                                                                                  setState(() {
                                                                                    upcomingorderdataList[index].seeallvisible = false;
                                                                                    upcomingorderdataList[index].serlistvisible = false;
                                                                                    upcomingorderdataList[index].newlistvisible = true;
                                                                                  });
                                                                                },
                                                                                child:
                                                                                    Container(
                                                                                  margin: EdgeInsets.only(left: 5, top: 5),
                                                                                  child: Text(
                                                                                    StringConstant.seeAll,
                                                                                    style: TextStyle(color: blue4a, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.end,
                                                                              children: [
                                                                                GestureDetector(
                                                                                    onTap: () {
                                                                                      showcancledialog1(upcomingorderdataList[index].id);
                                                                                    },
                                                                                    child: RichText(
                                                                                      text: TextSpan(
                                                                                        children: [
                                                                                          WidgetSpan(
                                                                                            child: Container(
                                                                                              margin: EdgeInsets.only(top: 5),
                                                                                              child: SvgPicture.asset(
                                                                                                DummyImage.delete,
                                                                                                color: redFF,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          WidgetSpan(
                                                                                            child: Container(
                                                                                              margin: EdgeInsets.only(top: 5, left: 5),
                                                                                              child: Text(StringConstant.cancelBooking, style: TextStyle(color: redFF, fontSize: 12, fontFamily: ConstantFont.montserratMedium, fontWeight: FontWeight.w700)),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                  ),

                                                            ],
                                                          ),
                                                      ),
                                                  ),

                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: noupdatavisible,
                                        child: Center(
                                          child: Container(
                                              width: screenwidth,
                                              height: screenHeight * 0.75,
                                              alignment: Alignment.center,
                                              child: ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
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
                                                      StringConstant
                                                          .youHavenAnyAppointmentSet,
                                                      style: TextStyle(
                                                          color: whiteA3,
                                                          fontFamily: ConstantFont
                                                              .montserratMedium,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomeScreen(
                                                                            0)));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        child: Text(
                                                          StringConstant.goToHome,
                                                          style: TextStyle(
                                                              color: blue4a,
                                                              fontFamily: ConstantFont
                                                                  .montserratMedium,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /*Canceled List*/

                              ///cancel list
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10),
                                color: whiteColor,
                                child: RefreshIndicator(
                                  onRefresh: _onRefresh,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Visibility(
                                        visible: cancellistvisible,
                                        child: GestureDetector(
                                          onTap: () {
                                            print('item clicked');
                                          },
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var parsedDate;
                                              parsedDate = DateTime.parse(
                                                  canceldataList[index].date!);
                                              var df =
                                                  new DateFormat('MMM dd,yyyy');
                                              parsedDate = df.format(parsedDate);

                                              cancelServiceList.clear();
                                              for (int i = 0;
                                                  i <
                                                      canceldataList[index]
                                                          .services!
                                                          .length;
                                                  i++) {
                                                cancelServiceList.add(
                                                    canceldataList[index]
                                                        .services![i]
                                                        .name);
                                              }

                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10, top: 10),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: whiteF1, width: 3),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12)),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.stretch,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 0.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  new Container(
                                                                height: 75,
                                                                // color: blackColor,
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5),

                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: PreferenceUtils
                                                                      .getString(
                                                                          AppConstant
                                                                              .salonImage),
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        alignment:
                                                                            Alignment
                                                                                .topCenter,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      SpinKitFadingCircle(
                                                                          color:
                                                                              pinkColor),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image.asset(
                                                                          DummyImage
                                                                              .noImage),
                                                                ),
                                                              ),
                                                            ),
                                                            new Container(
                                                                // height: 100.0,
                                                                width:
                                                                    screenwidth *
                                                                        .66,
                                                                height: 110,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5.0,
                                                                        top: 0.0),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                color: whiteColor,
                                                                child: ListView(
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top:
                                                                                  25.0),
                                                                      child: Text(
                                                                        PreferenceUtils.getString(
                                                                            AppConstant
                                                                                .singlesalonName),
                                                                        style: TextStyle(
                                                                            color:
                                                                                black1E,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontFamily:
                                                                                ConstantFont.montserratSemiBold),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              5.0,
                                                                          left:
                                                                              0.0),
                                                                      child: Text(
                                                                        PreferenceUtils.getString(
                                                                            AppConstant
                                                                                .salonAddress),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: TextStyle(
                                                                            color:
                                                                                greyColor,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontFamily:
                                                                                ConstantFont.montserratMedium),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        SvgPicture
                                                                            .asset(
                                                                          DummyImage
                                                                              .star,
                                                                          width:
                                                                              10,
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 2,
                                                                                left: 2),
                                                                            child: Text(
                                                                                PreferenceUtils.getString(AppConstant.salonRating) + " Rating",
                                                                                style: TextStyle(color: grey99, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium)),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              5.0,
                                                                          height:
                                                                              5.0,
                                                                          margin: EdgeInsets.only(
                                                                              left:
                                                                                  5.0,
                                                                              top:
                                                                                  5.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                greyColor,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            margin: EdgeInsets.only(
                                                                                left: 5.0,
                                                                                top: 5.0,
                                                                                right: 0),
                                                                            child: RichText(
                                                                              maxLines:
                                                                                  2,
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                              textScaleFactor:
                                                                                  1,
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              text:
                                                                                  TextSpan(
                                                                                children: [
                                                                                  WidgetSpan(
                                                                                    child: Icon(
                                                                                      Icons.calendar_today,
                                                                                      size: 14,
                                                                                      color: pinkColor,
                                                                                    ),
                                                                                  ),
                                                                                  TextSpan(text: canceldataList[index].startTime! + " - " + parsedDate, style: TextStyle(color: greyColor, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium)),
                                                                                ],
                                                                              ),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                        )),
                                                    Container(
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                                top: 1.0,
                                                                bottom: 1.0),
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: MySeparator(
                                                            color: Color(
                                                                0xFF9e9e9e)),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                                width:
                                                                    screenwidth *
                                                                        .33,
                                                                // height: 80,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5.0,
                                                                        right:
                                                                            10.0),
                                                                color: whiteColor,
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: ListView(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      transform: Matrix4
                                                                          .translationValues(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0),
                                                                      child: Text(
                                                                        StringConstant
                                                                            .serviceType,
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFFb3b3b3),
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontFamily:
                                                                                ConstantFont.montserratMedium),
                                                                      ),
                                                                    ),
                                                                    Visibility(
                                                                      visible: canceldataList[
                                                                              index]
                                                                          .serlistvisible,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          canceldataList[index]
                                                                              .services![0]
                                                                              .name!,
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xFF4b4b4b),
                                                                              fontSize:
                                                                                  12,
                                                                              fontWeight:
                                                                                  FontWeight.w600,
                                                                              fontFamily: ConstantFont.montserratMedium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    canceldataList[index]
                                                                                .services!
                                                                                .length ==
                                                                            1
                                                                        ? Container(
                                                                            height:
                                                                                0,
                                                                            width:
                                                                                0,
                                                                          )
                                                                        : Visibility(
                                                                            visible:
                                                                                canceldataList[index].seeallvisible,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                setState(() {
                                                                                  canceldataList[index].seeallvisible = false;
                                                                                  canceldataList[index].serlistvisible = false;
                                                                                  canceldataList[index].newlistvisible = true;
                                                                                });
                                                                              },
                                                                              child:
                                                                                  Container(
                                                                                margin: EdgeInsets.only(left: 5, top: 5),
                                                                                child: Text(
                                                                                  StringConstant.seeAll,
                                                                                  style: TextStyle(color: blue4a, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    Visibility(
                                                                      visible: canceldataList[
                                                                              index]
                                                                          .newlistvisible,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            print(
                                                                                "sellallTap");
                                                                            canceldataList[index].seeallvisible =
                                                                                true;
                                                                            canceldataList[index].serlistvisible =
                                                                                true;
                                                                            canceldataList[index].newlistvisible =
                                                                                false;
                                                                          });
                                                                        },
                                                                        child:
                                                                            ListView(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              margin:
                                                                                  EdgeInsets.only(left: 5, top: 5),
                                                                              child:
                                                                                  Text(
                                                                                cancelServiceList.join(" , "),
                                                                                maxLines: 5,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: white4B, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                            Container(
                                                              // height: 100.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              height: 50,
                                                              alignment: Alignment
                                                                  .topRight,
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      top: 20,
                                                                      right: 10),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {},
                                                                child: Text(
                                                                    StringConstant
                                                                        .canceled,
                                                                    style: TextStyle(
                                                                        color:
                                                                            redFF,
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            ConstantFont
                                                                                .montserratMedium,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700)),
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                                // ),
                                              );
                                            },
                                            itemCount: canceldataList.length,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: nocanceldatavisible,
                                        child: Center(
                                          child: Container(
                                              width: screenwidth,
                                              height: screenHeight * 0.75,
                                              alignment: Alignment.center,
                                              child: ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
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
                                                      StringConstant
                                                          .youHavenAnyCanceledAppointment,
                                                      style: TextStyle(
                                                          color: whiteA3,
                                                          fontFamily: ConstantFont
                                                              .montserratMedium,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /*Completed List*/

                              ///completed list
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, left: 10, right: 10),
                                color: whiteColor,
                                child: RefreshIndicator(
                                  onRefresh: _onRefresh,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Visibility(
                                        visible: completelistvisible,
                                        child: GestureDetector(
                                          onTap: () {
                                            print('item clicked');
                                          },
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var parsedDate;
                                              parsedDate = DateTime.parse(
                                                  completeddataList[index].date!);
                                              var df =
                                                  new DateFormat('MMM dd,yyyy');
                                              parsedDate = df.format(parsedDate);

                                              completedServiceList.clear();
                                              for (int i = 0;
                                                  i <
                                                      completeddataList[index]
                                                          .services!
                                                          .length;
                                                  i++) {
                                                completedServiceList.add(
                                                    completeddataList[index]
                                                        .services![i]
                                                        .name);
                                              }

                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10, top: 10),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: whiteF1, width: 3),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12)),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.stretch,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 0.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  new Container(
                                                                height: 75,
                                                                // color: blackColor,
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5),

                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: PreferenceUtils
                                                                      .getString(
                                                                          AppConstant
                                                                              .salonImage),
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        alignment:
                                                                            Alignment
                                                                                .topCenter,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      SpinKitFadingCircle(
                                                                          color:
                                                                              pinkColor),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image.asset(
                                                                          DummyImage
                                                                              .noImage),
                                                                ),
                                                              ),
                                                            ),
                                                            new Container(
                                                                // height: 100.0,
                                                                width:
                                                                    screenwidth *
                                                                        .67,
                                                                height: 110,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5.0,
                                                                        top: 0.0),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                color: whiteColor,
                                                                child: ListView(
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top:
                                                                                  25.0),
                                                                      child: Text(
                                                                        PreferenceUtils.getString(
                                                                            AppConstant
                                                                                .singlesalonName),
                                                                        style: TextStyle(
                                                                            color:
                                                                                black1E,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontFamily:
                                                                                ConstantFont.montserratSemiBold),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              5.0,
                                                                          left:
                                                                              0.0),
                                                                      child: Text(
                                                                        PreferenceUtils.getString(
                                                                            AppConstant
                                                                                .salonAddress),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFF9e9e9e),
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontFamily:
                                                                                ConstantFont.montserratMedium),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          margin: EdgeInsets.only(
                                                                              top:
                                                                                  2,
                                                                              left:
                                                                                  0),
                                                                          child: SvgPicture
                                                                              .asset(
                                                                            DummyImage
                                                                                .star,
                                                                            width:
                                                                                10,
                                                                            height:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 2,
                                                                                left: 2),
                                                                            child: Text(
                                                                                PreferenceUtils.getString(AppConstant.salonRating) + " Rating",
                                                                                style: TextStyle(color: grey99, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium)),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              5.0,
                                                                          height:
                                                                              5.0,
                                                                          margin: EdgeInsets.only(
                                                                              left:
                                                                                  5.0,
                                                                              top:
                                                                                  5.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                greyColor,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            margin: EdgeInsets.only(
                                                                                left: 5.0,
                                                                                top: 5.0,
                                                                                right: 0),
                                                                            child: RichText(
                                                                              maxLines:
                                                                                  2,
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                              textScaleFactor:
                                                                                  1,
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              text:
                                                                                  TextSpan(
                                                                                children: [
                                                                                  WidgetSpan(
                                                                                    child: Icon(
                                                                                      Icons.calendar_today,
                                                                                      size: 14,
                                                                                      color: pinkColor,
                                                                                    ),
                                                                                  ),
                                                                                  TextSpan(text: completeddataList[index].startTime! + " - " + parsedDate, style: TextStyle(color: greyColor, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium)),
                                                                                ],
                                                                              ),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                        )),
                                                    Container(
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                                top: 1.0,
                                                                bottom: 1.0),
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: MySeparator(
                                                            color: greyColor),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                                width:
                                                                    screenwidth *
                                                                        .33,
                                                                // height: 80,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5.0,
                                                                        right:
                                                                            10.0),
                                                                color: whiteColor,
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: ListView(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      transform: Matrix4
                                                                          .translationValues(
                                                                              5.0,
                                                                              0.0,
                                                                              0.0),
                                                                      child: Text(
                                                                        StringConstant
                                                                            .serviceType,
                                                                        style: TextStyle(
                                                                            color:
                                                                                whiteB3,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontFamily:
                                                                                ConstantFont.montserratMedium),
                                                                      ),
                                                                    ),
                                                                    Visibility(
                                                                      visible: completeddataList[
                                                                              index]
                                                                          .serlistvisible,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          completeddataList[index]
                                                                              .services![0]
                                                                              .name!,
                                                                          style: TextStyle(
                                                                              color:
                                                                                  white4B,
                                                                              fontSize:
                                                                                  12,
                                                                              fontWeight:
                                                                                  FontWeight.w600,
                                                                              fontFamily: ConstantFont.montserratMedium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    completeddataList[index]
                                                                                .services!
                                                                                .length ==
                                                                            1
                                                                        ? Container(
                                                                            height:
                                                                                0,
                                                                            width:
                                                                                0,
                                                                          )
                                                                        : Visibility(
                                                                            visible:
                                                                                completeddataList[index].seeallvisible,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                setState(() {
                                                                                  completeddataList[index].seeallvisible = false;
                                                                                  completeddataList[index].serlistvisible = false;
                                                                                  completeddataList[index].newlistvisible = true;
                                                                                });
                                                                              },
                                                                              child:
                                                                                  Container(
                                                                                margin: EdgeInsets.only(left: 5, top: 5),
                                                                                child: Text(
                                                                                  StringConstant.seeAll,
                                                                                  style: TextStyle(color: blue4a, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    Visibility(
                                                                      visible: completeddataList[
                                                                              index]
                                                                          .newlistvisible,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            print(
                                                                                "sellallTap");
                                                                            completeddataList[index].seeallvisible =
                                                                                true;
                                                                            completeddataList[index].serlistvisible =
                                                                                true;
                                                                            completeddataList[index].newlistvisible =
                                                                                false;
                                                                          });
                                                                        },
                                                                        child:
                                                                            ListView(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              margin:
                                                                                  EdgeInsets.only(left: 5, top: 5),
                                                                              child:
                                                                                  Text(
                                                                                completedServiceList.join(" , "),
                                                                                maxLines: 5,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: white4B, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: ConstantFont.montserratMedium),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  // height: 100.0,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.4,
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top: 10,
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              children: [
                                                                                WidgetSpan(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: 5),
                                                                                    child: SvgPicture.asset(
                                                                                      DummyImage.correct,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                WidgetSpan(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: 5, left: 5),
                                                                                    child: Text(StringConstant.completed, style: TextStyle(color: green00, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: ConstantFont.montserratMedium)),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )),
                                                                ),
                                                                completeddataList[
                                                                                index]
                                                                            .review ==
                                                                        null
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          _newAddReview(context, completeddataList[index].id);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          // height: 100.0,
                                                                          width: MediaQuery.of(context).size.width *
                                                                              0.4,
                                                                          alignment:
                                                                              Alignment.topRight,
                                                                          margin: EdgeInsets.only(
                                                                              top:
                                                                                  10,
                                                                              right:
                                                                                  10),
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 5,
                                                                                left: 5),
                                                                            child:
                                                                                Text(
                                                                              StringConstant.addReview,
                                                                              style:
                                                                                  TextStyle(
                                                                                fontFamily: ConstantFont.montserratMedium,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: blue4a,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                completeddataList[
                                                                                index]
                                                                            .review !=
                                                                        null
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                                .only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            SvgPicture
                                                                                .asset(
                                                                              DummyImage.star,
                                                                            ),
                                                                            Padding(
                                                                              padding:
                                                                                  const EdgeInsets.all(5.0),
                                                                              child:
                                                                                  Text(
                                                                                '(${completeddataList[index].review != null ? completeddataList[index].review!.rate.toString() : '0'})',
                                                                                style: TextStyle(fontFamily: ConstantFont.montserratMedium, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              alignment:
                                                                                  Alignment.center,
                                                                              width:
                                                                                  5.0,
                                                                              height:
                                                                                  5.0,
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                color: greyColor,
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                setState(() {
                                                                                  isShowReview = !isShowReview;
                                                                                });
                                                                              },
                                                                              child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 10),
                                                                                  child: RichText(
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        WidgetSpan(
                                                                                          child: Container(
                                                                                            child: Text(
                                                                                              StringConstant.showReview,
                                                                                              style: TextStyle(
                                                                                                fontFamily: ConstantFont.montserratMedium,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: blue4a,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        WidgetSpan(
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.only(left: 5, bottom: 5, right: 10),
                                                                                            child: SvgPicture.asset(
                                                                                              isShowReview ? DummyImage.icUp : DummyImage.icDown,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    (() {
                                                      if (completeddataList[index]
                                                              .review !=
                                                          null) {
                                                        DateTime today =
                                                            new DateTime.now();

                                                        String difference;
                                                        String difference1;

                                                        String date =
                                                            completeddataList[
                                                                    index]
                                                                .review!
                                                                .createdAt!;

                                                        difference1 =
                                                            "${today.difference(DateTime.parse(date)).inHours}" +
                                                                " Hours Ago.";
                                                        difference =
                                                            "${today.difference(DateTime.parse(date)).inHours}";

                                                        int diffrennce12 =
                                                            int.parse(difference);

                                                        if (diffrennce12 > 24) {
                                                          difference1 =
                                                              "${today.difference(DateTime.parse(date)).inDays}" +
                                                                  " Days Ago.";
                                                        }

                                                        return Visibility(
                                                          visible: isShowReview,
                                                          child: Column(
                                                            children: [
                                                              MySeparator(
                                                                  color:
                                                                      greyColor),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                                .all(
                                                                            8.0),
                                                                    child: Column(
                                                                      children: <
                                                                          Widget>[
                                                                        CachedNetworkImage(
                                                                          height:
                                                                              35,
                                                                          width:
                                                                              35,

                                                                          imageUrl:
                                                                              PreferenceUtils.getString(AppConstant.imagePath) +
                                                                                  PreferenceUtils.getString(AppConstant.userimage),
                                                                          imageBuilder:
                                                                              (context, imageProvider) =>
                                                                                  Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(20),
                                                                              image:
                                                                                  DecorationImage(
                                                                                image: imageProvider,
                                                                                fit: BoxFit.fill,
                                                                                alignment: Alignment.topCenter,
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          placeholder:
                                                                              (context, url) =>
                                                                                  SpinKitFadingCircle(color: pinkColor),
                                                                          errorWidget: (context,
                                                                                  url,
                                                                                  error) =>
                                                                              Image.asset(DummyImage.noImage),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            SvgPicture
                                                                                .asset(
                                                                              DummyImage.star,
                                                                              width:
                                                                                  10,
                                                                              height:
                                                                                  10,
                                                                            ),
                                                                            Text(
                                                                                completeddataList[index].review!.rate != null ? completeddataList[index].review!.rate.toString() : '0',
                                                                                style: TextStyle(color: yellowColor, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Montserrat')),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topCenter,
                                                                      margin: EdgeInsets.only(
                                                                          top: 5,
                                                                          left: 0,
                                                                          right:
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            whiteF1,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                                .only(
                                                                            left:
                                                                                8,
                                                                            bottom:
                                                                                8,
                                                                            top:
                                                                                5),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      PreferenceUtils.getString(AppConstant.username),
                                                                                      style: TextStyle(
                                                                                        color: blackColor,
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontFamily: ConstantFont.montserratMedium,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      difference1,
                                                                                      style: TextStyle(
                                                                                        color: grey99,
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontFamily: ConstantFont.montserratMedium,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                PopupMenuButton<String>(
                                                                                  color: whiteColor,
                                                                                  icon: SvgPicture.asset(
                                                                                    DummyImage.icDot,
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                  ),
                                                                                  offset: Offset(-95, 50),
                                                                                  onSelected: handleClick,
                                                                                  itemBuilder: (BuildContext context) {
                                                                                    return {
                                                                                      "Notification Settings"
                                                                                    }.map((String choice) {
                                                                                      return PopupMenuItem<String>(
                                                                                        value: completeddataList[index].review!.reviewId.toString(),
                                                                                        child: Text("Delete", style: TextStyle(color: blackColor, fontFamily: ConstantFont.montserratMedium),
                                                                                        ),
                                                                                      );
                                                                                    }).toList();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              completeddataList[index].review!.message!,
                                                                              textAlign:
                                                                                  TextAlign.start,
                                                                              style:
                                                                                  TextStyle(
                                                                                color: grey99,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: ConstantFont.montserratMedium,
                                                                              ),
                                                                              maxLines:
                                                                                  5,
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    }()),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: completeddataList.length,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: nocompletedatavisible,
                                        child: Center(
                                          child: Container(
                                              width: screenwidth,
                                              height: screenHeight * 0.75,
                                              alignment: Alignment.center,
                                              child: ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
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
                                                      StringConstant
                                                          .youHavenAnyCompletedAppointment,
                                                      style: TextStyle(
                                                          color: whiteA3,
                                                          fontFamily: ConstantFont
                                                              .montserratMedium,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void callApiForaddReview(int? id, String message) {
    print("bookid:$id");
    print("bookrate:$rating");
    print("bookmesage:$message");
    Map<String,String> body={
      "message":message,
      "rate":rating.toString(),
      "booking_id":id.toString(),
    };
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData())
        .addreview(
      body
    )
        .then((response) {
      setState(() {
        _loading = false;
        print(response.success);
        if (response.success = true) {
          print("sucess");
          ToastMessage.toastMessage(response.msg!);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(1)),
          );
        }
      });
    }).catchError((Object obj) {
      setState(() {
        _loading = false;
      });
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response!;

          var responsecode = res.statusCode;
          var msg = res.statusMessage;

          if (responsecode == 401) {
            ToastMessage.toastMessage("Invalid Data");
            print(responsecode);
            print(res.statusMessage);
          } else if (responsecode == 422) {
            ToastMessage.toastMessage("Invalid Email");
            print("code:$responsecode");
            print("msg:$msg");
          }

          break;
        default:
      }
    });
  }

  void _newAddReview(BuildContext context, int? id) {
    dynamic screenwidth = MediaQuery.of(context).size.width;

    print("rateid:$id");

    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(top: 30, left: 15, bottom: 20),
                    color: whiteColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 1,
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top: 5, left: 10),
                            child: Text(
                              StringConstant.shareYourExperience,
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: ConstantFont.montserratMedium),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                top: 25, left: 5, right: 10, bottom: 5),
                            width: screenwidth,
                            height: 70,
                            color: whiteColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: screenwidth * .2,
                                  height: 70,
                                  alignment: Alignment.center,

                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: 40.0,
                                        width: 40.0,
                                        child: CircleAvatar(
                                          radius: 55,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                                DummyImage.theBarber),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 5, right: 5),
                                  width: screenwidth * .65,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: whiteF1,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    child: TextFormField(
                                      autofocus: false,
                                      controller: reviewTextController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      maxLines: 8,

                                      validator: (msg) {
                                        Pattern pattern =
                                            r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                                        RegExp regex =
                                            new RegExp(pattern as String);
                                        if (!regex.hasMatch(msg!))
                                          return 'Please Enter review message';
                                        else
                                          return null;
                                      },
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: blackColor,
                                          fontFamily:
                                              ConstantFont.montserratMedium,
                                          fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: whiteF1,
                                        hintText: 'Enter review',
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0,
                                            bottom: 0.0,
                                            top: 5.0,
                                            right: 5),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: whiteF1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: whiteF1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              StringConstant.howManyStarsYouWillGive,
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: ConstantFont.montserratMedium),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            alignment: Alignment.topLeft,
                            child: RatingStars(
                              value: rating,
                              onValueChanged: (v) {
                                setState(() {
                                  rating = v;
                                  print(v);
                                });
                              },
                              starBuilder: (index, color) => Icon(
                                Icons.star,
                                color: color,
                              ),
                              starCount: 5,
                              starSize: 20,
                              valueLabelColor: white9B,
                              valueLabelTextStyle: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              valueLabelRadius: 10,
                              maxValue: 5,
                              starSpacing: 2,
                              maxValueVisibility: true,
                              valueLabelVisibility: false,
                              animationDuration: Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              valueLabelMargin: const EdgeInsets.only(right: 8),
                              starOffColor: whiteE7,
                              starColor: yellowColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    side:
                                        BorderSide(color: pinkColor, width: 2)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (rating != 0.0) {
                                    AppConstant.checkNetwork().whenComplete(
                                        () => callApiForaddReview(
                                            id, reviewTextController.text));

                                    Navigator.pop(context);
                                    return;
                                  } else {
                                    ToastMessage.toastMessage(
                                        'Please give star rating.');
                                    return;
                                  }
                                }
                              },
                              child: Text(
                                StringConstant.shareReview,
                                style: TextStyle(
                                    color: pinkColor,
                                    fontFamily: ConstantFont.montserratMedium,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ]),
                  ),
                );
              },
            ),
          );
        });
  }

  void showcancledialog(BuildContext context, int id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Widget cancelButton = TextButton(
            child: Text(
              StringConstant.no,
              style: TextStyle(
                  color: greyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: ConstantFont.montserratMedium),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
          Widget continueButton = TextButton(
            child: Text(
              StringConstant.yes,
              style: TextStyle(
                  color: pinkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: ConstantFont.montserratMedium),
            ),
            onPressed: () {
              print("BookingId:$id");

              AppConstant.checkNetwork()
                  .whenComplete(() => callApiForCancelBooking(id));
              Navigator.pop(context);
            },
          );

          return AlertDialog(
            actions: [
              cancelButton,
              continueButton,
            ],
            title: Align(
              alignment: Alignment.topCenter,
              child: Text(
                StringConstant.cancelAppointment,
                style: TextStyle(
                    color: blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFont.montserratMedium),
                textAlign: TextAlign.center,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      StringConstant.areYouSureYouWantToCancelYourAppointment,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: greyColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: ConstantFont.montserratMedium),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showcancledialog1(int? id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 0, top: 20),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.27,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      StringConstant.cancelAppointment,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: ConstantFont.montserratMedium,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Divider(
                      thickness: 1,
                      color: whiteCc,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          StringConstant
                              .areYouSureYouWantToCancelYourAppointment,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: ConstantFont.montserratMedium,
                              color: blackColor),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Divider(
                          thickness: 1,
                          color: whiteCc,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  StringConstant.no,
                                  style: TextStyle(
                                      color: greyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          ConstantFont.montserratMedium),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    print("BookingId:$id");

                                    AppConstant.checkNetwork().whenComplete(
                                        () => callApiForCancelBooking(id!));
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    StringConstant.yes,
                                    style: TextStyle(
                                        color: pinkColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            ConstantFont.montserratMedium),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);

    return (await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => new HomeScreen(0)))) ??
        false;
  }

  void handleClick(
    String value,
  ) {
    print(value);
    RestClient(RetroApi().dioData())
        .deletereview(int.parse(value))
        .then((response) {
      print(response.toString());
      final body = json.decode(response!);

      bool? sucess = body['success'];
      print(sucess);

      setState(() {
        if (sucess = true) {
          ToastMessage.toastMessage(body['msg']);

          AppConstant.checkNetwork().whenComplete(() => CallApiforAppointment());
        } else {
          ToastMessage.toastMessage(body['msg']);
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
}
