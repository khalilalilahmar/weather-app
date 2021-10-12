import 'dart:convert';

import 'package:meteo/model/weather_model.dart';
import 'package:meteo/webservice/weather_client.dart';
import 'package:http/http.dart' as http;


class Network{

 static Future<WeatherModel> fetchWeather({required String cityName}) async {
    final url = Uri.parse(WeatherClient.baseURL+ "$cityName" + WeatherClient.AppId);
    final response = await http.get(url);
       print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather: $cityName');
    }
  }

}