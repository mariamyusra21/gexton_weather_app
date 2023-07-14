import 'package:flutter/material.dart';

import 'api_call.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.locationWeather});
  final locationWeather;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int? temperature;
  late int? humidity;
  late String? condition;
  late String? country;
  late String? city;
  WeatherModel _weatherModel = WeatherModel();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    temperature = 0;
    humidity = 0;
    condition = '';
    country = '';
    city = '';
    getLocationData(widget.locationWeather);
  }

  getLocationData(weather) async {
    var weatherData = await _weatherModel.getLocationWeather();
    setState(() {
      // if (weatherData == null) {
      //   temperature = 0;
      //   city = '';
      //   return;
      // }

      condition = weatherData['weather'][0]['main'];
      humidity = weatherData['main']['humidity'];
      country = weatherData['sys']['country'];
      city = weatherData['name'];
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime.shade800,
        title: Text(
          'Weather App',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              city = value;
            },
            cursorHeight: 25,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                hintText: 'Search Location...',
                hintStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          ),
          TextButton(
            onPressed: () async {
              if (city != null) {
                var weatherData =
                    await _weatherModel.getCityWeather(city.toString());
                getLocationData(weatherData);
              }
            },
            child: Text(
              'Get Weather',
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(height: 150),
                Text(
                  'Temperature: $temperature°  ',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Condition: $condition  ',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Humidity: $humidity  ',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Country: $country  ',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  'City: $city  ',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
