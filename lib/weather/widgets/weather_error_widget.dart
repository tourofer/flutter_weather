import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/weatherEvents.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_bloc.dart';

class WeatherErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("There was an error, please try again"),
          RaisedButton(
            child: Text("Retry"),
            onPressed: () => context.bloc<WeatherBloc>().add(FetchAllWeather()),
          )
        ],
      ),
    );
  }
}
