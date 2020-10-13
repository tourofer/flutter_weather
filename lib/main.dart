import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_bloc.dart';
import 'package:ofer_intro_flutter/weather/screens/city_weather_screen.dart';
import 'package:ofer_intro_flutter/weather/screens/weather_list_screen.dart';
import 'package:ofer_intro_flutter/weather/models/weather_change_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: []
          ..addAll(standAloneDependencies())
          ..addAll(proxyProviders()),
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => WeatherScreenList(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            CityWeatherScreen.route: (context) => CityWeatherScreen(),
          },
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.green,
          ),
        ));
  }
}

standAloneDependencies() => [
      ChangeNotifierProvider<WeatherStore>(
        create: (context) => WeatherStore(),
      ),
    ];
proxyProviders() => [
      BlocProvider<WeatherBloc>(
        lazy: false,
        create: (BuildContext context) =>
            WeatherBloc(Provider.of(context, listen: false)),
      ),
    ];
