class LoginResponse {
  String? status;
  String? message;
  int? userId; // غيرنا من String? لـ int?
  String? token;

  LoginResponse({this.status, this.message, this.userId, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json['status'] as String?,
        message: json['message'] as String?,
        userId: json['user_id'] != null
            ? int.tryParse(json['user_id'].toString())
            : null, // حول الـ user_id لـ int
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'user_id': userId?.toString(), // حول الـ int لـ String لما نحول لـ JSON
        'token': token,
      };
}
