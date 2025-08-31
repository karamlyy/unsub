class MeModel {
  final String id;
  final String username;

  MeModel({required this.id, required this.username});

  factory MeModel.fromJson(Map<String, dynamic> json) => MeModel(
    id: json["id"] ?? "",
    username: json["username"] ?? "",
  );
}


