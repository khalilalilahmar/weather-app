import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meteo/model/weather_model.dart';
import 'package:meteo/utils/icon_file.dart';
import 'package:meteo/viewmodel/weather_view_model_cubit.dart';
import 'package:meteo/webservice/network.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
Future<WeatherModel> downloadData() async {
  await Future.delayed(Duration(milliseconds: 300));
  return Network.fetchWeather(
      cityName: "Montpellier");
}
class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  String search = "";
  WeatherModel weatherModel = WeatherModel();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherModel>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<WeatherModel> snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chargement, veuillez patienter',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  height: 25,
                ),
                CircularProgressIndicator()
              ],
            ));
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Une erreur : ${snapshot.error}'));
            } else {
              weatherModel = snapshot.data!;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.blue.shade400,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      foregroundColor: Colors.white,
                      title: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          search = value;
                        },
                        onSubmitted: (value)async {
                         await context.read<WeatherViewModelCubit>().doSearch(search);
                          setState(() {
                            loading=false;
                          });
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search_sharp,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () async {

                                await context.read<WeatherViewModelCubit>().doSearch(search);
                                setState(() {
                                  loading=false;
                                });

                              },
                            ),
                            hintText: 'Enter le nom de ville',
                            hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            fillColor: Colors.white,
                            border: InputBorder.none),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    body:  BlocBuilder<WeatherViewModelCubit, WeatherModel>(
                        builder: (context, _weatherModel) {
                      if (_weatherModel.cod != null)
                        weatherModel = _weatherModel;
                      return  SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${weatherModel.city!.name} ( ${weatherModel.city!.coord!.lat}, ${weatherModel.city!.coord!.lon})',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                  '${DateFormat.yMMMMEEEEd().format(DateTime.now())}'),
                              SizedBox(
                                height: 20,
                              ),
                              IconFile.getWeatherIcones(
                                  weatherDescription: weatherModel
                                      .list!.first.weather!.first!.main,
                                  color: Colors.blueGrey,
                                  size: 120.3),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${weatherModel!.list!.first!.main!.temp} F',
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '${weatherModel!.list!.first!.weather!.first!.description!.toUpperCase()} ',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${weatherModel!.list!.first!.main!.tempKf} mi/h',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '${weatherModel!.list!.first!.main!.humidity} %',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '${weatherModel!.list!.first!.main!.temp} F',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconFile.getWeatherIcones(
                                      color: Colors.green, size: 20, weatherDescription: "Hum"),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  IconFile.getWeatherIcones(
                                      color: Colors.green, size: 20, weatherDescription: "Smile"),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  IconFile.getWeatherIcones(
                                      color: Colors.green, size: 20, weatherDescription: "Thermo"),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                "Prévison des derniers jours",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.28,
                                width: double.infinity,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Card(
                                    color: Colors.blueAccent.shade100,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    elevation: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Jour ${index + 1}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Container(
                                            child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child:
                                                    IconFile.getWeatherIcones(
                                                        color: Colors.blueGrey,
                                                        size: 20,
                                                        weatherDescription:
                                                            weatherModel
                                                                .list![index]
                                                                .weather!
                                                                .first
                                                                .main)),
                                          ),
                                          Text(
                                              "Temp min ${weatherModel.list![index].main?.tempMin.toString()}F",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(
                                              "Temp max ${weatherModel.list![index].main!.tempMax.toString()}F",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(
                                            "Humidité : ${weatherModel.list![index].main!.humidity.toString()}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Pression :${weatherModel.list![index].main!.pressure.toString()}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 8,
                                  ),
                                  itemCount: weatherModel.list!.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }





}
