class ServicesModel {
  List<ServiceModel>? data;

  ServicesModel({
    this.data,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
    data: json["data"] == null ? [] : List<ServiceModel>.from(json["data"]!.map((x) => ServiceModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ServiceModel {
  String? categoryId;
  String? categoryLabel;
  List<Service>? services;

  ServiceModel({
    this.categoryId,
    this.categoryLabel,
    this.services,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    categoryId: json["categoryId"],
    categoryLabel: json["categoryLabel"],
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryLabel": categoryLabel,
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
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
