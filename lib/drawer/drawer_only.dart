import 'package:barber_app/constant/appconstant.dart';
import 'package:barber_app/constant/color_constant.dart';
import 'package:barber_app/constant/dymmyimages.dart';
import 'package:barber_app/constant/preferenceutils.dart';
import 'package:barber_app/constant/string_constant.dart';
import 'package:barber_app/constant/transaction.dart';
import 'package:barber_app/drawerscreen/about.dart';
import 'package:barber_app/drawerscreen/privacypolicy.dart';
import 'package:barber_app/drawerscreen/tems_condition.dart';
import 'package:barber_app/drawerscreen/top_offers.dart';
import 'package:barber_app/screens/loginscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class DrawerOnly extends StatelessWidget {


  late String? name="User";




  @override
  Widget build (BuildContext context) {
    PreferenceUtils.init();
    print("drawername:$name");

    if(PreferenceUtils.getlogin(AppConstant.isLoggedIn) == true){
      name = PreferenceUtils.getString(AppConstant.username);
    }else{
      name = "User";
    }
    return new Drawer
      (

        child: ListView(


          children: <Widget>[

            Container(
              padding: EdgeInsets.only(left: 10.0, top: 10.0,bottom: 10),
              alignment: Alignment.center,
              height: 80,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        height:60,
                        width: 60,
                        imageUrl: PreferenceUtils.getString(AppConstant.fullImage),
                        imageBuilder: (context, imageProvider) =>ClipOval(child: Image(image: imageProvider, fit: BoxFit.fill,),
                        ),
                        placeholder: (context,
                            url) =>
                            SpinKitFadingCircle(
                                color: pinkColor,size: 5,),
                        errorWidget: (context,
                            url, error) =>
                            Image.asset(DummyImage.noImage),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Hii, '+ name!,
                          style: TextStyle(
                              color: blackColor,

                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(

                height: 0,
                padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),

              child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 5.0,
                  dashColor: blackColor,
                  dashRadius: 0.0,
                  dashGapLength: 8.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                )
            ),
            Container(

                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: ListTile(
                  title: Text(
                    StringConstant.topOffers,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat'),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => new TopOffers(-1,null,null,null,null,null,null,null,null,null)));
                  },

                )




            ),

            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20.0, top: 0.0),

                child: ListTile(
                    title: Text(
                      StringConstant.termsAndConditions,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat'),
                    ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => new TermsCondition()));
                  },
                )
            ),

            Container(                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20.0, top: 0.0),

                child: ListTile(
                    title: Text(
                      StringConstant.privacyAndPolicy,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat'),),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => new PrivacyPolicy()));
                      },

                )
            ),

            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20.0, top: 0.0),

                child: ListTile(
                    title: Text(
                      StringConstant.inviteAFriends,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat'),
                    ),

                  onTap: () {
                      Navigator.pop(context);
                      share();

                  },
                )
            ),

            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20.0, top: 0.0),

                child: ListTile(
                    title: Text(
                      StringConstant.about,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat'),
                    ),

                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => new About()));
                  },

                )
            ),

           Visibility (
             visible: PreferenceUtils.getlogin(AppConstant.isLoggedIn) == true,
              child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.0, top: 0.0),

                  child: ListTile(
                    title: Text(
                      StringConstant.logout,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat'),
                    ),

                    onTap: ()  async {
                      showAlertDialog(context);
                    },

                  )
              ),
            ),

          ],
        )
    );
  }
  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(StringConstant.cancel,
        style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text(StringConstant.logout,style: TextStyle(color: Colors.black),),
      onPressed: () {
        PreferenceUtils.clear();
        PreferenceUtils.setlogin(AppConstant.isLoggedIn, false);
        Navigator.of(context).pushAndRemoveUntil(Transitions(
            transitionType: TransitionType.slideUp,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: LoginScreen(0)), (route) => false);
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(StringConstant.areYouWantToSureLogoutYourAccount),
      actions: [
        cancelButton,
        okButton
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<void> share() async {
    await FlutterShare.share(
        text: PreferenceUtils.getString(AppConstant.sharedName)+ "\n"+PreferenceUtils.getString(AppConstant.sharedImage)+"\n"+PreferenceUtils.getString(AppConstant.sharedUrl),
      title: PreferenceUtils.getString(AppConstant.sharedName),
      chooserTitle: PreferenceUtils.getString(AppConstant.sharedName),
    );
  }
}