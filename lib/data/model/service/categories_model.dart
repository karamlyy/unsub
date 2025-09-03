class CategoriesModel {
  List<Category>? data;

  CategoriesModel({
    this.data,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    data: json["data"] == null ? [] : List<Category>.from(json["data"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Category {
  String? id;
  String? label;

  Category({
    this.id,
    this.label,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
  };
}