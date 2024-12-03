import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medicine.dart';

class ApiServiceMedicine {
  static const String baseUrl = 'https://www.datos.gov.co/resource/ec4u-mzse.json';

  Future<List<Medicine>> searchMedicines(String query) async {
    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {'nombre_comercial': query}
      );

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Flutter_Medicine_Search/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('La conexión ha excedido el tiempo de espera');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Medicine.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('No se encontró el recurso solicitado');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Error de conexión: Verifica tu conexión a internet');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }
}