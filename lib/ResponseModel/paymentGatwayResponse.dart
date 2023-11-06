class PaymentGatwayResponse {
  String? msg;
  PaymentData? data;
  bool? success;

  PaymentGatwayResponse({this.msg, this.data, this.success});

  PaymentGatwayResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new PaymentData.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class PaymentData {
  int? cod;
  int? stripe;
  String? stripePublicKey;
  String? razorPublic;
  String? razorSecret;

  PaymentData(
      {this.cod,
        this.stripe,
        this.stripePublicKey,
        this.razorPublic,
        this.razorSecret});

  PaymentData.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    stripe = json['stripe'];
    stripePublicKey = json['stripe_public_key'];
    razorPublic = json['razor_public'];
    razorSecret = json['razor_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod'] = this.cod;
    data['stripe'] = this.stripe;
    data['stripe_public_key'] = this.stripePublicKey;
    data['razor_public'] = this.razorPublic;
    data['razor_secret'] = this.razorSecret;
    return data;
  }
}