import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/model/weather_model.dart';
import 'package:meteo/webservice/network.dart';

class WeatherViewModelCubit extends Cubit<WeatherModel>{
  WeatherModel weatherModel = WeatherModel();

  WeatherViewModelCubit() : super(WeatherModel());

  WeatherModel doSearch (String cityName){
    Network.fetchWeather(cityName: cityName).then((value) {
      weatherModel = value;
    }).catchError(onError)
        .whenComplete(() {
          print("La requete est terminée");
    });
    emit(weatherModel);
    return weatherModel;
  }

}