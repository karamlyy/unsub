class CancelHelpModel {
  const CancelHelpModel({required this.instructions});

  final String instructions;

  factory CancelHelpModel.fromJson(Map<String, dynamic> json) {
    return CancelHelpModel(
      instructions: json['instructions'] as String,
    );
  }
}