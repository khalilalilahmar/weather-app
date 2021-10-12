import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/model/weather_model.dart';
import 'package:meteo/utils/icon_file.dart';
import 'package:meteo/viewmodel/weather_view_model_cubit.dart';
import 'package:meteo/webservice/network.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => WeatherViewModelCubit(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  String search = "";
  WeatherModel weatherModel = WeatherModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherModel>(
      future: downloadData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<WeatherModel> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('En cours de chargement...'));
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur : ${snapshot.error}'));
          } else {
            weatherModel = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                title: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    search = value;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          /* Clear the search field */
                        },
                      ),
                      hintText: 'Nom de Ville...',
                      fillColor: Colors.white,
                      border: InputBorder.none),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${weatherModel!.city!.name} ( ${weatherModel.city!.coord!.lat}, ${weatherModel.city!.coord!.lon})',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('${weatherModel!.city!.name})'),
                      SizedBox(
                        height: 20,
                      ),
                      IconFile.getWeatherIcones(weatherDescription: weatherModel.list!.first.weather!.first!.main, color: Colors.pink, size: 150.3),
                      SizedBox(
                        height: 20,
                      ),
                      _getcontainer1(),
                      Divider(color: Colors.greenAccent, thickness: 1,),
                      _getcontainer2(),
                      _getcontainer3(),
                    ],
                  ),
                ),
              ),
            ); // snapshot.data  :- get your object which is pass from your downloadData() function
          }
        }
      },
    );
  }

  Future<WeatherModel> downloadData() async {
    return Network.fetchWeather(
        cityName: "Montpellier"); // return your response
  }

  Row _getcontainer1(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${weatherModel!.list!.first!.main!.temp} F',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          '${weatherModel!.list!.first!.weather!.first!.description!.toUpperCase()} ',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Row _getcontainer2(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${weatherModel!.list!.first!.main!.tempKf} mi/h',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          '${weatherModel!.list!.first!.main!.humidity} %',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          '${weatherModel!.list!.first!.main!.temp} F',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Row _getcontainer3(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 2,
        ),
        IconFile.getWeatherIcones(color: Colors.brown, size: 20, weatherDescription: "Hum"),
        SizedBox(
          width: 35,
        ),
        IconFile.getWeatherIcones(color: Colors.brown, size: 20, weatherDescription: "Smile"),
        SizedBox(
          width: 35,
        ),
        IconFile.getWeatherIcones(color: Colors.brown, size: 20, weatherDescription: "Thermo"),
      ],
    );
  }
}
