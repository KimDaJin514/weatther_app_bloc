import 'package:weather_app/domain/usecases/get_current_weather.dart';
import 'package:weather_app/presentation/bloc/weather_event.dart';
import 'package:weather_app/presentation/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;

  WeatherBloc(this._getCurrentWeatherUseCase) : super(WeatherEmpty()) {
    on<OnCityChanged>(
      onCityChange,
      transformer: debounce(const Duration(milliseconds: 500))
    );
  }

  void onCityChange(OnCityChanged event, Emitter emitter) async {
    emit(WeatherLoading());

    final result = await _getCurrentWeatherUseCase.execute(event.cityName);

    result.fold(
      (failure) {
        emit(WeatherLoadFailure(failure.message));
      },
      (data) {
        emit(WeatherLoaded(data));
      },
    );
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mappers) => events.debounceTime(duration).flatMap(mappers);
}