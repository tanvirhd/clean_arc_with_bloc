import 'package:clean_arc_bloc/core/model/basic_response.dart';

class PagingResponse<T> extends BasicResponse {
  List<T>? results;
  String? next;
  String? previous;
  int? count;

  PagingResponse({
    super.message,
    super.code,
    this.results,
    this.next,
    this.previous,
    this.count,
  });

  factory PagingResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson,) {
    List<T> parsedList = [];
    if (json['data']['results'] != null) {
      for (int i = 0; i < json['data']['results'].length; i++) {
        parsedList.add(fromJson(json['data']['results'][i]));
      }
    }

    return PagingResponse<T>(
      message: json['message'],
      code: json['code'],
      results: parsedList,
      count: json['data']['count'],
      next: json['data']['next'],
      previous: json['data']['previous'],
    );
  }
}
