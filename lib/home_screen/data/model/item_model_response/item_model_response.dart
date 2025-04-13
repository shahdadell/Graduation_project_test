import 'Itemdatum.dart';

class ItemModelResponse {
  String? status;
  List<ItemDatum>? data;

  ItemModelResponse({this.status, this.data});

  factory ItemModelResponse.fromJson(Map<String, dynamic> json) {
    return ItemModelResponse(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ItemDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
