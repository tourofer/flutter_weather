import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';

import 'async_resource.dart';

class WeatherStore extends ChangeNotifier {
  final Map<String, AsyncResource<WeatherData>> _weatherMap = new Map();

  final List<City> _cities = new List()
    ..add(new City("London", "44418"))
    ..add(new City("San-fransisco", "2487956"));

  List<City> get cities => _cities;

  Map<String, AsyncResource<WeatherData>> get items => _weatherMap;

  void add(String cityId, AsyncResource<WeatherData> state) {
    _weatherMap[cityId] = state;
    notifyListeners();
  }
}

class City {
  final String name;
  final String id;

  City(this.name, this.id);
}
