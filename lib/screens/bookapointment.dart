import 'package:barber_app/ResponseModel/empResponse.dart';
import 'package:barber_app/ResponseModel/salonDetailResponse.dart';
import 'package:barber_app/ResponseModel/timedataResponseModel.dart';
import 'package:barber_app/common/common_view.dart';
import 'package:barber_app/constant/appconstant.dart';
import 'package:barber_app/constant/color_constant.dart';
import 'package:barber_app/constant/constant_font.dart';
import 'package:barber_app/constant/dymmyimages.dart';
import 'package:barber_app/constant/preferenceutils.dart';
import 'package:barber_app/constant/string_constant.dart';
import 'package:barber_app/constant/toast_message.dart';
import 'package:barber_app/network/Apiservice.dart';
import 'package:barber_app/network/Retro_Api.dart';
import 'package:barber_app/separator/separator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:table_calendar/table_calendar.dart';

import 'confirmbooking.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
  ));
}

class BookApointment extends StatefulWidget {
  final double totalprice;
  final List<int?> selecteServices;
  final int? salonId;
  final List _totalprice;
  final List<String?> _selecteServicesName;
  final SalonDetails? salonData;

  BookApointment(this.totalprice, this.selecteServices, this.salonId,
      this._selecteServicesName, this._totalprice, this.salonData);

  @override
  _BookApointment createState() => new _BookApointment();
}

