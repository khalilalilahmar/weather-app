import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/model/weather_model.dart';
import 'package:meteo/webservice/network.dart';

class WeatherViewModelCubit extends Cubit<WeatherModel>{
  WeatherModel weatherModel = WeatherModel();

  WeatherViewModelCubit() : super(WeatherModel());

  Future<WeatherModel> doSearch (String cityName) async {
    weatherModel = await Network.fetchWeather(cityName: cityName);
    emit(weatherModel);
    return weatherModel;
  }

}