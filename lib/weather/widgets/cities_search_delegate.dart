import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/fetch_weather_cubit.dart';
import 'package:ofer_intro_flutter/weather/bloc/query_cities_bloc.dart';
import 'package:ofer_intro_flutter/weather/models/city_model.dart';
import 'package:ofer_intro_flutter/weather/widgets/weather_error_widget.dart';

class CitiesSearchDelegate extends SearchDelegate {
  final QueryCitiesBloc queryBloc;

  CitiesSearchDelegate(this.queryBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    queryBloc.add(QueryCityEvent(query));

    return BlocBuilder(
        cubit: queryBloc, builder: (context, state) => _buildContent(state));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Widget _buildContent(QueryCitiesState state) {
    print("got state $state");
    if (state is QueryCitiesStateLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is QueryCitiesStateError) {
      return Center(
        child: WeatherErrorWidget(
          hadConnection: state.hadConnection,
        ),
      );
    } else if (state is QueryCitiesStateData) {
      if (state.cities.isEmpty) {
        return _emptyResultsView(query);
      }
      return _buildQueryResultList(state.cities);
    } else {
      return Container();
    }
  }

  Widget _buildQueryResultList(List<City> cities) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          BlocProvider.of<FetchWeatherCubit>(context).addNewCity(cities[index]);
          close(context, cities[index]);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(cities[index].name),
          ),
        ),
      ),
    );
  }

  Widget _emptyResultsView(String query) {
    return Center(child: Text("Couldn't find cities for: $query"));
  }
}
