import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/query_cities_bloc.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_change_notifier.dart';
import 'package:ofer_intro_flutter/weather/models/city_model.dart';
import 'package:ofer_intro_flutter/weather/widgets/weather_error_widget.dart';
import 'package:provider/provider.dart';

class CitiesSearchDelegate extends SearchDelegate {
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
    BlocProvider.of<QueryCitiesBloc>(context).add(QueryCityEvent(query));

    return BlocConsumer<QueryCitiesBloc, QueryCitiesState>(
      builder: (context, state) {
        return _buildContent(state);
      },
      listener: (context, state) {},
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Widget _buildContent(QueryCitiesState state) {
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
          Provider.of<WeatherStore>(context, listen: false)
              .addCity(cities[index]);
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
}
