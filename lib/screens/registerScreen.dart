import 'package:barber_app/ResponseModel/registerResponse.dart';
import 'package:barber_app/constant/color_constant.dart';
import 'package:barber_app/constant/constant_font.dart';
import 'package:barber_app/constant/string_constant.dart';
import 'package:barber_app/constant/toast_message.dart';
import 'package:barber_app/network/Apiservice.dart';
import 'package:barber_app/network/BaseModel.dart';
import 'package:barber_app/network/Retro_Api.dart';
import 'package:barber_app/network/ServerError.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:barber_app/constant/appconstant.dart';
import 'package:barber_app/constant/preferenceutils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'loginscreen.dart';
import 'otpscreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreen createState() => new _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  String? _selectedCountryCode = ' +91';
  List<String> _countryCodes = [' +91', ' +23', ' +8'];
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  String? _username, _email, _password, _phoneno = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText=true;
  @override
  Widget build(BuildContext context) {
    var countryDropDown = Container(
      margin: EdgeInsets.only(right: 10),
      decoration: new BoxDecoration(
        border: Border(
          right: BorderSide(width: 0.5, color: greyColor),
        ),
      ),
      height: 45.0,
      //width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _selectedCountryCode,
            items: _countryCodes.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(
                    value,
                    style: TextStyle(fontSize: 16.0, fontFamily: ConstantFont.montserratMedium),
                  ));
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                _selectedCountryCode = value;
              });
            },
          ),
        ),
      ),
    );
    return ModalProgressHUD(
      inAsyncCall: _loading,
      opacity: 1.0,
      color: Colors.transparent.withOpacity(0.2),
      progressIndicator:
          SpinKitFadingCircle(color: pinkColor),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: whiteColor,
            body: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: whiteColor,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: blackColor,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  StringConstant.createNewAccount,
                  style: TextStyle(
                      color: blackColor,
                      fontFamily: ConstantFont.montserratBold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
                backgroundColor: whiteColor,
                elevation: 0.0,
              ),
              body: Form(
                key: _formKey,
                child: new Stack(
                  children: <Widget>[
                    new SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 50.0, left: 35.0),
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    StringConstant.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:  grey99,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantFont.montserratMedium),
                                  ),
                                ),
                              ),
                              Container(
                                height: 45,
                                alignment: FractionalOffset.topLeft,
                                margin: const EdgeInsets.only(
                                    top: 5.0,
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 15),
                                child: TextFormField(
                                  autofocus: true,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  validator: (name) {
                                    Pattern pattern =
                                        r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                                    RegExp regex =
                                        new RegExp(pattern as String);
                                    if (!regex.hasMatch(name!))
                                      return 'Invalid username';
                                    else
                                      return null;
                                  },
                                  onSaved: (name) => _username = name,
                                  onFieldSubmitted: (_) {
                                    fieldFocusChange(context,
                                        _usernameFocusNode, _emailFocusNode);
                                  },
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: ConstantFont.montserratMedium),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: whiteF1,
                                    hintText: 'Enter your full name',
                                    hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantFont.montserratMedium
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  whiteF1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  whiteF1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5.0, left: 35.0),
                                alignment: FractionalOffset.topLeft,
                                child: Text(
                                  StringConstant.emailId,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:  grey99,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: ConstantFont.montserratMedium),
                                ),
                              ),
                              Container(
                                height: 45,
                                alignment: FractionalOffset.topLeft,
                                margin: const EdgeInsets.only(
                                    top: 5.0,
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 15),
                                child: TextFormField(
                                  autofocus: true,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _emailFocusNode,
                                  validator: (email) =>
                                      EmailValidator.validate(email!)
                                          ? null
                                          : "Invalid email address",
                                  onSaved: (email) => _email = email,
                                  onFieldSubmitted: (_) {
                                    fieldFocusChange(context, _emailFocusNode,
                                        _phoneFocusNode);
                                  },
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: ConstantFont.montserratMedium),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  whiteF1,
                                    hintText: 'Enter your email id',
                                    hintStyle: TextStyle(fontSize: 16.0,
                                        color: blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantFont.montserratMedium),
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: whiteF1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: whiteF1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5.0, left: 35.0),
                                alignment: FractionalOffset.centerLeft,
                                child: Text(
                                  StringConstant.phoneNumber,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: grey99,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily:ConstantFont.montserratMedium),
                                ),
                              ),
                              Container(
                                  alignment: FractionalOffset.centerLeft,
                                  height: 45,
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 20.0,
                                      right: 20.0,
                                      bottom: 15),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      focusNode: _phoneFocusNode,
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      validator: (phone) {
                                        Pattern pattern =
                                            r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                        RegExp regex =
                                            new RegExp(pattern as String);
                                        if (!regex.hasMatch(phone!))
                                          return 'Invalid Phone number';
                                        else
                                          return null;
                                      },
                                      onSaved: (phone) => _phoneno = phone,
                                      onFieldSubmitted: (_) {
                                        fieldFocusChange(
                                            context,
                                            _phoneFocusNode,
                                            _passwordFocusNode);
                                      },
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: ConstantFont.montserratMedium),
                                      decoration: InputDecoration(
                                        prefixIcon: countryDropDown,
                                        filled: true,
                                        fillColor: whiteF1,
                                        hintText: '  Phone Number ',
                                        hintStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: ConstantFont.montserratMedium
                                        ),
                                        contentPadding: EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: whiteF1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: whiteF1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  )),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5.0, left: 35.0),
                                alignment: FractionalOffset.centerLeft,
                                child: Text(
                                  StringConstant.password,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: grey99,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: ConstantFont.montserratMedium),
                                ),
                              ),
                              Container(
                                alignment: FractionalOffset.centerLeft,
                                height: 45,
                                margin: const EdgeInsets.only(
                                    top: 5.0,
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 15),
                                child: TextFormField(
                                  obscureText: _obscureText,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _passwordFocusNode,
                                  validator: (password) {
                                    Pattern pattern =
                                        r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                                    RegExp regex =
                                        new RegExp(pattern as String);
                                    if (!regex.hasMatch(password!))
                                      return 'Invalid password';
                                    else
                                      return null;
                                  },
                                  onSaved: (password) => _password = password,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily:ConstantFont.montserratMedium),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:  whiteF1,
                                    hintText: 'Enter your Password',
                                    hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: ConstantFont.montserratMedium
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  whiteF1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  whiteF1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon:GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child:
                                      new Icon(_obscureText ? Icons.visibility : Icons.visibility_off,color: blackColor,size: 18,),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: MaterialButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0)),
                                  height: 45,
                                  color: pinkColor,
                                  onPressed: () async {

                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());
                                      if (connectivityResult ==
                                          ConnectivityResult.mobile) {

                                        callRegisterApi(_username, _email, _phoneno, _password, 0, _selectedCountryCode);
                                      } else if (connectivityResult ==
                                          ConnectivityResult.wifi) {

                                        callRegisterApi(_username, _email, _phoneno, _password, 0, _selectedCountryCode);
                                      } else {
                                        ToastMessage.toastMessage("No Internet Connection");
                                      }
                                    }
                                  },
                                  child: Text(
                                    StringConstant.createNewAccount,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: ConstantFont.montserratMedium,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        alignment:
                                            FractionalOffset.bottomCenter,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(2)),
                                            );
                                          },
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Text(
                                                StringConstant.alreadyHaveAnAccount,
                                                style: TextStyle(
                                                    color: blackColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: ConstantFont.montserratMedium),
                                              ),
                                              new Text(
                                                StringConstant.loginDot,
                                                style: TextStyle(
                                                    color: pinkColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: ConstantFont.montserratBold),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              new Container(
                                child: SizedBox(
                                  height: 100,
                                ),
                              ),
                              new Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  StringConstant.byClickingCreateNewAccountYouAgreeToTheFollowingTermsCondition,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: ConstantFont.montserratMedium),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    setState(() {
      PreferenceUtils.init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<BaseModel<RegisterResponse>> callRegisterApi(String? username, String? email, String? phoneno, String? password, int verify, String? selectedCountryCode) async
  {
    RegisterResponse response;
    Map<String,String> body={
      "name":username!,
      "email":email!,
      "phone":phoneno!,
      "password":password!,
      "code":selectedCountryCode!,
    };
    try{
        response=await RestClient(RetroApi().dioData()).register(body);
        if(response.success==true)
          {
            print("sucess");
                    ToastMessage.toastMessage(response.message!);

                    PreferenceUtils.setString(
                        AppConstant.userid, response.data!.id.toString());
                    PreferenceUtils.setString(AppConstant.username, response.data!.name!);
                    PreferenceUtils.setString(
                        AppConstant.useremail, response.data!.email!);
                    PreferenceUtils.setString(
                        AppConstant.userotp, response.data!.otp.toString());
                    PreferenceUtils.setString(
                        AppConstant.userphone, response.data!.phone!);
                    PreferenceUtils.setString(
                        AppConstant.userphonecode, response.data!.code!);
                    PreferenceUtils.setString(
                        AppConstant.imagePath, response.data!.imagePath!);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtpScreen()));
          }
        else
          {
            ToastMessage.toastMessage(response.messageRegisterResponse!);
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
}
