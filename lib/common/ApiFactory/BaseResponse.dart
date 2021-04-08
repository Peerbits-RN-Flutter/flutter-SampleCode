class BaseResponse {
  dynamic data;
  List? error;
  int? success;

  BaseResponse({this.data, this.error, this.success});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      data: json['data'] != null ? json['data'] : null,
      error: json['error'] != null
          ? (json['error'] as List).map((i) => i).toList()
          : null,
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }

    if (this.error != null) {
      data['error'] = this.error!.map((v) => v).toList();
    }
    return data;
  }
}
