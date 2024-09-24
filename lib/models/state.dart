import 'senator.dart';

class NigState {
  String? state;
  List<Senator>? data;

  NigState({this.state, this.data});

  NigState.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    if (json['data'] != null) {
      data = <Senator>[];
      json['data'].forEach((v) {
        data!.add(Senator.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
