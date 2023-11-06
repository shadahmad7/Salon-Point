import 'package:barber_app/ResponseModel/salonDetailResponse.dart';
import 'package:barber_app/constant/color_constant.dart';
import 'package:barber_app/constant/constant_font.dart';
import 'package:barber_app/constant/dymmyimages.dart';
import 'package:barber_app/constant/string_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';



class ReViewTab extends StatefulWidget {
  final List<SalonReview> reviewlist;

  ReViewTab(this.reviewlist);

  @override
  _ReViewTab createState() => _ReViewTab();
}

class _ReViewTab extends State<ReViewTab> {
  List<SalonReview> reviewlist = <SalonReview>[];

  int? currentSelectedIndex;
  String? categoryname;
  var rating = 0.0;
  bool datavisible = false;
  bool nodatavisible = true;


  @override
  void initState() {
    super.initState();
    if (widget.reviewlist.length > 0) {
      reviewlist = widget.reviewlist;
      datavisible = true;
      nodatavisible = false;
    } else {
      datavisible = false;
      nodatavisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: whiteColor,
          body: Padding(
              padding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 50),

              child: ListView(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            StringConstant.review,
                            style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontFamily: ConstantFont.montserratBold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 15),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Total Review' + "(" + reviewlist.length.toString() + ")",
                      style: TextStyle(
                          color: const Color(0xFFaeaeae),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: ConstantFont.montserratMedium),
                    ),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Visibility(
                          visible: datavisible,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 0.0, left: 0, right: 10, bottom: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                DateTime today = new DateTime.now();

                                String difference;
                                String difference1;

                                String date = reviewlist[index].createdAt!;

                                difference1 =
                                    "${today.difference(DateTime.parse(date)).inHours}" +
                                        " Hours Ago.";
                                difference =
                                    "${today.difference(DateTime.parse(date)).inHours}";

                                int diffrennce12 = int.parse(difference);

                                if (diffrennce12 > 24) {
                                  difference1 =
                                      "${today.difference(DateTime.parse(date)).inDays}" +
                                          " Days Ago.";
                                }

                                return new Container(
                                  alignment: Alignment.topLeft,
                                  width: screenwidth,
                                  color: whiteColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: screenwidth * .12,
                                        height: 75,
                                        // color: whiteColor,
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(left: 0),

                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(top: 15),
                                              height: 40.0,
                                              width: screenwidth * .12,
                                              alignment: Alignment.centerLeft,
                                              child: CachedNetworkImage(
                                                height: 35,
                                                width: 35,
                                                imageUrl: reviewlist[index]
                                                        .user!
                                                        .imagePath! +
                                                    reviewlist[index]
                                                        .user!
                                                        .image!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                ),

                                                placeholder: (context, url) =>
                                                    SpinKitFadingCircle(
                                                        color: pinkColor),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(DummyImage.noImage),
                                              ),
                                              // ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(top: 1),
                                              height: 12.0,
                                              width: screenwidth * .12,

                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 2),
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 0, left: 10),
                                                      child: SvgPicture.asset(
                                                        DummyImage.star,
                                                        width: 10,
                                                        height: 10,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 0, left: 2),
                                                      child: Text(
                                                          reviewlist[index]
                                                              .rate
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: yellowColor,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                              ConstantFont.montserratMedium)),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        margin: EdgeInsets.only(
                                            top: 5, left: 0, right: 5),
                                        width: screenwidth * .75,
                                        decoration: BoxDecoration(
                                          color: whiteF1,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 30,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      reviewlist[index]
                                                          .user!
                                                          .name!,
                                                      style: TextStyle(
                                                        color: blackColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                        ConstantFont.montserratSemiBold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5, right: 10),
                                                    child: Text(
                                                      difference1,
                                                      style: TextStyle(
                                                        color:
                                                            grey99,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                        ConstantFont.montserratMedium,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 20,
                                                  bottom: 10),

                                              child: Text(
                                                reviewlist[index].message!,
                                                style: TextStyle(
                                                  color: grey99,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: ConstantFont.montserratRegular,
                                                ),
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                              // color:yellowColor
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: reviewlist.length,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: nodatavisible,
                          child: SizedBox(
                            width: screenwidth,
                            height: 130,
                            child: Container(
                              transform:
                                  Matrix4.translationValues(5.0, 50.0, 0.0),
                              child: Center(
                                child: Container(
                                    width: screenwidth,
                                    height: screenHeight,
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
                                            StringConstant.noReview,
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
                        ),
                      ]),
                ],
              ))),
    );
  }
}
