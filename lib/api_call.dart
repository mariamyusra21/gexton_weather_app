import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../utilities.dart';

const weatherAPIUrl = 'https://api.openweathermap.org/data/2.5/weather';
const apiKey = '54faef699f3ceed17e6073d9f51be034';

class Locations {
  late double latitude = 0.0;
  late double longitude = 0.0;
  late int status;

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
    } catch (e) {
      Utilities().toastMessage(e.toString());
    }
  }
}

class NetworkData {
  final String url;
  NetworkData(this.url);

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      Utilities().toastMessage(response.statusCode.toString());
    }
  }
}

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkData networkHelper =
        NetworkData('$weatherAPIUrl?q=${cityName}&appid=$apiKey');
    var weatherData = networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather([String? city]) async {
    Locations location = Locations();
    await location.getCurrentLocation();

    NetworkData networkData = NetworkData(
        '$weatherAPIUrl?lat=${location.latitude}&lon=${location.longitude}&appid=${apiKey}&units=metric');
    var weatherData = networkData.getData();
    return weatherData;
  }
}
