import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/models/city_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'connection_checker.dart';

class QueryCitiesBloc extends Bloc<QueryCityEvent, QueryCitiesState> {
  QueryCitiesBloc() : super(QueryCitiesStateIdle());

  @override
  Stream<Transition<QueryCityEvent, QueryCitiesState>> transformEvents(
      Stream<QueryCityEvent> events, transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<QueryCitiesState> mapEventToState(QueryCityEvent event) async* {
    print("yield loading");

    yield QueryCitiesStateLoading();

    try {
      final response = await http.get(
          'https://www.metaweather.com/api/location/search/?query=${event.query}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final cities =
            List<City>.from(json.map((model) => City.fromJson(model)).toList());
        print("yield data");

        yield QueryCitiesStateData(cities);
      } else {
        throw HttpException("got response code: ${response.statusCode}");
      }
    } catch (e) {
      print("yield error");
      yield QueryCitiesStateError(await ConnectionChecker.isConnected());
    }
  }
}

@immutable
class QueryCityEvent {
  final String query;

  QueryCityEvent(this.query);
}

@immutable
abstract class QueryCitiesState {}

class QueryCitiesStateIdle extends QueryCitiesState {}

class QueryCitiesStateLoading extends QueryCitiesState {}

class QueryCitiesStateData extends QueryCitiesState {
  final List<City> cities;

  QueryCitiesStateData(this.cities);
}

class QueryCitiesStateError extends QueryCitiesState {
  final dynamic e;
  final bool hadConnection;

  QueryCitiesStateError(
    this.hadConnection, {
    this.e,
  });
}
