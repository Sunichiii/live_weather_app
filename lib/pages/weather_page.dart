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
  //adding api key
  final _weatherService = WeatherService("65840199bc18b46ec973aa02230f4ee5");
  Weather? _weather;
  String _errorMessage = '';

  //for search ber
  final _searchController = TextEditingController();

  // Fetching weather data
  _fetchWeather({String? cityName}) async {
    setState(() {
      _errorMessage = '';
    });

    //use the current location city if the location is not given
    cityName ??= await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
      setState(() {
        //setting error message on city that doesn't exist
        _errorMessage = 'Sorry, The city does not exist!!';
      });
    }
  }

  // Handling search submission
  void _onSearch() {
    final cityName = _searchController.text.trim();
    if (cityName.isNotEmpty) {
      _fetchWeather(cityName: cityName);
    }
  }

  // Weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // Default to sunny

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
        return 'assets/rainy.json';

      case 'clear':
        return 'assets/sunny.json';

      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetching weather on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for a city...',
                  hintStyle: const TextStyle(
                      color: Colors.white54, fontFamily: "Poppins"),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                onSubmitted: (_) => _onSearch(),
              ),
            ),
            if (_errorMessage.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_weather != null) ...[
                      // City name
                      Column(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            _weather?.cityName ?? "Loading city...",
                            style: const TextStyle(
                              fontFamily: "BonaNova",
                              fontSize: 55,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Animation
                      Flexible(
                        child: Lottie.asset(
                          getWeatherAnimation(_weather?.mainCondition),
                          width: 350,
                          height: 350,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Temperature
                      Text(
                        '${_weather?.temperature.round()}°C',
                        style: const TextStyle(
                          fontFamily: "BebasNeue",
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Condition
                      Text(
                        _weather?.mainCondition ?? "Unknown",
                        style: const TextStyle(
                          fontFamily: "BonaNova",
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white54, // Text color
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
