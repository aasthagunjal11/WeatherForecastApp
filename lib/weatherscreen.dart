import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
       String cityName = "Pune";
     final result = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName,In&APPID=$openWeatherAPIKey")
    );
    final data = jsonDecode(result.body);
    if(data['cod']!='200'){
      throw 'An unexpected error occured';
    }
      return data;
    }catch(e){
      throw e.toString();
    }
  }
  @override
  void initState(){
     super.initState();
     weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather Screen",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
             });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
      ),
      body:  FutureBuilder(
        future: weather ,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:  CircularProgressIndicator.adaptive()
            );
          }
          if(snapshot.hasError){
            return  Center(child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          final currentweatherData = data['list'][0];
          final currentTemp = currentweatherData['main']['temp'];
          final curreentSky = currentweatherData['weather'][0]['main'];
          final currentPressure = currentweatherData['main']['pressure'];
          final currentWindSpeed = currentweatherData['wind']['speed'];
          final currentHumidity = currentweatherData['main']['humidity'];


          return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main weather card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp k',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               const SizedBox(height: 12),
                                Icon(
                               curreentSky == 'Clouds' || curreentSky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny ,
                                size: 64,
                              ),
                               const SizedBox(height: 12),
                               Text(
                                curreentSky,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                        
                const SizedBox(height: 18),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                        
                // Horizontal scrolling forecast
                //  SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       for (int i=0;i<39;i++)
                //        HourlyForecastItem(
                //         time:data ['list'][i+1]['dt_txt'].toString(),
                //         icon: data ['list'][i+1]['weather'][0]['main'] == 'Clouds' || data ['list'][i+1]['weather'][0]['main']=='Rain'
                //          ? Icons.cloud
                //          : Icons.sunny,
                //         temp: data['list'][i+1]['main']['temp'].toString(),
                //       ),
                //     ],
                //   ),
                // ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:6,
                itemBuilder: (context, index) {
                  final hourlyForecast = data['list'][index+1];
                  final hourlySky = data ['list'][index+1]['weather'][0]['main'];
                  final time = DateTime.parse(hourlyForecast['dt_txt']);
                  return  HourlyForecastItem(
                    time: DateFormat.Hm().format(time),
                    temp: hourlyForecast['main']['temp'].toString(),
                    icon: hourlySky == 'Clouds'|| hourlySky=='Rain'
                           ? Icons.cloud
                           : Icons.sunny,
                   );
                },
              ),
            ),
          
                const SizedBox(height: 20),
                        
                // Additional information
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air ,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}

