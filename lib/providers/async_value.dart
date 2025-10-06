import 'package:flutter/foundation.dart';

/// Represents the loading state of an asynchronous resource.
class AsyncValue<T> {
  AsyncValue({
    this.data,
    this.isLoading = false,
    this.errorMessage,
    this.hasLoaded = false,
  });

  T? data;
  bool isLoading;
  String? errorMessage;
  bool hasLoaded;

  bool get hasError => errorMessage != null;

  void startLoading() {
    isLoading = true;
    errorMessage = null;
  }

  void setData(T value) {
    data = value;
    isLoading = false;
    hasLoaded = true;
    errorMessage = null;
  }

  void setNullableData(T? value) {
    data = value;
    isLoading = false;
    hasLoaded = true;
    errorMessage = null;
  }

  void setError(Object error) {
    errorMessage = error.toString();
    isLoading = false;
    hasLoaded = true;
  }

  void reset() {
    data = null;
    isLoading = false;
    errorMessage = null;
    hasLoaded = false;
  }

  @override
  String toString() {
    return 'AsyncValue(isLoading: ' +
        isLoading.toString() +
        ', hasLoaded: ' +
        hasLoaded.toString() +
        ', error: ' +
        errorMessage.toString() +
        ', data: ' +
        (kDebugMode ? data.toString() : '<omitted>') +
        ')';
  }
}
