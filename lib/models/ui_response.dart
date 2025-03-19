class UiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  const UiResponse({
    required this.success,
    this.message,
    this.data,
  });
}
