import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/AdditionalInfo.dart';
import 'hourly_forcast_item.dart';
import 'package:http/http.dart' as http;

class WeatherS extends StatefulWidget {
  const WeatherS({super.key});

  @override
  State<WeatherS> createState() => _WeatherSState();
}

class _WeatherSState extends State<WeatherS> {
  get weatherAPIKEY => null;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      String cityname = 'London';
      final res = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityname,uk&APPID=fa17f46bcd501457404548104c40adca',
      ));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An Unexpected error occured!';
      }
      // data['list'][0]['main']['temp']
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // print('refresh');
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                '325 K',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.cloud,
                                size: 64,
                              ),
                              Text(
                                'Rain',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 36, 114, 174),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // weatherforecastcards
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Weather forecast',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastItem(
                        tempareture: '20 C',
                        icon: Icons.cloudy_snowing,
                        time: '5:15 PM',
                      ),
                      HourlyForecastItem(
                        tempareture: '10 C',
                        icon: Icons.cloud,
                        time: '2:00 AM',
                      ),
                      HourlyForecastItem(
                        tempareture: '18 C',
                        icon: Icons.sunny_snowing,
                        time: '11:45 AM',
                      ),
                      HourlyForecastItem(
                        tempareture: '200 C',
                        icon: Icons.sunny,
                        time: '10:45 PM',
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional information',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      value: '94',
                      icon: Icons.water_drop,
                      label: 'Hmidity',
                    ),
                    AdditionalInfo(
                      value: '300',
                      icon: Icons.air,
                      label: 'pressure',
                    ),
                    AdditionalInfo(
                      value: '50',
                      icon: Icons.beach_access,
                      label: 'pressure',
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
