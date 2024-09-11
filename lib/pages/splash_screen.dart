import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_today/pages/weather_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState(){
    super.initState();
    //this will navigate to the weather page after certain delay
    _navigateToHome();
}
  _navigateToHome() async{
    //setting delay duration
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> WeatherPage())
    );
  }
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
            "assets/splashscreen.json",
            height: 300,
            width: 300,
            fit: BoxFit.cover
          ),

            const SizedBox(height: 5,),

            const Text(
            "Weather Today",
            style: TextStyle(
            fontFamily: "BonaNova",
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white
            ), // Text color
            ),
          ],
        )
      ),
    );
  }
}
