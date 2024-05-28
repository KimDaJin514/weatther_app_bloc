import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/domain/entities/weather.dart';

import '../../helpers/json_reader.dart';

void main(){

  const testWeatherModel = WeatherModel(
    cityName: 'New York',
    main: 'Clouds',
    description: 'scattered clouds',
    iconCode: '03n',
    temperature: 287.26,
    pressure: 1016,
    humidity: 91
  );
  
  test('should be a subclass of weather entity', (){
    expect(testWeatherModel, isA<WeatherEntity>());
  });

  test('should return a valid model from json', () async{

    // arrange
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('helpers/dummy_data/dummy_weather_response.json')
    );

    // act
    final result = WeatherModel.fromJson(jsonMap);

    // expect
    expect(result, equals(testWeatherModel));
  });

  test('should return a json map containing proper data', () async {

    // act
    final result = testWeatherModel.toJson();

    // assert
    final expectedJsonMap = {
      'weather': [{
        'main': 'Clouds',
        'description': 'scattered clouds',
        'icon': '03n',
      }],
      'main': {
        'temp': 287.26,
        'pressure': 1016,
        'humidity': 91,
      },
      'name': 'New York',
    };

    expect(result, equals(expectedJsonMap));
  });
}