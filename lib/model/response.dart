class RResponse {
  final int code;
  final String message;
  final Map<String, dynamic> data;

  RResponse({required this.code, required this.message, required this.data});
}
