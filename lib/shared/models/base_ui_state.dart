enum BaseUIStatus {
  initial,
  loading,
  success,
  error,
}

class BaseUIState<T> {
  const BaseUIState({
    this.status = BaseUIStatus.initial,
    this.data,
    this.message,
  });

  final BaseUIStatus status;
  final T? data;
  final String? message;

  bool get isInitial => status == BaseUIStatus.initial;
  bool get isLoading => status == BaseUIStatus.loading;
  bool get isSuccess => status == BaseUIStatus.success;
  bool get isError => status == BaseUIStatus.error;

  BaseUIState<T> copyWith({
    BaseUIStatus? status,
    T? data,
    String? message,
  }) {
    return BaseUIState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory BaseUIState.initial({T? data}) {
    return BaseUIState<T>(
      status: BaseUIStatus.initial,
      data: data,
    );
  }

  factory BaseUIState.loading({T? data, String? message}) {
    return BaseUIState<T>(
      status: BaseUIStatus.loading,
      data: data,
      message: message,
    );
  }

  factory BaseUIState.success({T? data, String? message}) {
    return BaseUIState<T>(
      status: BaseUIStatus.success,
      data: data,
      message: message,
    );
  }

  factory BaseUIState.error({T? data, String? message}) {
    return BaseUIState<T>(
      status: BaseUIStatus.error,
      data: data,
      message: message,
    );
  }
}
