import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_cubit.dart';
import 'package:ofer_intro_flutter/weather/models/app_navigator.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';
import 'package:ofer_intro_flutter/weather/models/async_resource.dart';
import 'package:ofer_intro_flutter/weather/models/weather_change_notifier.dart';
import 'package:ofer_intro_flutter/weather/widgets/async_resource_consumer.dart';
import 'package:ofer_intro_flutter/weather/widgets/forecast_item_widget.dart';
import 'package:ofer_intro_flutter/weather/widgets/weather_error_widget.dart';
import 'package:provider/provider.dart';

class WeatherScreenList extends StatefulWidget {
  @override
  _WeatherScreenListState createState() => _WeatherScreenListState();
}

class _WeatherScreenListState extends State<WeatherScreenList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherCubit>(context, listen: false).fetchAllCitiesWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO suppport add city, swipe to delete & reorder
    return Scaffold(
        appBar: AppBar(title: Text('Cities Weather')),
        body: Selector<WeatherStore, List<City>>(
            builder: (context, value, child) => ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) => CityOverviewWeatherItem(
                    city: value[index],
                  ),
                ),
            selector: (context, store) => store.cities));
  }
}

class CityOverviewWeatherItem extends StatelessWidget {
  final City city;

  const CityOverviewWeatherItem({Key key, this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text('${city.name}:'),
          ),
          AsyncResourceConsumer<WeatherStore, SingleForcastItem>(
              onError: (_, hadConnection) => WeatherErrorWidget(
                    hadConnection: hadConnection,
                  ),
              onSuccess: (data) => CityWeatherWidget(
                    city: city,
                    forcastItem: data,
                  ),
              onLoading: () => Container(
                  constraints: BoxConstraints(minHeight: 100),
                  child: Center(child: CircularProgressIndicator())),
              selector: latestCityForcastSelector),
        ],
      ),
    );
  }

  AsyncResource<SingleForcastItem> latestCityForcastSelector(_, store) {
    //only listen to the relevant item latest weather forcast
    final AsyncResource<WeatherData> cityResource = store.items[city.id];
    if (cityResource is AsyncResourceSuccess<WeatherData>) {
      final forcast = cityResource.data.forcastItems.first;
      return AsyncResourceSuccess(forcast);
    } else if (cityResource is AsyncResourceError) {
      final errorResource = (cityResource as AsyncResourceError);
      return AsyncResourceError(
          hadConnectivity: errorResource.hadConnectivity,
          error: errorResource.error);
    } else {
      return AsyncResourceLoading();
    }
  }
}

class CityWeatherWidget extends StatelessWidget {
  const CityWeatherWidget({
    Key key,
    @required this.city,
    @required this.forcastItem,
  }) : super(key: key);

  final City city;
  final SingleForcastItem forcastItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => AppNavigator.navigateToCityWeatherScreen(context, city),
        child: ForcastItemWidget(data: forcastItem));
  }
}
