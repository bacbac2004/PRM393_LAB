
import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _service = WeatherService();
  final TextEditingController _controller =
  TextEditingController(text: 'Hanoi');

  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _service.fetchWeatherForCity('Hanoi');
  }

  void _searchWeather() {
    final city = _controller.text.trim();

    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên thành phố.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _weatherFuture = _service.fetchWeatherForCity(city);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title),
              const SizedBox(height: 6),
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F6FC),
      appBar: AppBar(
        title: const Text('Weather Companion'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onSubmitted: (_) => _searchWeather(),
                decoration: InputDecoration(
                  hintText: 'Nhập tên thành phố',
                  prefixIcon: const Icon(Icons.location_city),
                  suffixIcon: IconButton(
                    onPressed: _searchWeather,
                    icon: const Icon(Icons.search),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<Weather>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              snapshot.error
                                  .toString()
                                  .replaceFirst('Exception: ', ''),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _searchWeather,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      );
                    }

                    final weather = snapshot.data;

                    if (weather == null) {
                      return const Center(
                        child: Text('Không có dữ liệu thời tiết.'),
                      );
                    }

                    return ListView(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                Text(
                                  weather.city,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  weather.weatherCode == 0
                                      ? Icons.wb_sunny
                                      : Icons.cloud,
                                  size: 64,
                                  color: Colors.orange,
                                ),
                                Text(
                                  '${weather.temperature.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  weather.description,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Cảm giác như ${weather.feelsLike.toStringAsFixed(1)}°C',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _infoCard(
                              Icons.water_drop,
                              'Độ ẩm',
                              '${weather.humidity}%',
                            ),
                            _infoCard(
                              Icons.air,
                              'Tốc độ gió',
                              '${weather.windSpeed} km/h',
                            ),
                          ],
                        ),
                        Card(
                          color: Colors.amber.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Gợi ý cho bạn',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(weather.recommendation),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
