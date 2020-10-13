import 'package:flutter/material.dart';

@immutable
abstract class AsyncResource<T> {}

@immutable
class AsyncResourceEmpty<T> extends AsyncResource<T> {}

class AsyncResourceLoading<T> extends AsyncResource<T> {}

@immutable
class AsyncResourceSuccess<T> extends AsyncResource<T> {
  final T data;

  AsyncResourceSuccess(this.data);
}

@immutable
class AsyncResourceError<T> extends AsyncResource<T> {
  final bool hadConnectivity;
  final dynamic error;

  AsyncResourceError({this.error, this.hadConnectivity});
}
