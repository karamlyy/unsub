class SubscriptionsModel {
  List<Subscription>? data;

  SubscriptionsModel({
    this.data,
  });

  factory SubscriptionsModel.fromJson(Map<String, dynamic> json) => SubscriptionsModel(
    data: json["data"] == null ? [] : List<Subscription>.from(json["data"]!.map((x) => Subscription.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Subscription {
  String? id;
  dynamic customLabel;
  String? period;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic customLogo;
  int? price;
  DateTime? firstPaymentDate;
  DateTime? nextPaymentDate;
  Service? service;
  PaymentMethod? paymentMethod;
  Currency? currency;

  Subscription({
    this.id,
    this.customLabel,
    this.period,
    this.createdAt,
    this.updatedAt,
    this.customLogo,
    this.price,
    this.firstPaymentDate,
    this.nextPaymentDate,
    this.service,
    this.paymentMethod,
    this.currency,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json["id"],
    customLabel: json["customLabel"],
    period: json["period"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    customLogo: json["customLogo"],
    price: json["price"],
    firstPaymentDate: json["firstPaymentDate"] == null ? null : DateTime.parse(json["firstPaymentDate"]),
    nextPaymentDate: json["nextPaymentDate"] == null ? null : DateTime.parse(json["nextPaymentDate"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    paymentMethod: json["paymentMethod"] == null ? null : PaymentMethod.fromJson(json["paymentMethod"]),
    currency: json["currency"] == null ? null : Currency.fromJson(json["currency"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customLabel": customLabel,
    "period": period,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "customLogo": customLogo,
    "price": price,
    "firstPaymentDate": "${firstPaymentDate!.year.toString().padLeft(4, '0')}-${firstPaymentDate!.month.toString().padLeft(2, '0')}-${firstPaymentDate!.day.toString().padLeft(2, '0')}",
    "nextPaymentDate": "${nextPaymentDate!.year.toString().padLeft(4, '0')}-${nextPaymentDate!.month.toString().padLeft(2, '0')}-${nextPaymentDate!.day.toString().padLeft(2, '0')}",
    "service": service?.toJson(),
    "paymentMethod": paymentMethod?.toJson(),
    "currency": currency?.toJson(),
  };
}

class Currency {
  String? id;
  String? label;
  String? code;
  String? symbol;

  Currency({
    this.id,
    this.label,
    this.code,
    this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    label: json["label"],
    code: json["code"],
    symbol: json["symbol"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "code": code,
    "symbol": symbol,
  };
}

class PaymentMethod {
  String? id;
  String? label;
  String? value;
  bool? paymentMethodDefault;

  PaymentMethod({
    this.id,
    this.label,
    this.value,
    this.paymentMethodDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    label: json["label"],
    value: json["value"],
    paymentMethodDefault: json["default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "value": value,
    "default": paymentMethodDefault,
  };
}

class Service {
  String? id;
  String? label;
  String? logo;

  Service({
    this.id,
    this.label,
    this.logo,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    label: json["label"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "logo": logo,
  };
}