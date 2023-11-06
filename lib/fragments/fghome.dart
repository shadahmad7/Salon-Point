import 'dart:io';
import 'package:barber_app/ResponseModel/bannerResponse.dart';
import 'package:barber_app/ResponseModel/categorydataResponse.dart';
import 'package:barber_app/ResponseModel/salonResponse.dart';
import 'package:barber_app/ResponseModel/shared_setting_response.dart';
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
import 'package:barber_app/network/BaseModel.dart';
import 'package:barber_app/network/Retro_Api.dart';
import 'package:barber_app/network/ServerError.dart';
import 'package:barber_app/screens/detailbarber.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FgHome extends StatefulWidget {
  FgHome({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FgHome createState() => _FgHome();
}

class _FgHome extends State<FgHome> {
  List<BannerData> bannerImage = [];
  List<String> image12 = <String>[];
  List<String?> bannerTitle = <String?>[];
  List<CategoryData> categoryDataList = <CategoryData>[];
  List<SalonDataList> salonDataList = <SalonDataList>[];
  String name = "User";
  bool _loading = false;
  String? singleImage;
  String? singleTitle;
  int index = 0;

  String currentAddress = "No address found";
  @override
  void initState() {
    super.initState();
      getSharedSetting();
    if (mounted) {
      setState(() {
        PreferenceUtils.init();
        checkpermission();
        name = PreferenceUtils.getString(AppConstant.username);

        AppConstant.checkNetwork().whenComplete(() => callApiForBanner());
        AppConstant.checkNetwork().whenComplete(() => callApiForCategory());

        AppConstant.cuttentlocation()
            .whenComplete(() => AppConstant.cuttentlocation().then((value) {
                  currentAddress = value;
                }));
      });
    }
  }
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        AppConstant.checkNetwork().whenComplete(() => callApiForBanner());
        AppConstant.checkNetwork().whenComplete(() => callApiForCategory());
      });
    }
  }
  Future<BaseModel<SharedSettingResponse>> getSharedSetting() async{
    SharedSettingResponse response;
    try
        {
          response=await RestClient(RetroApi().dioData()).getSharedSetting();
          if(response.success==true)
            {
              PreferenceUtils.setString(AppConstant.sharedName, response.data!.sharedName==null?"":response.data!.sharedName!);
              PreferenceUtils.setString(AppConstant.sharedUrl, response.data!.sharedUrl==null?"":response.data!.sharedUrl!);
              PreferenceUtils.setString(AppConstant.sharedImage, response.data!.imagePath==null&&response.data!.sharedImage==null?response.data!.imagePath!+response.data!.sharedImage!:"");
            }
          else
            {
              ToastMessage.toastMessage(response.msg!);
            }
        }
        catch(error)
    {
      setState(() {
        _loading = false;
      });
      return BaseModel()..setException(ServerError.withError(error:error));
    }
    return BaseModel()..data=response;
  }
  void checkpermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    permission = await Geolocator.checkPermission();
    print("permissionresult:$permission");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("denied");
    } else if (permission == LocationPermission.whileInUse) {
      print("whileInUse56362");
      AppConstant.cuttentlocation()
          .whenComplete(() => AppConstant.cuttentlocation().then((value) {
                currentAddress = value;
              }));
    } else if (permission == LocationPermission.always) {
      print("always");
      AppConstant.cuttentlocation()
          .whenComplete(() => AppConstant.cuttentlocation().then((value) {
                currentAddress = value;
              }));
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(StringConstant.areYouSure),
        content: Text(StringConstant.doYouWantToExitAnApp),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(StringConstant.no),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: Text(StringConstant.yes),
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  void callApiForBanner() {
    setState(() {
      _loading = true;
    });
    bannerImage.clear();
    RestClient(RetroApi().dioData()).banners().then((response) {
      if (mounted) {
        setState(() {
          _loading = false;
          if (response.success = true) {
            print(response.data!.length);
            bannerImage.addAll(response.data!);
            image12.clear();
            for (int i = 0; i < bannerImage.length; i++) {
              image12.add(bannerImage[i].imagePath! + bannerImage[i].image!);
              bannerTitle.add(bannerImage[i].title);
              singleImage=bannerImage[i].imagePath!+bannerImage[i].image!;
              singleTitle=bannerImage[i].title;
            }
            int length123 = image12.length;
            print("StringlistSize:$length123");
          } else {
            ToastMessage.toastMessage("No Data");
          }
        });
      }
    }).catchError((Object obj) {
      setState(() {
        _loading = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  void callApiForCategory() {
    categoryDataList.clear();
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData()).categories().then((response) {
      if (mounted) {
        setState(() {
          _loading = false;
          if (response.success = true) {
            print(response.data!.length);
            categoryDataList.addAll(response.data!);
          } else {
            ToastMessage.toastMessage("No Data");
          }
        });
      }
    }).catchError((Object obj) {
      setState(() {
        _loading = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
    });
  }

  int _current = 0;

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    dynamic screenwidth = MediaQuery.of(context).size.width;
       ScreenUtil.init(
      context,
    //  maxWidth: MediaQuery.of(context).size.width,
    //  maxHeight: MediaQuery.of(context).size.height,
        designSize: Size(360, 690),
        // orientation: Orientation.portrait
    );
        

    return WillPopScope(
        onWillPop: _onWillPop,
        child: ModalProgressHUD(
          inAsyncCall: _loading,
          opacity: 1.0,
          color: Colors.transparent.withOpacity(0.2),
          progressIndicator:
              SpinKitFadingCircle(color:pinkColor),
          child: SafeArea(
            child: Scaffold(
                backgroundColor: whiteColor,
                appBar: appbar(context, StringConstant.home, _drawerscaffoldkey, false)
                    as PreferredSizeWidget?,
                resizeToAvoidBottomInset: true,
                key: _drawerscaffoldkey,
                drawer: new DrawerOnly(),
                body: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            bannerImage.length>0? bannerImage.length==1?Container(
                              width: screenwidth,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent,
                              ),
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Card(
                                elevation: 10,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                          child: Stack(
                                            children: <Widget>[
                                              Material(
                                                color: whiteColor,
                                                borderRadius:
                                                BorderRadius.circular(15.0),
                                                elevation: 2.0,
                                                clipBehavior:
                                                Clip.none,
                                                type: MaterialType.canvas,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: ColorFiltered(
                                                    colorFilter: ColorFilter.mode(
                                                        blackColor
                                                            .withOpacity(0.4),
                                                        BlendMode.srcOver),
                                                    child: CachedNetworkImage(
                                                      imageUrl:singleImage!,
                                                      height: 200,
                                                      width: 500,
                                                      fit: BoxFit.fill,
                                                      placeholder:
                                                          (context, url) =>
                                                          SpinKitFadingCircle(
                                                            color: pinkColor,
                                                          ),
                                                      errorWidget: (context, url,
                                                          error) =>
                                                          Image.asset(
                                                              DummyImage.noImage),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  singleTitle!,
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 26,
                                                      fontFamily: ConstantFont.montserratRegular,
                                                      fontWeight:
                                                      FontWeight.w800),
                                                ),
                                              )
                                            ],
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: List.generate(
                                              image12.length,
                                                  (index) => Container(
                                                alignment:
                                                Alignment.bottomCenter,
                                                width: 9.0,
                                                height: 9.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _current == index
                                                      ? pinkColor
                                                      : whiteColor,
                                                ),
                                              ))
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ):Container(
                              width: screenwidth,
                              height: 200,
                              color: Colors.transparent,
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Card(
                                elevation: 10,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          height: 190,
                                          viewportFraction: 1.0,
                                          onPageChanged: (index, index1) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),

                                        items: bannerImage.map((it) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                  child: Stack(
                                                children: <Widget>[
                                                  Material(
                                                    color: whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(15.0),
                                                    elevation: 2.0,
                                                    clipBehavior:
                                                        Clip.antiAliasWithSaveLayer,
                                                    type: MaterialType.transparency,
                                                    child: ColorFiltered(
                                                      colorFilter: ColorFilter.mode(
                                                          blackColor
                                                              .withOpacity(0.4),
                                                          BlendMode.srcOver),
                                                      child: CachedNetworkImage(
                                                        imageUrl: it.imagePath! +
                                                            it.image!,
                                                        height: 200,
                                                        width: 500,
                                                        fit: BoxFit.fill,
                                                        placeholder:
                                                            (context, url) =>
                                                                SpinKitFadingCircle(
                                                          color: pinkColor,
                                                        ),
                                                        errorWidget: (context, url,
                                                                error) =>
                                                            Image.asset(
                                                                DummyImage.noImage),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      it.title!,
                                                      style: TextStyle(
                                                          color: whiteColor,
                                                          fontSize: 26,
                                                          fontFamily: ConstantFont.montserratRegular,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                  )
                                                ],
                                              ));
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                              image12.length,
                                              (index) => Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    width: 9.0,
                                                    height: 9.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _current == index
                                                          ? pinkColor
                                                          : whiteColor,
                                                    ),
                                                  ))
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            ):Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Container( height: 200,width:MediaQuery.of(context).size.width,child: Center(child: Text("No Data Found",style: TextStyle(fontFamily: ConstantFont.montserratSemiBold,color: whiteA3),))),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20.0, top: 15),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    StringConstant.topServices,
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantFont.montserratBold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          categoryDataList.length==0?Container(
                            child: Column(
                              children: [
                                Image.asset(
                                  DummyImage.noData,
                                  alignment: Alignment.center,
                                  width: 150,
                                  height: 100,
                                ),
                                Text("No Data Found",style: TextStyle(fontFamily: ConstantFont.montserratSemiBold,color: whiteA3),)
                              ],
                            ),
                          ) :Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: GridView.count(
                                childAspectRatio: 2.3,
                                crossAxisCount: 2,
                                crossAxisSpacing: 0.0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                mainAxisSpacing: ScreenUtil().setWidth(10),
                                children:
                                    List.generate(categoryDataList.length, (index) {
                                  return Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        print(index);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new DetailBarber(
                                                        categoryDataList[index]
                                                            .catId)));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(10),
                                            right: ScreenUtil().setWidth(10)),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          color:whiteColor,
                                          elevation: 5,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: ScreenUtil().setWidth(20),
                                                    right:
                                                        ScreenUtil().setWidth(10)),
                                                child: CachedNetworkImage(
                                                  imageUrl: categoryDataList[index]
                                                          .imagePath! +
                                                      categoryDataList[index]
                                                          .image!,
                                                  width: ScreenUtil().setWidth(30),
                                                  height: ScreenUtil().setHeight(30),
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
                                                      SpinKitFadingCircle(
                                                    color: pinkColor,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          DummyImage.noImage),
                                                ),
                                              ),
                                              Container(
                                                width: ScreenUtil().setWidth(75),
                                                child: Text(
                                                  categoryDataList[index].name!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: blackColor,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: ConstantFont.montserratMedium),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ]),
                )),
          ),
        ));
  }

}
