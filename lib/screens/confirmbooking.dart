import 'dart:async';

import 'package:barber_app/ResponseModel/paymentGatwayResponse.dart';
import 'package:barber_app/ResponseModel/salonDetailResponse.dart';
import 'package:barber_app/common/common_view.dart';
import 'package:barber_app/constant/appconstant.dart';
import 'package:barber_app/constant/color_constant.dart';
import 'package:barber_app/constant/constant_font.dart';
import 'package:barber_app/constant/dymmyimages.dart';
import 'package:barber_app/constant/preferenceutils.dart';
import 'package:barber_app/constant/string_constant.dart';
import 'package:barber_app/constant/toast_message.dart';
import 'package:barber_app/drawerscreen/top_offers.dart';
import 'package:barber_app/network/Apiservice.dart';
import 'package:barber_app/network/BaseModel.dart';
import 'package:barber_app/network/Retro_Api.dart';
import 'package:barber_app/network/ServerError.dart';
import 'package:barber_app/screens/generateStripToken.dart';
import 'package:barber_app/screens/homescreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmBooking extends StatefulWidget {
  final double? totalprice;
  final List<int?>? selecteServices ;

  final int? salonId;
  final  date;

  final time;
  final int? selectedempid;
  final List? _totalprice ;

  final List<String?>? _selecteServicesName;

  final SalonDetails salonData;
  final bool couponvisible;
  final bool couponnotvisible;

  ConfirmBooking(
      this.selectedempid,
      this.time,
      this.date,
      this.totalprice,
      this.selecteServices,
      this.salonId,
      this._selecteServicesName,
      this._totalprice,
      this.salonData,
      this.couponvisible,
      this.couponnotvisible);

  @override
  _ConfirmBooking createState() => new _ConfirmBooking();
}

class _ConfirmBooking extends State<ConfirmBooking> {
  bool _loading = false;
  double? totalprice;
  List<int>? selecteServices = <int>[];
  int? salonId;
  var date;
  var time;
  int? selectedempid;
  List? _totalprice = [];
  var rating = 1.0;

  List<String>? _selecteServicesName = <String>[];
  late var parsedDate;

  SalonDetails? salonData;
  bool couponvisible = true;
  bool couponnotvisible = false;
  CardFieldInputDetails? _card = CardFieldInputDetails(complete: false);
  String radioItem = 'Pay Local';
  int id = 1;
  String? image = "assets/images/localpay.png";
  List<PaymentType> fList = [];
  @override
  void initState() {
    super.initState();
    print(widget.salonData.salonId);
    WidgetsFlutterBinding.ensureInitialized();

    PreferenceUtils.init();

    AppConstant.checkNetwork().whenComplete(() => getPaymentSettingData());

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    totalprice = widget.totalprice;
    selecteServices = widget.selecteServices!.cast<int>();
    salonId = widget.salonId;
    date = widget.date;
    time = widget.time;
    selectedempid = widget.selectedempid;
    _totalprice = widget._totalprice;
    _selecteServicesName = widget._selecteServicesName!.cast<String>();
    salonData = widget.salonData;
    couponvisible = widget.couponvisible;
    couponnotvisible = widget.couponnotvisible;
    parsedDate = DateTime.parse(date);
    var df = new DateFormat('MMMM dd,yyyy');

    parsedDate = df.format(parsedDate);
  }

  PaymentGatwayResponse? paymentSetting;

