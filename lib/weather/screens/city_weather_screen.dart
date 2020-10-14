import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/models/city_model.dart';
import 'package:ofer_intro_flutter/weather/models/weather_model.dart';
import 'package:ofer_intro_flutter/weather/widgets/async_resource_consumer.dart';
import 'package:ofer_intro_flutter/weather/widgets/daily_forcast_widget.dart';
import 'package:ofer_intro_flutter/weather/widgets/weather_error_widget.dart';

import '../bloc/weather_change_notifier.dart';

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
    return AsyncResourceConsumer<WeatherStore, WeatherData>(
        onError: (_, hadConnection) => Center(
                child: WeatherErrorWidget(
              hadConnection: hadConnection,
            )),
        onLoading: () => Center(child: CircularProgressIndicator()),
        onSuccess: (data) => DailyForcastWidget(data: data),
        selector: (_, store) => store.items[city.id]);
  }
}
