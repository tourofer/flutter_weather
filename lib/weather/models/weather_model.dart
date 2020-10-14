import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherData {
  final List<SingleForcastItem> forcastItems;

  WeatherData({@required this.forcastItems});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final rawItems = json['consolidated_weather'];

    List<SingleForcastItem> items = List.from(rawItems)
        .map((singleRawItem) => SingleForcastItem.fromJson(singleRawItem))
        .toList();
    return WeatherData(forcastItems: items);
  }
}

class SingleForcastItem {
  final DateTime forcastDate;
  final String weatherState;
  final double minTemp;
  final double maxTemp;
  final String humidity;

  final String displayDate;
  final String minTempDisplay;
  final String maxTempDisplay;

  SingleForcastItem({
    @required this.minTempDisplay,
    @required this.maxTempDisplay,
    @required this.forcastDate,
    @required this.weatherState,
    @required this.displayDate,
    @required this.humidity,
    @required this.minTemp,
    @required this.maxTemp,
  });

  factory SingleForcastItem.fromJson(Map<String, dynamic> json) {
    final createdDate = DateTime.parse(json['applicable_date']);
    return SingleForcastItem(
        minTemp: json['min_temp'],
        maxTemp: json['max_temp'],
        minTempDisplay:
            '${(json['min_temp'] as double).toStringAsPrecision(2)}°',
        maxTempDisplay:
            '${(json['max_temp'] as double).toStringAsPrecision(2)}°',
        forcastDate: createdDate,
        weatherState: json['weather_state_name'],
        displayDate: new DateFormat('EEE dd/MM').format(createdDate),
        humidity: '${json['humidity']}%');
  }
}

extension SingleForcastItemExtention on SingleForcastItem {
  AssetImage getWeatherIcon() {
    var sanitzedName = this.weatherState.toLowerCase().replaceAll(" ", "_");

    if (sanitzedName == "showers" || sanitzedName.contains("rain")) {
      sanitzedName = "rain";
    }
    return AssetImage('assets/$sanitzedName.png');
  }
}
