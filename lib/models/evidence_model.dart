class EvidenceModel {
  final String id;

  final String emergencyId;

  final String audioPath;

  final String startTime;

  final double latitude;

  final double longitude;

  EvidenceModel({
    required this.id,
    required this.emergencyId,
    required this.audioPath,
    required this.startTime,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "emergencyId": emergencyId,
      "audioPath": audioPath,
      "startTime": startTime,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  factory EvidenceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EvidenceModel(
      id: json["id"] ?? "",

      emergencyId: json["emergencyId"] ?? "",

      audioPath: json["audioPath"] ?? "",

      startTime: json["startTime"] ?? "",

      latitude: (json["latitude"] ?? 0).toDouble(),

      longitude: (json["longitude"] ?? 0).toDouble(),
    );
  }
}