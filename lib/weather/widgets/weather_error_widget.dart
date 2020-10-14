import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_cubit.dart';

class WeatherErrorWidget extends StatelessWidget {
  final bool hadConnection;

  const WeatherErrorWidget({Key key, @required this.hadConnection})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(hadConnection
              ? "There was an error, please try again"
              : "Please check your internet connection and try again"),
          RaisedButton(
              child: Text("Retry"),
              onPressed: () =>
                  context.bloc<WeatherCubit>().fetchAllCitiesWeather())
        ],
      ),
    );
  }
}
