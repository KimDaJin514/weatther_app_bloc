import 'package:get_it/get_it.dart';
import 'package:weather_app/data/data_sources/remote_data_source.dart';
import 'package:weather_app/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';
import 'package:weather_app/domain/usecases/get_current_weather.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void setupLocator() {

  // bloc
  // registerFactory : 매번 새로운 인스턴스 생성
  locator.registerFactory(() => WeatherBloc(locator()));

  // usecase
  // // registerSingleton : 하나의 인스턴스 사용
  locator.registerLazySingleton(() => GetCurrentWeatherUseCase(locator()));

  // repository
  locator.registerLazySingleton<WeatherRepository>(() => WeatherRepositoryImpl(locator()));

  // data source
  locator.registerLazySingleton<WeatherRemoteDataSource>(() => WeatherRemoteDataSourceImpl(client: locator()));

  // external
  locator.registerLazySingleton(() => http.Client());


}