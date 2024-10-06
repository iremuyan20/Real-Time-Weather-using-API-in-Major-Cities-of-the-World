import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = "London,GB";
  Map<String, dynamic>? _currentWeather;
  List<dynamic>? _forecastWeather;
  List<String> _capitals = [
    "İstanbul, TR", "Ankara, TR", "İzmir, TR",
    "London, GB", "Birmingham, GB", "Manchester, GB",
    "Washington D.C., US", "New York, US", "Los Angeles, US",
    "Tokyo, JP", "Osaka, JP", "Yokohama, JP",
    "Berlin, DE", "Munich, DE", "Frankfurt, DE",
    "Paris, FR", "Marseille, FR", "Lyon, FR",
    "Moscow, RU", "Saint Petersburg, RU", "Novosibirsk, RU",
    "Canberra, AU", "Sydney, AU", "Melbourne, AU",
    "Ottawa, CA", "Toronto, CA", "Vancouver, CA",
    "Brasilia, BR", "São Paulo, BR", "Rio de Janeiro, BR",
    "Rome, IT", "Milan, IT", "Naples, IT",
    "Madrid, ES", "Barcelona, ES", "Valencia, ES",
    "Beijing, CN", "Shanghai, CN", "Guangzhou, CN",
    "New Delhi, IN", "Mumbai, IN", "Bangalore, IN",
    "Bangkok, TH", "Chiang Mai, TH", "Pattaya, TH",
    "Seoul, KR", "Busan, KR", "Incheon, KR",
    "Riyadh, SA", "Jeddah, SA", "Mecca, SA",
    "Cairo, EG", "Alexandria, EG", "Giza, EG",
    "Mexico City, MX", "Guadalajara, MX", "Monterrey, MX",
    "Buenos Aires, AR", "Córdoba, AR", "Rosario, AR",
    "Lima, PE", "Arequipa, PE", "Trujillo, PE",
    "Santiago, CL", "Valparaíso, CL", "Concepción, CL",
    "Bogotá, CO", "Medellín, CO", "Cali, CO",
    "Caracas, VE", "Maracaibo, VE", "Valencia, VE",
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {

      final weatherData = await _weatherService.fetchCurrentWeather(_city);

      final forecastData = await _weatherService.fetch7DayForecast(_city);
      setState(() {
        _currentWeather = weatherData;
        _forecastWeather = forecastData['forecast']['forecastday'];
      });
    } catch (e) {
      print(e);
    }
  }

  void _showCitySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Color(0xFF08272D),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
                      child: Text(
                        "Select City",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white,height: 1,),
                Expanded(
                  child: ListView.builder(
                    itemCount: _capitals.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _capitals[index],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _city = _capitals[index];
                            _currentWeather = null;
                            _forecastWeather = null;
                            _fetchWeather();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

  }

  String getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  String getHour(String time) {
    return time.split(" ")[1].substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentWeather == null || _forecastWeather == null
          ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF394954),
              Color(0xFF103141),
              Color(0xFF0E232D),
            ],
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      )
          : Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF394954),
              Color(0xFF103141),
              Color(0xFF0E232D),
            ],
          ),
        ),
        child: ListView(
          children: [
            Text(
              "Welcome back",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 30),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _showCitySelectionDialog,
                    child: Text(
                      _city,
                      style: GoogleFonts.lato(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.location_city, color: Colors.grey),
                    onPressed: _showCitySelectionDialog,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${_currentWeather!["current"]["temp_c"].round()}°C,",
                        style: GoogleFonts.lato(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10, ),
                      Text(
                        "${_currentWeather!["current"]["condition"]["text"]}",
                        style: GoogleFonts.lato(
                          fontSize: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Image.asset(
                    'assets/nighticon.png',
                    height: 270,
                    width: 270,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _forecastWeather![0]["hour"].length,
                        itemBuilder: (context, index) {
                          var hourData = _forecastWeather![0]["hour"][index];
                          return Container(
                            width: 90,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getHour(hourData["time"]),
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.network(
                                  "http:${hourData['condition']["icon"]}",
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  "${hourData["temp_c"].round()}°C",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 10,
                    thickness: 1,
                    color: Color(0xFF987B18),
                  ),
                  SizedBox(height: 10),

                  Container(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _forecastWeather!.length,
                      itemBuilder: (context, index) {
                        DateTime date = DateTime.parse(_forecastWeather![index]["date"]);
                        String dayName = getWeekdayName(date.weekday);

                        return Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayName,
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.network(
                                "http:${_forecastWeather![index]['day']['condition']['icon']}",
                                height: 40,
                                width: 40,
                              ),
                              Text(
                                "${_forecastWeather![index]['day']['avgtemp_c'].round()}°C",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
