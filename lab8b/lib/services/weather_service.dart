
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  Future<Weather> fetchWeatherForCity(String city) async {
    if (city.trim().isEmpty) {
      throw Exception('Vui lòng nhập tên thành phố.');
    }

    try {
      final geoUri = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {
          'name': city.trim(),
          'count': '1',
          'language': 'vi',
          'format': 'json',
        },
      );

      final geoResponse = await http
          .get(geoUri)
          .timeout(const Duration(seconds: 15));

      if (geoResponse.statusCode != 200) {
        throw Exception('Không thể tìm thành phố.');
      }

      final geoData =
      jsonDecode(geoResponse.body) as Map<String, dynamic>;

      final results = geoData['results'] as List?;

      if (results == null || results.isEmpty) {
        throw Exception('Không tìm thấy thành phố.');
      }

      final place = results.first as Map<String, dynamic>;
      final latitude = place['latitude'] as num;
      final longitude = place['longitude'] as num;
      final cityName = place['name'] as String;

      final weatherUri = Uri.https(
        'api.open-meteo.com',
        '/v1/forecast',
        {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
          'timezone': 'auto',
        },
      );

      final weatherResponse = await http
          .get(weatherUri)
          .timeout(const Duration(seconds: 15));

      if (weatherResponse.statusCode != 200) {
        throw Exception('Không thể tải dữ liệu thời tiết.');
      }

      final weatherData =
      jsonDecode(weatherResponse.body) as Map<String, dynamic>;

      final current =
      weatherData['current'] as Map<String, dynamic>?;

      if (current == null) {
        throw Exception('Dữ liệu thời tiết không hợp lệ.');
      }

      return Weather.fromJson(cityName, current);
    } on TimeoutException {
      throw Exception('Kết nối quá lâu. Vui lòng thử lại.');
    } on http.ClientException {
      throw Exception('Lỗi mạng. Hãy kiểm tra Internet.');
    } on FormatException {
      throw Exception('Không thể đọc dữ liệu từ máy chủ.');
    }
  }
}
