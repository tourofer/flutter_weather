import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/models/city_model.dart';
import 'package:ofer_intro_flutter/weather/models/weather_model.dart';

import '../models/async_resource.dart';

class WeatherStore extends ChangeNotifier {
  final Map<String, AsyncResource<WeatherData>> _weatherMap = new Map();

  List<City> _cities = new List()
    ..add(new City("London", "44418"))
    ..add(new City("San-fransisco", "2487956"));

  List<City> get cities => _cities;

  Map<String, AsyncResource<WeatherData>> get items => _weatherMap;

  void addCityWeatherData(String cityId, AsyncResource<WeatherData> state) {
    _weatherMap[cityId] = state;
    notifyListeners();
  }

  reorderCity(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final element = _cities.removeAt(oldIndex);
    _cities.insert(newIndex, element);
    notifyListeners();
  }

  void addCity(City city) {
    _cities.add(city);
    notifyListeners();
  }
}
