

import 'package:medi_connect/core/common_models/failures/failure.dart';

abstract class ApiResponse<T> {
  const ApiResponse();

  /// Utility to run conditional logic depending on state.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
    required R Function() onLoading,
  }) {
    if (this is ApiSuccess<T>) {
      return onSuccess((this as ApiSuccess<T>).data);
    } else if (this is ApiFailure<T>) {
      return onFailure((this as ApiFailure<T>).failure);
    } else if (this is ApiLoading<T>) {
      return onLoading();
    }
    throw AssertionError('Invalid state in ApiResponse');
  }
}

/// Represents successful API state carrying the response data.
class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  const ApiSuccess(this.data);
}

/// Represents failed API state containing failure details.
class ApiFailure<T> extends ApiResponse<T> {
  final Failure failure;
  const ApiFailure(this.failure);
}

/// Represents network request loading/in-progress state.
class ApiLoading<T> extends ApiResponse<T> {
  const ApiLoading();
}
