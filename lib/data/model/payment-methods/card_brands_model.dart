class CardBrandsModel {
  List<CardBrandModel>? data;

  CardBrandsModel({
    this.data,
  });

  factory CardBrandsModel.fromJson(Map<String, dynamic> json) => CardBrandsModel(
    data: json["data"] == null ? [] : List<CardBrandModel>.from(json["data"]!.map((x) => CardBrandModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CardBrandModel {
  String? id;
  String? label;
  String? type;
  String? logo;

  CardBrandModel({
    this.id,
    this.label,
    this.type,
    this.logo,
  });

  factory CardBrandModel.fromJson(Map<String, dynamic> json) => CardBrandModel(
    id: json["id"],
    label: json["label"],
    type: json["type"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "type": type,
    "logo": logo,
  };
}