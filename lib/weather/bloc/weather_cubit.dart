import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/weatherStates.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';
import 'package:ofer_intro_flutter/weather/models/async_resource.dart';
import 'package:ofer_intro_flutter/weather/models/weather_change_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherStore weatherStore;

  WeatherCubit(this.weatherStore) : super(WeatherStateLoading());

  void fetchAllCitiesWeather() async {
    final futures =
        weatherStore.cities.map((city) => _fetchCityWeather(city.id));
    await Future.wait(futures);
  }

  Future<void> _fetchCityWeather(String cityId) async {
    try {
      weatherStore.add(cityId, AsyncResourceLoading());

      final response =
          await http.get('https://www.metaweather.com/api/location/$cityId/');

      if (response.statusCode == 200) {
        final json = WeatherData.fromJson(jsonDecode(response.body));
        weatherStore.add(cityId, AsyncResourceSuccess(json));
        return json;
      } else {
        emitError(cityId);
      }
    } catch (e) {
      emitError(cityId, error: e);
    }
  }

  void emitError(String cityId, {dynamic error}) async {
    weatherStore.add(
        cityId, AsyncResourceError(error: error, hadConnectivity: false));
  }

  Future<bool> _isConnected() async {
    return (Connectivity().checkConnectivity()).then(
        (connectivityResult) => connectivityResult != ConnectivityResult.none);
  }
}
