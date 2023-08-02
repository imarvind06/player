class CustomException implements Exception {
  int type;
  String message;
  CustomException({required this.type, required this.message});
}
