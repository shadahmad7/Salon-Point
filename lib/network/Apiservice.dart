import 'package:barber_app/ResponseModel/appointmentResponse.dart';
import 'package:barber_app/ResponseModel/bannerResponse.dart';
import 'package:barber_app/ResponseModel/bookingResponse.dart';
import 'package:barber_app/ResponseModel/cancelAppointResponse.dart';
import 'package:barber_app/ResponseModel/categorydataResponse.dart';
import 'package:barber_app/ResponseModel/catviseSalonResponse.dart';
import 'package:barber_app/ResponseModel/changepasswordResponse.dart';
import 'package:barber_app/ResponseModel/checkCouponResponse.dart';
import 'package:barber_app/ResponseModel/editprofileresponse.dart';
import 'package:barber_app/ResponseModel/empResponse.dart';
import 'package:barber_app/ResponseModel/forgotpasswodResponse.dart';
import 'package:barber_app/ResponseModel/notificationResponse.dart';
import 'package:barber_app/ResponseModel/offerResponse.dart';
import 'package:barber_app/ResponseModel/offerbannerResppose.dart';
import 'package:barber_app/ResponseModel/otpmatchResponse.dart';
import 'package:barber_app/ResponseModel/paymentGatwayResponse.dart';
import 'package:barber_app/ResponseModel/registerResponse.dart';
import 'package:barber_app/ResponseModel/removeAddressResponse.dart';
import 'package:barber_app/ResponseModel/salonDetailResponse.dart';
import 'package:barber_app/ResponseModel/salonResponse.dart';
import 'package:barber_app/ResponseModel/settingResponse.dart';
import 'package:barber_app/ResponseModel/shared_setting_response.dart';
import 'package:barber_app/ResponseModel/showprofileResponse.dart';
import 'package:barber_app/ResponseModel/timedataResponseModel.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import 'ApiServiceconstant.dart';
part 'Apiservice.g.dart';

@RestApi(baseUrl: ApiServiceConstant.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST(ApiServiceConstant.login)
  @FormUrlEncoded()
  // Future<String?> login(
  //   @Field() String? email,
  //   @Field() String? password,
  //   @Field() String device_token,
  // );
  Future<String> login(@Body() Map<String,String> map);
  @POST(ApiServiceConstant.register)
  @FormUrlEncoded()
  // Future<RegisterResponse> register(@Field() String? name, @Field() String? email, @Field() String? phone, @Field() String? password, @Field() int verify, @Field() String? code,);
  Future<RegisterResponse> register(@Body() Map<String,String> map);

  @POST(ApiServiceConstant.checkOtp)
  @FormUrlEncoded()
  Future<OtpMatchResponse> checkotp(
      @Body() Map<String,String> map
    // @Field() String otp,
    // @Field() String user_id,
  );

  @POST(ApiServiceConstant.sendOtp)
  @FormUrlEncoded()
  Future<OtpMatchResponse> sendotp(
    @Field() String email,
  );

  @GET(ApiServiceConstant.banners)
  Future<BannerResponse> banners();

  @GET(ApiServiceConstant.coupon)
  Future<OfferResponse> coupon();

  @GET(ApiServiceConstant.offers)
  Future<OfferBannerResponse> offersbanner();

  @GET(ApiServiceConstant.categories)
  Future<CategoryDataResponse> categories();

  @GET(ApiServiceConstant.salons)
  Future<SalonResponse> salons();

  @GET(ApiServiceConstant.salon)
  Future<SalonDetailResponse> salondetail();

  @GET(ApiServiceConstant.catSalonId)
  Future<CategoryWiseSalonResponse> catsalon(
    @Path() int id,
  );

  @GET(ApiServiceConstant.profile)
  Future<ShowProfileResponse> profile();

  @GET(ApiServiceConstant.profileAddressRemoveId)
  Future<RemoveAddressResponse> removeadd(
    @Path() int? id,
  );

  @POST(ApiServiceConstant.profileEdit)
  @FormUrlEncoded()
  Future<EditProfileResponse> editprofile(
    @Field() String image,
    @Field() String? email,
    @Field() String? phone,
    @Field() String? name,
    @Field() String? code,
  );

  @POST(ApiServiceConstant.booking)
  @FormUrlEncoded()
  Future<BookingResponse> booking(
      @Body() Map<String,String> map
    // @Field() String emp_id,
    // @Field() String service_id,
    // @Field() String payment,
    // @Field() String date,
    // @Field() String start_time,
    // @Field() String payment_type,
    // @Field() String payment_token,
  );

  // @POST(ApiServiceConstant.booking)
  // @FormUrlEncoded()
  // Future<String?> booking1(
  //   @Field() String salon_id,
  //   @Field() String emp_id,
  //   @Field("service_id") List<int> service_id,
  //   @Field() String payment,
  //   @Field() String date,
  //   @Field() String start_time,
  //   @Field() String payment_type,
  //   @Field() String payment_token,
  // );

  @POST(ApiServiceConstant.selectEmp)
  @FormUrlEncoded()
  Future<EmpResponse> selectemp(
      @Body() Map<String,String> map
    // @Field() String? start_time,
    // @Field() String service,
    // @Field() String? date,
  );

  @POST(ApiServiceConstant.timeslot)
  @FormUrlEncoded()
  Future<TimeDataResponseModel> timeslot(
      @Body() Map<String,String> map
    // @Field() int? salon_id,
    // @Field() String? date,
  );

  // @POST(ApiServiceConstant.selectEmp)
  // @FormUrlEncoded()
  // Future<String?> selectemp1(
  //   @Field() String start_time,
  //   @Field("service") List<int> service,
  //   @Field() String salon_id,
  //   @Field() String date,
  // );

  @GET(ApiServiceConstant.appointment)
  Future<AppointmentResponse> appointment();

  @GET(ApiServiceConstant.appointmentCancelId)
  Future<CancelAppointResponse> removeappointment(
    @Path() int id,
  );

  @GET(ApiServiceConstant.settings)
  Future<SettingResponse> settings();

  @GET(ApiServiceConstant.notification)
  Future<NotificationResponse> notification();

  @POST(ApiServiceConstant.forgetPassword)
  @FormUrlEncoded()
  Future<ForgotPasswordResponse> forgetpassword(
    @Field() String? email,
  );

  @POST(ApiServiceConstant.checkCoupon)
  @FormUrlEncoded()
  Future<CheckCouponResponse> checkcoupon(
    @Field() String? code,
  );

  @GET(ApiServiceConstant.paymentGateway)
  Future<PaymentGatwayResponse> paymentgateway();

  @POST(ApiServiceConstant.addReview)
  @FormUrlEncoded()
  Future<CheckCouponResponse> addreview(
      @Body() Map<String,String> map
    // @Field() String? message,
    // @Field() String rate,
    // @Field() String booking_id,
  );

  // @GET(ApiServiceConstant.salonId)
  // Future<String?> salondetail1(
  //   @Path() int id,
  // );

  @GET(ApiServiceConstant.deleteReviewId)
  Future<String?> deletereview(
    @Path() int id,
  );

  @POST(ApiServiceConstant.changePassword)
  @FormUrlEncoded()
  Future<ChangePasswordResponse> changepassword(
      @Body() Map<String,String> map
    // @Field() String? oldPassword,
    // @Field() String? new_Password,
    // @Field() String? confirm,
  );

  @GET(ApiServiceConstant.sharedSettings)
  Future<SharedSettingResponse> getSharedSetting();
}
