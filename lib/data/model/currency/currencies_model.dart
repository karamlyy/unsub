class CurrenciesModel {
  List<Currency>? data;

  CurrenciesModel({
    this.data,
  });

  factory CurrenciesModel.fromJson(Map<String, dynamic> json) => CurrenciesModel(
    data: json["data"] == null ? [] : List<Currency>.from(json["data"]!.map((x) => Currency.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Currency {
  String? id;
  String? code;
  String? symbol;
  String? label;

  Currency({
    this.id,
    this.code,
    this.symbol,
    this.label,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    code: json["code"],
    symbol: json["symbol"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "symbol": symbol,
    "label": label,
  };
}