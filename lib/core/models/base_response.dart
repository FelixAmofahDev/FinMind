class BaseResponse<T> {
  const BaseResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final T? data;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Object? json)? fromJsonT,
  }) {
    final dynamic rawData = json['data'];
    return BaseResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: fromJsonT != null ? fromJsonT(rawData) : rawData as T?,
    );
  }

  Map<String, dynamic> toJson({Object? Function(T value)? toJsonT}) {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data == null
          ? null
          : toJsonT != null
              ? toJsonT(data as T)
              : data,
    };
  }
}
