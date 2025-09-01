class TypesModel {
  List<String>? data;

  TypesModel({
    this.data,
  });

  factory TypesModel.fromJson(Map<String, dynamic> json) => TypesModel(
    data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}