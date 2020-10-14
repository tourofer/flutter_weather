import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/screens/city_weather_screen.dart';

import 'city_model.dart';

class AppNavigator {
  static navigateToCityWeatherScreen(BuildContext context, City city) {
    Navigator.pushNamed(
      context,
      CityWeatherScreen.route,
      arguments: CityWeatherScreenArguments(city),
    );
  }
}
