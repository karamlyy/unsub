class PaymentMethodsModel {
  List<PaymentMethod>? data;

  PaymentMethodsModel({
    this.data,
  });

  factory PaymentMethodsModel.fromJson(Map<String, dynamic> json) => PaymentMethodsModel(
    data: json["data"] == null ? [] : List<PaymentMethod>.from(json["data"]!.map((x) => PaymentMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PaymentMethod {
  String? id;
  String? userId;
  String? type;
  String? cardBrandId;
  String? label;
  String? value;
  dynamic datumDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaymentMethod({
    this.id,
    this.userId,
    this.type,
    this.cardBrandId,
    this.label,
    this.value,
    this.datumDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    userId: json["userId"],
    type: json["type"],
    cardBrandId: json["cardBrandId"],
    label: json["label"],
    value: json["value"],
    datumDefault: json["default"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "type": type,
    "cardBrandId": cardBrandId,
    "label": label,
    "value": value,
    "default": datumDefault,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
