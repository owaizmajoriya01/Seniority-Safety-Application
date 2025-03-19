class ApiResponse<T> {
  final T data;
  final bool success;
  final String? errorMessage;
  final int? statusCode;

  const ApiResponse(
      {required this.success,
      required this.data,
      this.errorMessage,
      this.statusCode});
}
