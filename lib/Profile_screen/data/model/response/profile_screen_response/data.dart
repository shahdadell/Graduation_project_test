class Data {
  String? usersId;
  String? usersName;
  String? usersPassword;
  String? usersEmail;
  String? usersPhone;
  String? usersVerfiycode;
  String? usersApprove;
  String? usersCreate;
  dynamic usersImage;

  Data({
    this.usersId,
    this.usersName,
    this.usersPassword,
    this.usersEmail,
    this.usersPhone,
    this.usersVerfiycode,
    this.usersApprove,
    this.usersCreate,
    this.usersImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        usersId: json['users_id'] as String?,
        usersName: json['users_name'] as String?,
        usersPassword: json['users_password'] as String?,
        usersEmail: json['users_email'] as String?,
        usersPhone: json['users_phone'] as String?,
        usersVerfiycode: json['users_verfiycode'] as String?,
        usersApprove: json['users_approve'] as String?,
        usersCreate: json['users_create'] as String?,
        usersImage: json['users_image'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'users_id': usersId,
        'users_name': usersName,
        'users_password': usersPassword,
        'users_email': usersEmail,
        'users_phone': usersPhone,
        'users_verfiycode': usersVerfiycode,
        'users_approve': usersApprove,
        'users_create': usersCreate,
        'users_image': usersImage,
      };
}
