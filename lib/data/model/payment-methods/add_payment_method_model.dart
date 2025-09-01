class AddPaymentMethodModel {
  Data? data;

  AddPaymentMethodModel({
    this.data,
  });

  factory AddPaymentMethodModel.fromJson(Map<String, dynamic> json) => AddPaymentMethodModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  String? id;

  Data({
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
