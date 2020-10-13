import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:ofer_intro_flutter/weather/models/async_resource.dart';
import '../models/weather_change_notifier.dart';
import 'weatherEvents.dart';
import 'weatherStates.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //TODO REMOE THE BLOC AND SWITCH TO CUBIT
  final WeatherStore weatherStore;

  WeatherBloc(this.weatherStore) : super(WeatherStateLoading()) {
    // add(FetchAllWeather());
  }

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchAllWeather) {
      yield* _fetchWeatherFromApi();
    } else if (event is FetchAllCityWeather) {
      _fetchAllCitiesWeather();
    } else {
      throw UnimplementedError();
    }
  }

  Stream<WeatherState> _fetchWeatherFromApi() async* {
    yield WeatherStateLoading();

    try {
      await _fetchCityWeather("44418");
      // yield WeatherStateData(weatherData);
    } catch (e) {
      print(e);
      yield WeatherStateError(e);
    }
  }

  void _fetchAllCitiesWeather() async {
    final futures =
        weatherStore.cities.map((city) => _fetchCityWeather(city.id));
    await Future.wait(futures);
  }

  Future<void> _fetchCityWeather(String cityId) async {
    weatherStore.add(cityId, AsyncResourceLoading());

    final response =
        await http.get('https://www.metaweather.com/api/location/$cityId/');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      final json = WeatherData.fromJson(jsonDecode(response.body));
      weatherStore.add(cityId, AsyncResourceSuccess(json));
      return json;
    } else {
      //TODO add connectivity check
      weatherStore.add(cityId, AsyncResourceError());
    }
  }
}
