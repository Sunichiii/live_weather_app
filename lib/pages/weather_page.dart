import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_today/services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService("65840199bc18b46ec973aa02230f4ee5");
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //displaying current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/thunder.json';

      case 'clear':
        return 'assets/sunny.json';

      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    //fetching weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Column(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 50,
                ),
                Text(
                  _weather?.cityName ?? "Loading city..",
                  style: TextStyle(
                    fontFamily: "BebasNeue",
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // text color
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            //animation
            Flexible(
              child: Lottie.asset(
                getWeatherAnimation(_weather?.mainCondition),
                width: 350,
                height: 350,
              ),
            ),
            SizedBox(height: 20),
            //temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(
                fontFamily: "BebasNeue",
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white, // text color
              ),
            ),
            SizedBox(height: 10),
            //condition
            Text(
              _weather?.mainCondition ?? "Unknown",
              style: TextStyle(
                fontFamily: "BebasNeue",
                fontSize: 25,
                color: Colors.white54, // text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
