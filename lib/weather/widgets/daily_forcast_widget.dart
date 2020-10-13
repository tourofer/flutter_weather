import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';

import 'forecast_item_widget.dart';

class DailyForcastWidget extends StatelessWidget {
  final WeatherData data;

  const DailyForcastWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forcastItems = data.forcastItems;

    return ListView.builder(
      itemCount: forcastItems.length,
      itemBuilder: (context, index) =>
          ForcastItemWidget(data: forcastItems[index]),
    );
  }
}