  void callApiForaddReview(int id, String? message) {
    print("bookid:$id");
    print("bookSalonid:$salonId");
    print("bookrate:$rating");
    print("bookmesage:$message");
    Map<String,String> body={
      "message":message!,
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

  Future<BaseModel<PaymentGatwayResponse>> getPaymentSettingData() async {
    PaymentGatwayResponse response;
    try {
      setState(() {
        _loading = true;
      });
      response = await RestClient(RetroApi().dioData()).paymentgateway();
      if (response.success == true) {

        paymentSetting = response;
        if (response.data!.cod == 1) {
          fList.add(PaymentType(
              index: 1, name: "LOCAL", image: "images/localpay.png"));
        }
        if (response.data!.stripe == 1) {
          stripkey = response.data!.stripePublicKey;
          stripkey=response.data!.stripePublicKey;
          Stripe.publishableKey = stripkey!;
          fList.add(
            PaymentType(index: 2, name: "stripe", image: "images/stripe.png"),
          );
        }
      } else {
        print(response.msg);
        ToastMessage.toastMessage(response.msg.toString());
      }

      setState(() {
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  String _result = "paypal";
  int? _radioValue = -1;
  late Razorpay _razorpay;

  String? stripkey = "";
  String? rozarkey = " ";

  void _sucesspayment(BuildContext context, int? radioValue, String result) {
    String paymentToken = "";

    AppConstant.checkNetwork()
        .whenComplete(() => callApiForBookService(result, paymentToken));
  }

  void setstripe(BuildContext context, String result) {
    Stripe.publishableKey = stripkey!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      StringConstant.stripe,
                      style: TextStyle(
                          color: blackColor,
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  CardField(
                    enablePostalCode: false,
                    onCardChanged: (card) {
                      setState(() {
                        _card = card;
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: OutlinedButton(
                      child: Text(StringConstant.pay),
                      onPressed: () {
                        if (_card!.complete == true &&
                            _card!.last4!.isNotEmpty) {
                          _handleCreateTokenPress(result);
                        } else {
                          ToastMessage.toastMessage(
                              "Something went wrong in Stripe payment");
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  //stripe
  Future<void> _handleCreateTokenPress(result) async {
    if (_card == null) {
      return;
    }

    try {
      final tokenData = await Stripe.instance.createToken(
        CreateTokenParams(type: TokenType.Card),
      );
      Navigator.pop(context);
      AppConstant.checkNetwork()
          .whenComplete(() => callApiForBookService(result, tokenData.id));
      return;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  void openCheckout(BuildContext context, String result) {
    var options = {
      'key': rozarkey,
      'amount': totalprice! * 100,
      'name': PreferenceUtils.getString(AppConstant.username),
      'description': 'Payment',
      'prefill': {
        'contact': PreferenceUtils.getString(AppConstant.userphone),
        'email': PreferenceUtils.getString(AppConstant.useremail)
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      print(response.paymentId);
      String paymentToken = response.paymentId.toString();

      AppConstant.checkNetwork()
          .whenComplete(() => callApiForBookService("rozarpay", paymentToken));
      print("done");
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, timeInSecForIosWeb: 4);
  }

  void callApiForBookService(String result1, String paymentToken) {
    print("con_salonid:$salonId");
    print("con_selectedempid:$selectedempid");
    print("con_selecteServices:$selecteServices");
    print("con_totalprice:$totalprice");
    print("con_date:$date");
    print("con_time:$time");
    print("con_result1:$result1");
    print("con_paymentToken:$paymentToken");

    Map<String,String> body={
      "emp_id":selectedempid.toString(),
      "service_id":selecteServices.toString(),
      "payment":totalprice.toString(),
      "date": date.toString(),
      "start_time":time.toString(),
      "payment_type":result1,
      "payment_token":paymentToken
    };
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData())
        .booking(body)
        .then((response) {
      print("bookinresponse:${response.toString()}");
      setState(() {
        _loading = false;
        if (response.success = true) {
          showsucess();
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

      print("bookinresponse_error:${obj.toString()}");
    });
  }

  int? currentSelectedIndex;
  String? categoryname;

  bool viewVisible = false;

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }


  Future<bool> _onWillPop() async {
    final completer = Completer<bool>();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (ctxt) => new HomeScreen(1)));
    completer.complete(true);
    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    dynamic screenwidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: _loading,
      opacity: 1.0,
      color: Colors.transparent.withOpacity(0.2),
      progressIndicator: SpinKitFadingCircle(color: pinkColor),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
              backgroundColor: whiteColor,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: blackColor,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  StringConstant.bookAppointment,
                  style: TextStyle(
                      color: blackColor,
                      fontFamily: ConstantFont.montserratBold,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
                backgroundColor: whiteColor,
                elevation: 0.0,
              ),
              body: new Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.05),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: new Column(
                        children: <Widget>[
                          ///confirm your booking text
                          Container(
                            margin: EdgeInsets.only(
                              top: 10.0,
                              bottom: 00.0,
                              left: 30.0,
                              right: 0.0,
                            ),
                            color: whiteColor,
                            child: Text(
                              StringConstant.confirmationYourBooking,
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: ConstantFont.montserratBold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),

                          ///salon details
                          Container(
                            height: 120,
                            margin: EdgeInsets.all(10),
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              height: 120,
                              // constraints: BoxConstraints.expand(),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: whiteF1, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),

                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.topLeft,
                                      margin:
                                          EdgeInsets.only(left: 5.0, top: 0.0),
                                      child: Row(
                                        children: <Widget>[
                                          new Container(
                                            height: 70,
                                            width: 70,
                                            alignment: Alignment.topLeft,
                                            child: CachedNetworkImage(
                                              imageUrl: salonData!.imagePath! +
                                                  salonData!.image!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
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
                                          ),
                                          new Container(
                                              width: screenwidth * .65,
                                              height: 110,
                                              margin: EdgeInsets.only(
                                                  left: 5.0, top: 0.0),
                                              alignment: Alignment.topLeft,
                                              color: whiteColor,
                                              child: ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20.0),
                                                    child: Text(
                                                      salonData!.name!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: blackColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: ConstantFont
                                                              .montserratSemiBold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5.0),
                                                    child: Text(
                                                      salonData!.address!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: ConstantFont
                                                              .montserratMedium),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      left: 0.0,
                                                                      top: 5.0),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    WidgetSpan(
                                                                      child: Icon(
                                                                        Icons
                                                                            .star,
                                                                        size: 14,
                                                                        color:
                                                                            yellowColor,
                                                                      ),
                                                                    ),
                                                                    TextSpan(text: salonData!.rate.toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                greyColor,
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w600)),
                                                                    TextSpan(
                                                                        text: StringConstant
                                                                            .rating,
                                                                        style: TextStyle(
                                                                            color:
                                                                                greyColor,
                                                                            fontSize:
                                                                                11,
                                                                            fontFamily: ConstantFont
                                                                                .montserratMedium,
                                                                            fontWeight:
                                                                                FontWeight.w600)),
                                                                  ],
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            alignment:
                                                                Alignment.center,
                                                            width: 5.0,
                                                            height: 5.0,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5.0,
                                                                    top: 5.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              color: greyColor,
                                                            ),
                                                          ),
                                                          Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      left: 5.0,
                                                                      top: 5.0,
                                                                      right: 0),
                                                              child: RichText(
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textScaleFactor:
                                                                    1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                text: TextSpan(
                                                                  children: [
                                                                    WidgetSpan(
                                                                      child: Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        size: 14,
                                                                        color:
                                                                            pinkColor,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                        text: time
                                                                                .toString() +
                                                                            " - " +
                                                                            parsedDate
                                                                                .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                greyColor,
                                                                            fontFamily: ConstantFont
                                                                                .montserratMedium,
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w600)),
                                                                  ],
                                                                ),
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ],
                                      )),
                                ],
                              ),

                              // color: greyColor,
                            ),
                          ),

                          ///select your service text
                          Container(
                            margin: EdgeInsets.only(
                              top: 10.0,
                              bottom: 00.0,
                              left: 30.0,
                              right: 0.0,
                            ),
                            color: whiteColor,
                            child: Text(
                              StringConstant.serviceYouSelected,
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: ConstantFont.montserratBold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),

                          ///service list
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _selecteServicesName!.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 00.0,
                                    left: 30.0,
                                    right: 15.0,
                                  ),
                                  color: whiteColor,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              _selecteServicesName![index],
                                              style: TextStyle(
                                                  color: grey99,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  fontFamily: ConstantFont
                                                      .montserratMedium),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              _totalprice![index].toString() +
                                                  " ₹",
                                              style: TextStyle(
                                                  color: grey99,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  fontFamily: ConstantFont
                                                      .montserratMedium),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          child: DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 1.0,
                                        dashLength: 4.0,
                                        dashColor:
                                            Color(0xe2777474).withOpacity(0.3),
                                        dashRadius: 0.0,
                                        dashGapLength: 4.0,
                                        dashGapColor: Colors.transparent,
                                        dashGapRadius: 0.0,
                                      )),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          ///only sized box
                          SizedBox(height: 10.0),
                          ///coupan applied
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 25, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFF80dcb4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: couponnotvisible,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15, top: 5),
                                        alignment: Alignment.center,
                                        child: Text(
                                          StringConstant.youHaveACouponToUse,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              fontFamily:
                                                  ConstantFont.montserratMedium),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (ctxt) => new TopOffers(
                                                  1,
                                                  selectedempid,
                                                  time,
                                                  date,
                                                  totalprice,
                                                  selecteServices,
                                                  salonId,
                                                  _selecteServicesName,
                                                  _totalprice,
                                                  salonData),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(right: 10, top: 6),
                                          alignment: Alignment.center,
                                          child: Text(
                                            StringConstant.clickHere,
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                fontFamily:
                                                    ConstantFont.montserratBold),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: couponvisible,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15, top: 5),
                                        alignment: Alignment.center,
                                        child: Text(
                                          StringConstant.couponApplied,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              fontFamily:
                                                  ConstantFont.montserratMedium),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(right: 10, top: 6),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'new price: ' +
                                                totalprice.toString() +
                                                " ₹",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                fontFamily: ConstantFont
                                                    .montserratMedium),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///select payment method text
                          Container(
                            margin: EdgeInsets.only(
                              top: 20.0,
                              bottom: 00.0,
                              left: 30.0,
                              right: 0.0,
                            ),
                            color: whiteColor,
                            child: Text(
                              StringConstant.selectPaymentMethod,
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: ConstantFont.montserratBold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),

                          ///payment type select
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: fList.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: RadioListTile(
                                  groupValue: id,
                                  value: fList[index].index,
                                  activeColor: pinkColor,
                                  onChanged: (val) {
                                    setState(() {
                                      radioItem = fList[index].name;
                                      id = fList[index].index;
                                      image = fList[index].image;
                                      _result = fList[index].name;
                                    });
                                  },
                                  title: Text(
                                    "${fList[index].name}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: ConstantFont.montserratMedium,
                                        color: Colors.black),
                                  ),
                                  secondary: Container(
                                      height: 20,
                                      width: 30,
                                      child: Image.asset(
                                        "${fList[index].image.toString()}",
                                        color: pinkColor,
                                        height: 20,
                                        width: 30,
                                        fit: BoxFit.fill,
                                      )),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                ),
                              );
                            },
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        print(_result);
                                        if (_result == "stripe") {
                                          print(stripkey);
                                          print(_result);
                                          print(widget.selectedempid);
                                          print(selecteServices);
                                          print(widget.totalprice);
                                          print(widget.time);
                                          print(widget.date);
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GenerateStripeToken(stripeKey: stripkey!,salonDetails: widget.salonData,result:"stripe",empId: widget.selectedempid!,selectedServices: selecteServices!,totalPrice: widget.totalprice!,date: widget.date,time: widget.time,)));
                                        }
                                        else
                                          {
                                            _sucesspayment(context, _radioValue, _result);
                                          }
                                      });
                                    },
                                    child: Text("Pay")),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomView(),
                  ),
                ], // new Container(child: Body(viewVisible))],
              )),
        ),
      ),
    );
  }

  void showsucess() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                margin: EdgeInsets.only(top: 30, left: 15, bottom: 20),
                color: whiteColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 1,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0, left: 0.0),
                          alignment: FractionalOffset.center,
                          child: Image.asset(
                            DummyImage.changePasswordDone,
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 15.0, right: 15),
                          child: Text(
                            StringConstant.yourAppointmentBookingIsSuccessfully,
                            style: TextStyle(
                                color: blackColor,
                                fontFamily: ConstantFont.montserratMedium,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 15.0, right: 15),
                          child: Text(
                            StringConstant
                                .youCanSeeYourUpcomingAppointmentInAppointmentSection,
                            style: TextStyle(
                                color: greyColor,
                                fontFamily: ConstantFont.montserratMedium,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _radioValue = -1;

                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (ctxt) => new HomeScreen(1)));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 40.0, left: 15.0, right: 15, bottom: 20),
                            child: Text(
                              StringConstant.goThere,
                              style: TextStyle(
                                  color: blue21,
                                  fontFamily: ConstantFont.montserratMedium,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ]),
              );
            },
          );
        });
  }
}

class PaymentType {
  String name;
  int index;
  String image;

  PaymentType({
    required this.name,
    required this.index,
    required this.image,
  });
}
