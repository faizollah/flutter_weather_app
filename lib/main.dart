import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 20, color: Colors.grey[700]),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[400],
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String city = '';
  Map<String, dynamic> weatherData = {};

  Future<void> fetchWeather() async {
    final response = await http
        .get(Uri.parse('https://faizollah.pythonanywhere.com/weather/$city'));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      print('Failed to fetch weather data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                city = value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_city, color: Colors.grey[600]),
                hintText: 'Enter City',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[300]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: ElevatedButton(
                onPressed: fetchWeather,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
                ),
                child: const Text('Fetch Weather',
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
            ),
            const SizedBox(height: 32),
            //It means that if weatherData is not empty, the widgets inside the
            // ...[] will be included in the parent widget's list of children.
            // It's a way to conditionally render multiple widgets in one go.
            if (weatherData.isNotEmpty) ...[
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('City: ${weatherData['city']}',
                          style: Theme.of(context).textTheme.displayLarge),
                      const SizedBox(height: 12),
                      Text('Temperature: ${weatherData['temperature']}°C',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Text('Description: ${weatherData['description']}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Text('Humidity: ${weatherData['humidity']}%',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Text('Visibility: ${weatherData['visibility']}',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
