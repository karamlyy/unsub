class RegisterModel {
  final String? id;
  final String? accessToken;
  final String? refreshToken;

  RegisterModel({this.id, this.accessToken, this.refreshToken});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    // API returns either {"id": "..."} OR {"accessToken": "...", "refreshToken": "..."}
    return RegisterModel(
      id: json["id"] as String?,
      accessToken: json["accessToken"] as String?,
      refreshToken: json["refreshToken"] as String?,
    );
  }
}


