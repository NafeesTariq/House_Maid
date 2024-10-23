import 'package:house_maid_project/AModels/RegisterationModel.dart';

class HMQuestionsMOdel {
  int? statusCode;
  bool? status;
  String? message;
  dynamic data;
  HMQuestionsMOdel({this.statusCode, this.status, this.message, this.data});

  HMQuestionsMOdel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    // data = json['data'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
