// To parse this JSON data, do
//
//     final createCheckoutModel = createCheckoutModelFromJson(jsonString);

import 'dart:convert';

CreateCheckoutModel createCheckoutModelFromJson(String str) =>
    CreateCheckoutModel.fromJson(json.decode(str));

String createCheckoutModelToJson(CreateCheckoutModel data) =>
    json.encode(data.toJson());

class CreateCheckoutModel {
  CreateCheckoutModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory CreateCheckoutModel.fromJson(Map<String, dynamic> json) =>
      CreateCheckoutModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.object,
    this.afterExpiration,
    this.allowPromotionCodes,
    this.amountSubtotal,
    this.amountTotal,
    this.automaticTax,
    this.billingAddressCollection,
    this.cancelUrl,
    this.clientReferenceId,
    this.consent,
    this.consentCollection,
    this.created,
    this.currency,
    this.customText,
    this.customer,
    this.customerCreation,
    this.customerDetails,
    this.customerEmail,
    this.expiresAt,
    this.invoice,
    this.invoiceCreation,
    this.livemode,
    this.locale,
    this.metadata,
    this.mode,
    this.paymentIntent,
    this.paymentLink,
    this.paymentMethodCollection,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
    this.paymentStatus,
    this.phoneNumberCollection,
    this.recoveredFrom,
    this.setupIntent,
    this.shippingAddressCollection,
    this.shippingCost,
    this.shippingDetails,
    this.shippingOptions,
    this.status,
    this.submitType,
    this.subscription,
    this.successUrl,
    this.totalDetails,
    this.url,
  });

  String? id;
  String? object;
  String? afterExpiration;
  String? allowPromotionCodes;
  int? amountSubtotal;
  int? amountTotal;
  AutomaticTax? automaticTax;
  String? billingAddressCollection;
  String? cancelUrl;
  String? clientReferenceId;
  String? consent;
  String? consentCollection;
  int? created;
  String? currency;
  CustomText? customText;
  String? customer;
  String? customerCreation;
  String? customerDetails;
  String? customerEmail;
  int? expiresAt;
  String? invoice;
  String? invoiceCreation;
  bool? livemode;
  String? locale;
  Metadata? metadata;
  String? mode;
  String? paymentIntent;
  String? paymentLink;
  String? paymentMethodCollection;
  String? paymentMethodOptions;
  List<String>? paymentMethodTypes;
  String? paymentStatus;
  PhoneNumberCollection? phoneNumberCollection;
  String? recoveredFrom;
  String? setupIntent;
  String? shippingAddressCollection;
  String? shippingCost;
  String? shippingDetails;
  List<dynamic>? shippingOptions;
  String? status;
  String? submitType;
  String? subscription;
  String? successUrl;
  TotalDetails? totalDetails;
  String? url;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        object: json["object"],
        afterExpiration: json["after_expiration"],
        allowPromotionCodes: json["allow_promotion_codes"],
        amountSubtotal: json["amount_subtotal"],
        amountTotal: json["amount_total"],
        automaticTax: json["automatic_tax"] == null
            ? null
            : AutomaticTax.fromJson(json["automatic_tax"]),
        billingAddressCollection: json["billing_address_collection"],
        cancelUrl: json["cancel_url"],
        clientReferenceId: json["client_reference_id"],
        consent: json["consent"],
        consentCollection: json["consent_collection"],
        created: json["created"],
        currency: json["currency"],
        customText: json["custom_text"] == null
            ? null
            : CustomText.fromJson(json["custom_text"]),
        customer: json["customer"],
        customerCreation: json["customer_creation"],
        customerDetails: json["customer_details"],
        customerEmail: json["customer_email"],
        expiresAt: json["expires_at"],
        invoice: json["invoice"],
        invoiceCreation: json["invoice_creation"],
        livemode: json["livemode"],
        locale: json["locale"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        mode: json["mode"],
        paymentIntent: json["payment_intent"],
        paymentLink: json["payment_link"],
        paymentMethodCollection: json["payment_method_collection"],
        paymentMethodOptions: json["payment_method_options"],
        paymentMethodTypes: json["payment_method_types"] == null
            ? null
            : List<String>.from(json["payment_method_types"].map((x) => x)),
        paymentStatus: json["payment_status"],
        phoneNumberCollection: json["phone_number_collection"] == null
            ? null
            : PhoneNumberCollection.fromJson(json["phone_number_collection"]),
        recoveredFrom: json["recovered_from"],
        setupIntent: json["setup_intent"],
        shippingAddressCollection: json["shipping_address_collection"],
        shippingCost: json["shipping_cost"],
        shippingDetails: json["shipping_details"],
        shippingOptions: json["shipping_options"] == null
            ? null
            : List<dynamic>.from(json["shipping_options"].map((x) => x)),
        status: json["status"],
        submitType: json["submit_type"],
        subscription: json["subscription"],
        successUrl: json["success_url"],
        totalDetails: json["total_details"] == null
            ? null
            : TotalDetails.fromJson(json["total_details"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "after_expiration": afterExpiration,
        "allow_promotion_codes": allowPromotionCodes,
        "amount_subtotal": amountSubtotal,
        "amount_total": amountTotal,
        "automatic_tax": automaticTax == null ? null : automaticTax!.toJson(),
        "billing_address_collection": billingAddressCollection,
        "cancel_url": cancelUrl,
        "client_reference_id": clientReferenceId,
        "consent": consent,
        "consent_collection": consentCollection,
        "created": created,
        "currency": currency,
        "custom_text": customText == null ? null : customText!.toJson(),
        "customer": customer,
        "customer_creation": customerCreation,
        "customer_details": customerDetails,
        "customer_email": customerEmail,
        "expires_at": expiresAt,
        "invoice": invoice,
        "invoice_creation": invoiceCreation,
        "livemode": livemode,
        "locale": locale,
        "metadata": metadata == null ? null : metadata!.toJson(),
        "mode": mode,
        "payment_intent": paymentIntent,
        "payment_link": paymentLink,
        "payment_method_collection": paymentMethodCollection,
        "payment_method_options": paymentMethodOptions,
        "payment_method_types": paymentMethodTypes == null
            ? null
            : List<dynamic>.from(paymentMethodTypes!.map((x) => x)),
        "payment_status": paymentStatus,
        "phone_number_collection": phoneNumberCollection == null
            ? null
            : phoneNumberCollection!.toJson(),
        "recovered_from": recoveredFrom,
        "setup_intent": setupIntent,
        "shipping_address_collection": shippingAddressCollection,
        "shipping_cost": shippingCost,
        "shipping_details": shippingDetails,
        "shipping_options": shippingOptions == null
            ? null
            : List<dynamic>.from(shippingOptions!.map((x) => x)),
        "status": status,
        "submit_type": submitType,
        "subscription": subscription,
        "success_url": successUrl,
        "total_details": totalDetails == null ? null : totalDetails!.toJson(),
        "url": url,
      };
}

class AutomaticTax {
  AutomaticTax({
    this.enabled,
    this.status,
  });

  bool? enabled;
  dynamic? status;

  factory AutomaticTax.fromJson(Map<String, dynamic> json) => AutomaticTax(
        enabled: json["enabled"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "status": status,
      };
}

class CustomText {
  CustomText({
    this.shippingAddress,
    this.submit,
  });

  dynamic shippingAddress;
  dynamic submit;

  factory CustomText.fromJson(Map<String, dynamic> json) => CustomText(
        shippingAddress: json["shipping_address"],
        submit: json["submit"],
      );

  Map<String, dynamic> toJson() => {
        "shipping_address": shippingAddress,
        "submit": submit,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class PhoneNumberCollection {
  PhoneNumberCollection({
    this.enabled,
  });

  bool? enabled;

  factory PhoneNumberCollection.fromJson(Map<String, dynamic> json) =>
      PhoneNumberCollection(
        enabled: json["enabled"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
      };
}

class TotalDetails {
  TotalDetails({
    this.amountDiscount,
    this.amountShipping,
    this.amountTax,
  });

  int? amountDiscount;
  int? amountShipping;
  int? amountTax;

  factory TotalDetails.fromJson(Map<String, dynamic> json) => TotalDetails(
        amountDiscount: json["amount_discount"],
        amountShipping: json["amount_shipping"],
        amountTax: json["amount_tax"],
      );

  Map<String, dynamic> toJson() => {
        "amount_discount": amountDiscount,
        "amount_shipping": amountShipping,
        "amount_tax": amountTax,
      };
}
