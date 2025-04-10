import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_model.dart';

class ApiService {
  static const String _baseUrl = 'https://67f7d1812466325443eadd17.mockapi.io';

  Future<List<Car>> getCars() async {
    final response = await http.get(Uri.parse('$_baseUrl/carros'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Car.fromJson(json)).toList();
    }
    throw Exception('Error al cargar los carros');
  }

  Future<Car> getCarByQr(String qrCode) async {
    final response = await http.get(Uri.parse('$_baseUrl/carros/$qrCode'));
    if (response.statusCode == 200) {
      return Car.fromJson(json.decode(response.body));
    }
    throw Exception('Carro no encontrado');
  }
}