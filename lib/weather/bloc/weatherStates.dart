import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';

abstract class WeatherState {}

// class WeatherStateInit extends WeatherState {}

class WeatherStateLoading extends WeatherState {}

class WeatherStateData extends WeatherState {
  final WeatherData weatherData;

  WeatherStateData(this.weatherData);
}

class WeatherStateError extends WeatherState {
  final dynamic e;

  WeatherStateError(this.e);
}
