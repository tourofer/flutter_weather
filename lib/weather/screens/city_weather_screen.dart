import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';
import 'package:ofer_intro_flutter/weather/models/async_resource.dart';
import 'package:ofer_intro_flutter/weather/widgets/daily_forcast_widget.dart';
import 'package:ofer_intro_flutter/weather/widgets/weather_error_widget.dart';
import 'package:provider/provider.dart';

import '../models/weather_change_notifier.dart';

class CityWeatherScreenArguments {
  final City city;

  CityWeatherScreenArguments(this.city);
}

class CityWeatherScreen extends StatelessWidget {
  static final String route = "/weather/city";
  @override
  Widget build(BuildContext context) {
    final CityWeatherScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    final city = args.city;

    return Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
        ),
        body: CityWeatherContent(city: city));
  }
}

class CityWeatherContent extends StatelessWidget {
  const CityWeatherContent({
    Key key,
    @required this.city,
  }) : super(key: key);

  final City city;

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherStore, AsyncResource<WeatherData>>(
      builder: (context, value, child) {
        if (value is AsyncResourceSuccess) {
          return DailyForcastWidget(
            data: (value as AsyncResourceSuccess).data,
          );
        } else if (value is AsyncResourceError) {
          return Center(child: WeatherErrorWidget());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      selector: (_, store) => store.items[city.id],
    );
  }
}
