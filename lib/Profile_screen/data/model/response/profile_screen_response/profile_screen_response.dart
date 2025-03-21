import 'data.dart';

class ProfileScreenResponse {
  String? status;
  Data? data;

  ProfileScreenResponse({this.status, this.data});

  factory ProfileScreenResponse.fromJson(Map<String, dynamic> json) {
    return ProfileScreenResponse(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };
}
