class BasicResponse {
  String? code;
  String? message;

  BasicResponse({this.code, this.message});

  factory BasicResponse.fromJson(Map<String, dynamic> json) {
    return BasicResponse(
        code: json["code"] as String?,
        message: json["message"] as String?
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    return map;
  }

  @override
  String toString() {
    return "code = $code message = $message";
  }
}
