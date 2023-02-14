class StateResult {
  bool isLoading;
  bool? state;
  String? message;

  StateResult({this.isLoading = true, this.state, this.message});

  factory StateResult.fromJson(Map<String, dynamic> json) {
    if (json['state'] == false) {
      throw json['message'];
    }
    return StateResult(
        isLoading: false, state: json['state'], message: json['message']);
  }
}
