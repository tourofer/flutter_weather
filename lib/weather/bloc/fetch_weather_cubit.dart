import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/connection_checker.dart';
import 'package:ofer_intro_flutter/weather/models/city_model.dart';
import 'package:ofer_intro_flutter/weather/models/weatherStates.dart';
import 'package:ofer_intro_flutter/weather/models/weather_model.dart';
import 'package:ofer_intro_flutter/weather/models/async_resource.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_change_notifier.dart';
import 'package:http/http.dart' as http;

class FetchWeatherCubit extends Cubit<WeatherState> {
  final WeatherStore weatherStore;

  FetchWeatherCubit(this.weatherStore) : super(WeatherStateLoading());

  void addNewCity(City city) {
    fetchCitiesWeather([city.id]);
    weatherStore.addCity(city);
  }

  void fetchAllCitiesWeather() async {
    fetchCitiesWeather(weatherStore.cities.map((city) => city.id).toList());
  }

  void fetchCitiesWeather(List<String> ids) async {
    final futures = ids.map((id) => _fetchCityWeather(id));
    await Future.wait(futures);
  }

  Future<void> _fetchCityWeather(String cityId) async {
    try {
      weatherStore.addCityWeatherData(cityId, AsyncResourceLoading());

      final response =
          await http.get('https://www.metaweather.com/api/location/$cityId/');

      if (response.statusCode == 200) {
        final json = WeatherData.fromJson(jsonDecode(response.body));
        weatherStore.addCityWeatherData(cityId, AsyncResourceSuccess(json));
        return json;
      } else {
        emitError(cityId);
      }
    } catch (e) {
      emitError(cityId, error: e);
    }
  }

  void emitError(String cityId, {dynamic error}) async {
    weatherStore.addCityWeatherData(
        cityId,
        AsyncResourceError(
            error: error,
            hadConnectivity: await ConnectionChecker.isConnected()));
  }
}