class _BookApointment extends State<BookApointment>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();
  int index = 0;

  double? totalprice;
  List<int?> selecteServices = <int>[];
  int? salonId;
  var date;
  var time;
  int? selectedempid;
  List _totalprice = [];
  List<String?> _selecteServicesName = <String>[];
  SalonDetails? salonData;

  int discount = 0;
  bool _loading = false;

  List<EmpData> emplist = <EmpData>[];
  List<TimeData> timelist = <TimeData>[];

  @override
  void initState() {
    super.initState();
    print(widget.salonData!.salonId);
    _yesterday = DateTime.now();
    selectedDay = DateTime.now();
    var myFormat = DateFormat('yyyy-MM-dd');
    date = myFormat.format(selectedDay);

    totalprice = widget.totalprice;
    selecteServices = widget.selecteServices;
    salonId = widget.salonId;
    _totalprice = widget._totalprice;
    _selecteServicesName = widget._selecteServicesName;
    salonData = widget.salonData;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    PreferenceUtils.init();

    if (date != null) {
      AppConstant.checkNetwork()
          .whenComplete(() => callApiforgettimeslote(date));
    }
  }

  void callApiForEmpData() {
    Map<String,String> body={
      "start_time":time,
      "service":selecteServices.toString(),
      "date":date,
    };
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData())
        .selectemp(
        body
    )
        .then((response) {
      setState(() {
        print(response.toString());

        print(response.toString());

        if (response.success = true) {

          if (response.data!.length > 0) {
            viewVisible = true;
            showWidget();

            emplist.addAll(response.data!);
          } else {
            viewVisible = false;
          }

          print(emplist[0].empId);
          print(response.msg);
        } else if (response.success == false) {
          ToastMessage.toastMessage(response.msg!);
        }
      });
      setState(() {
        _loading=false;
      });
      }
      ).
    catchError((Object obj) {
      setState(() {
        _loading = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      ToastMessage.toastMessage("No employee available at this time");
    });
  }

  void callApiforgettimeslote(date) {
    print("date852:$date");
    print("salonid:$salonId");
    Map<String,String> body={
      "salon_id":salonId.toString(),
      "date":date,
    };
    setState(() {
      _loading = true;
    });
    RestClient(RetroApi().dioData())
        .timeslot(
        body
    )
        .then((response) {
      setState(() {
        print(response.toString());

        print(response.toString());

        if (response.success = true) {
          if (response.data!.length > 0) {
            timelist.clear();

            timeVisible = true;
            timenotVisible = false;
            timelist.addAll(response.data!);
          } else {
            timeVisible = false;
            timenotVisible = true;
            viewVisible = false;
          }

          print(response.msg);
        } else if (response.success == false) {
          timeVisible = false;
          timenotVisible = true;
          viewVisible = false;
          ToastMessage.toastMessage(response.msg!);
        }
      });
      setState(() {
        _loading = false;
      });
    }).catchError((Object obj) {
      setState(() {
        _loading = false;
      });
      print("error:$obj");
      print(obj.runtimeType);
      timelist.clear();
      timeVisible = false;
      timenotVisible = true;
      viewVisible = false;
    });
  }

  List timedatalist = [
    {
      "time": "09:00AM",
    },
    {
      "time": "09:30AM",
    },
    {
      "time": "10:00AM",
    },
    {
      "time": "10:30AM",
    },
    {
      "time": "11:00AM",
    },
    {
      "time": "11:30AM",
    },
    {
      "time": "12:00PM",
    },
    {
      "time": "12:30PM",
    },
    {
      "time": "01:00PM",
    },
    {
      "time": "01:30PM",
    },
    {
      "time": "02:00PM",
    },
    {
      "time": "02:30PM",
    },
    {
      "time": "03:00PM",
    },
    {
      "time": "03:30PM",
    },
    {
      "time": "04:00PM",
    },
    {
      "time": "04:30PM",
    },
    {
      "time": "05:00PM",
    },
    {
      "time": "05:30PM",
    },
    {
      "time": "06:00PM",
    },
    {
      "time": "06:30PM",
    },
    {
      "time": "07:00PM",
    },
    {
      "time": "07:30PM",
    },
    {
      "time": "08:00PM",
    },
  ];
  int? currentSelectedIndex;
  String? categoryname;

  bool viewVisible = false;
  bool viewVisible1 = false;

  bool timeVisible = false;
  bool timenotVisible = false;
  DateTime? _selectedDay;
  DateTime? _yesterday;

  void showWidget() {
    setState(() {
      viewVisible = true;
      viewVisible1 = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible1 = false;
    });
  }

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  late AnimationController _animationController;
  var selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: _loading,
      opacity: 1.0,
      color: Colors.transparent.withOpacity(0.2),
      progressIndicator:
          SpinKitFadingCircle(color:pinkColor),
      child: SafeArea(
        child: Scaffold(
          backgroundColor:whiteColor,
          key: _drawerscaffoldkey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: blackColor,
                size: 30,
              ),
              onPressed: () {
                if (viewVisible1 == false) {
                  Navigator.of(context).pop();
                }

                if (viewVisible1 == true) {
                  hideWidget();
                }
              },
            ),
            title: Text(
              StringConstant.bookAppointment,
              style: TextStyle(
                  color: blackColor,
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: whiteColor,
            elevation: 0.0,
          ),
          body: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: whiteColor,
              body: new Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: new ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: 1.0,
                                left: 15,
                                right: 15,
                              ),
                              color: whiteColor,
                              height: screenHeight * .20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TableCalendar(
                                    firstDay: DateTime.utc(2020, 01, 01),
                                    lastDay: DateTime.utc(2040, 01, 01),
                                    focusedDay: _selectedDay ?? DateTime.now(),
                                    currentDay: _selectedDay,
                                    calendarFormat: CalendarFormat.week,
                                    headerStyle: HeaderStyle(
                                      leftChevronIcon: Icon(
                                        Icons.chevron_left,
                                        color: pinkColor,
                                      ),
                                      rightChevronIcon: Icon(
                                        Icons.chevron_right,
                                        color: pinkColor,
                                      ),
                                      titleTextStyle: TextStyle(
                                        color: blackColor,
                                        fontSize: 18.0,
                                        fontFamily: 'FivoSansMedium',
                                      ),
                                      titleCentered: true,
                                      formatButtonVisible: false,
                                    ),
                                    calendarStyle: CalendarStyle(
                                      outsideDaysVisible: true,
                                      weekendTextStyle:
                                          TextStyle(color: blackColor,fontFamily: ConstantFont.montserratMedium),
                                      defaultTextStyle:
                                          TextStyle(color: blackColor,fontFamily: ConstantFont.montserratMedium),
                                      outsideTextStyle:
                                          TextStyle(color: greyColor,fontFamily: ConstantFont.montserratMedium),
                                      disabledTextStyle:
                                          TextStyle(color: greyColor,fontFamily: ConstantFont.montserratMedium),
                                      todayTextStyle: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16.0,
                                        fontFamily: ConstantFont.montserratMedium,
                                      ),
                                      holidayTextStyle:
                                          TextStyle(color: greyColor),
                                      todayDecoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      cellMargin: EdgeInsets.all(9.0),
                                    ),
                                    sixWeekMonthsEnforced: true,
                                    startingDayOfWeek: StartingDayOfWeek.sunday,
                                    daysOfWeekStyle: DaysOfWeekStyle(
                                      weekdayStyle:
                                          TextStyle(color: whiteColor),
                                      weekendStyle:
                                          TextStyle(color: whiteColor),
                                      dowTextFormatter: (date, locale) =>
                                          DateFormat.E(locale).format(date)[0],
                                    ),
                                    enabledDayPredicate: (dt) => dt.isAfter(
                                        DateTime(
                                            _yesterday!.year,
                                            _yesterday!.month,
                                            _yesterday!.day)),
                                    onDaySelected: (selectedDayONSelect, _) {
                                      setState(() {
                                        _selectedDay = selectedDayONSelect;
                                        var addZero;
                                        var addMonthZero;
                                        if (selectedDayONSelect.day < 10) {
                                          addZero = '0' + selectedDayONSelect.day.toString();
                                        } else {
                                          addZero = selectedDayONSelect.day.toString();
                                        }
                                        if (selectedDayONSelect.month < 10) {
                                          addMonthZero = '0' + selectedDayONSelect.month.toString();
                                        } else {
                                          addMonthZero = selectedDayONSelect.month.toString();
                                        }
                                        setState(() {
                                          selectedDay = selectedDayONSelect;
                                          var myFormat =
                                              DateFormat('yyyy-MM-dd');
                                          date = myFormat.format(selectedDayONSelect);

                                          if (mounted) {
                                            if (date != null) {
                                              AppConstant.checkNetwork()
                                                  .whenComplete(() =>
                                                      callApiforgettimeslote(
                                                          date));
                                            }
                                          }
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(
                                top: 00.0,
                                bottom: 00.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              child: Text(
                                StringConstant.selectTheTime,
                                style: TextStyle(
                                    color: blackColor,
                                    fontFamily: ConstantFont.montserratBold,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),

                            Visibility(
                              visible: timeVisible,
                              child: GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0,
                                      left: 15,
                                      right: 15,
                                      bottom: 10),
                                  color: whiteColor,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: timelist.length,
                                    itemBuilder: (context, index) {
                                      bool isSelected =
                                          currentSelectedIndex == index;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            emplist.clear();
                                            currentSelectedIndex = index;
                                            time = (timelist[index].startTime);
                                            print(selectedDay);
                                            var myFormat =
                                                DateFormat('yyyy-MM-dd');
                                            print(myFormat.format(selectedDay));
                                            date = myFormat.format(selectedDay);

                                            viewVisible1 = true;

                                            AppConstant.checkNetwork()
                                                .whenComplete(
                                                    () => callApiForEmpData());
                                          });

                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(1.0),
                                          child: TextButton(
                                            onPressed: null,
                                            style: TextButton.styleFrom(
                                              primary:whiteColor,
                                            ),
                                            child: Text(
                                              timelist[index].startTime!,
                                              style: TextStyle(
                                                  color: isSelected
                                                      ? whiteColor
                                                      : blackColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: ConstantFont.montserratMedium),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          decoration: isSelected
                                              ? BoxDecoration(
                                                  color:
                                                       blue4a,
                                                  border: Border.all(
                                                    color:
                                                        blue4a,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )
                                              : BoxDecoration(),
                                        ),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              4),
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                                visible: timenotVisible,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        StringConstant.salonOff,
                                        style: TextStyle(
                                            color: greyColor,
                                            fontSize: 16,
                                            fontFamily: ConstantFont.montserratMedium,
                                            fontWeight: FontWeight.w600),
                                      )),
                                )),

                            GestureDetector(
                              child: Visibility(
                                visible: viewVisible,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 150),
                                  color: whiteColor,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 00.0,
                                          left: 20.0,
                                          right: 0.0,
                                        ),
                                        child: Text(
                                          StringConstant.selectEmployee,
                                          style: TextStyle(
                                              color: blackColor,
                                              fontFamily: ConstantFont.montserratBold,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 0.0,
                                            left: 10,
                                            right: 10,
                                            bottom: 10),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: emplist.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var color =
                                                emplist[index].isSelected
                                                    ? pinkColor
                                                    : greyA5;

                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  emplist.forEach((element) =>
                                                      element.isSelected =
                                                          false);
                                                  emplist[index].isSelected =
                                                      true;
                                                  selectedempid =
                                                      emplist[index].empId;
                                                  print(
                                                      "EmpId123:$selectedempid");

                                                  viewVisible1 = true;
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  children: <Widget>[
                                                    new Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20, top: 5),
                                                      width: 20,
                                                      height: 20,
                                                      color: whiteColor,
                                                      child: Container(
                                                          width: 15,
                                                          height: 15,
                                                          child:
                                                              GestureDetector(
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: color,
                                                                border:
                                                                    Border.all(
                                                                  color: const Color(
                                                                      0xFFdddddd),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                child: emplist[
                                                                            index]
                                                                        .isSelected
                                                                    ? Icon(
                                                                        Icons
                                                                            .check,
                                                                        size:
                                                                            15.0,
                                                                        color: whiteColor,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .check_box_outline_blank_outlined,
                                                                        size:
                                                                            15.0,
                                                                        color:
                                                                            color,
                                                                      ),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    new Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, top: 5),
                                                      height: 35,
                                                      width: 35,
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CachedNetworkImage(
                                                        height: 35,
                                                        width: 35,
                                                        imageUrl: emplist[index]
                                                                .imagePath! +
                                                            emplist[index]
                                                                .image!,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.fill,
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            SpinKitFadingCircle(
                                                                color: pinkColor),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                                DummyImage.noImage),
                                                      ),
                                                    ),
                                                    new Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        height: 50,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .65,
                                                              height: 30,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 1,
                                                                      top: 2,
                                                                      right:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      emplist[index]
                                                                          .name!,
                                                                      style: TextStyle(
                                                                          color: blackColor,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                          ConstantFont.montserratSemiBold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .65,
                                                              height: 10,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 1,
                                                                      top: 8,
                                                                      right:
                                                                          10),
                                                              child:
                                                                  MySeparator(),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: viewVisible1,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 50),
                            color: whiteColor,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 1.0, right: 15, left: 15),
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            StringConstant.yourTotalPayment,
                                            style: TextStyle(
                                                color: greyColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: ConstantFont.montserratMedium),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 5,
                                          ),
                                          child: Text(
                                            totalprice.toString() + " ₹",
                                            style: TextStyle(
                                                color: blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: ConstantFont.montserratMedium),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    margin: EdgeInsets.only(right: 15),
                                    alignment: FractionalOffset.center,
                                    child: TextButton(
                                      onPressed: () {
                                        if (selectedempid == null) {
                                          ToastMessage.toastMessage(
                                              "Select Employee");
                                        } else {
                                          print("SelectedEmpId:$selectedempid");
                                          print("Selectedtime:$time");
                                          print("Selecteddate:$date");
                                          print(
                                              "Selectedtotalprice:$totalprice");
                                          print(
                                              "SelectedselecteServices:$selecteServices");
                                          print("SelectedsalonId:$salonId");
                                          print(
                                              "Selected_selecteServicesName:$_selecteServicesName");
                                          print(
                                              "Selected__totalprice:$_totalprice");
                                          print(
                                              "Selected_salonData:$salonData");
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (ctxt) => new ConfirmBooking(selectedempid, time, date, totalprice, selecteServices, salonId, _selecteServicesName, _totalprice, salonData!, false, true)));
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: blue21,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: Text(
                                        StringConstant.makePayment,
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: ConstantFont.montserratMedium,
                                            fontSize: 14),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),

                        CustomView(),

                        // child:
                      ],
                    ),
                  ),
                ], // new Container(child: Body(viewVisible))],
              )),
        ),
      ),
    );
  }
}
