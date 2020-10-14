import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/models/async_resource.dart';
import 'package:provider/provider.dart';

class AsyncResourceConsumer<ChangeNotifier, DataType> extends StatelessWidget {
  final Widget Function(dynamic e) onError;
  final Widget Function() onLoading;
  final Widget Function(DataType data) onSuccess;

  final AsyncResource<DataType> Function(BuildContext, ChangeNotifier) selector;

  const AsyncResourceConsumer({
    Key key,
    @required this.onError,
    @required this.onLoading,
    @required this.onSuccess,
    @required this.selector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ChangeNotifier, AsyncResource<DataType>>(
        builder: (context, value, child) {
          if (value is AsyncResourceError) {
            return onError((value as AsyncResourceError).error);
          } else if (value is AsyncResourceSuccess) {
            return onSuccess((value as AsyncResourceSuccess).data);
          } else {
            return onLoading();
          }
        },
        selector: selector);
  }
}
