import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/constants/constants.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/data/data_sources/remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/models/weather_model.dart';
import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

main() {
  late MockHttpClient mockHttpClient;
  late WeatherRemoteDataSourceImpl weatherRemoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    weatherRemoteDataSourceImpl = WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  const cityName = 'New York';

  group('get current weather', () {
    test('should return weather model when the response code is 200', () async{
      // arrange
      when(mockHttpClient.get(Uri.parse(Urls.currentWeatherByName(cityName))))
          .thenAnswer((_) async => http.Response(
              readJson('helpers/dummy_data/dummy_weather_response.json'), 200));

      // act
      final result = await weatherRemoteDataSourceImpl.getCurrentWeather(cityName);

      // assert
      expect(result, isA<WeatherModel>());
    });

    test('should throw a server exception when the response code is 404 or other', () async{
      // arrange
      when(mockHttpClient.get(Uri.parse(Urls.currentWeatherByName(cityName))))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final result = weatherRemoteDataSourceImpl.getCurrentWeather(cityName);

      // assert
      expect(result, throwsA(isA<ServerException>()));
    });

  });
}
