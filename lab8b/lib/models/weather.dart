
class Weather {
  final String city;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;

  Weather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory Weather.fromJson(
      String city,
      Map<String, dynamic> json,
      ) {
    return Weather(
      city: city,
      temperature: (json['temperature_2m'] as num).toDouble(),
      feelsLike: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
    );
  }

  String get description {
    if (weatherCode == 0) return 'Trời quang';
    if ([1, 2].contains(weatherCode)) return 'Ít mây';
    if (weatherCode == 3) return 'Nhiều mây';
    if ([45, 48].contains(weatherCode)) return 'Có sương mù';
    if ([51, 53, 55, 61, 63, 65, 80, 81, 82]
        .contains(weatherCode)) {
      return 'Có mưa';
    }
    if ([71, 73, 75, 77, 85, 86].contains(weatherCode)) {
      return 'Có tuyết';
    }
    if ([95, 96, 99].contains(weatherCode)) return 'Có dông';
    return 'Thời tiết thay đổi';
  }

  String get recommendation {
    if ([51, 53, 55, 61, 63, 65, 80, 81, 82, 95, 96, 99]
        .contains(weatherCode)) {
      return 'Nên mang ô hoặc áo mưa khi ra ngoài.';
    }
    if (temperature >= 35) {
      return 'Trời nóng, nên hạn chế hoạt động ngoài trời.';
    }
    if (temperature <= 10) {
      return 'Trời lạnh, hãy mặc đủ ấm.';
    }
    if (windSpeed >= 30) {
      return 'Gió mạnh, hãy cẩn thận khi ra ngoài.';
    }
    return 'Thời tiết khá thuận lợi cho hoạt động ngoài trời.';
  }
}
