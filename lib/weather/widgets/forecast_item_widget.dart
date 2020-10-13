import 'package:flutter/material.dart';
import 'package:ofer_intro_flutter/weather/bloc/weather_model.dart';

class ForcastItemWidget extends StatelessWidget {
  final SingleForcastItem data;

  const ForcastItemWidget({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Text(data.weatherState),
          subtitle: Text('Temp: ${data.minTempDisplay}-${data.maxTempDisplay}'),
          leading: Image(image: AssetImage('assets/clear.png')),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(data.displayDate),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/humidity.png",
                    height: 30,
                    width: 30,
                  ),
                  Text(data.humidity)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
