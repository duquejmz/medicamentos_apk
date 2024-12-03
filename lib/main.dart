import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MedicineSearchApp());
}

class MedicineSearchApp extends StatelessWidget {
  const MedicineSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 140, 220, 115)),
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _results = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _searchMedicine(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final uri = Uri.parse('https://www.datos.gov.co/resource/ec4u-mzse.json')
          .replace(queryParameters: {'nombre_comercial': query});

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
        final decodedData = json.decode(response.body);
        setState(() {
          _results = decodedData;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _error = 'No se encontró el recurso solicitado';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Error del servidor: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().contains('SocketException')
            ? 'Error de conexión: Verifica tu conexión a internet'
            : 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Búsqueda de Medicamentos'),
        backgroundColor: Colors.blue.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre del medicamento',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMedicine(_controller.text),
                ),
              ),
              onSubmitted: _searchMedicine,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final medicine = _results[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre Comercial: ${medicine['nombre_comercial'] ?? 'No disponible'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Principio Activo: ${medicine['principio_activo'] ?? 'No disponible'}'),
                            Text('Fabricante: ${medicine['fabricante'] ?? 'No disponible'}'),
                            Text('Unidad de Dispensación: ${medicine['unidad_de_dispensacion'] ?? 'No disponible'}'),
                            Text('Concentración: ${medicine['concentracion'] ?? 'No disponible'}'),
                            Text('Unidad Base: ${medicine['unidad_base'] ?? 'No disponible'}'),
                            Text('Precio por Tableta: \$${medicine['precio_por_tableta'] ?? 'No disponible'}'),
                            Text('Factor de Precio: ${medicine['factoresprecio'] ?? 'No disponible'}'),
                            Text('Número Factor: ${medicine['numerofactor'] ?? 'No disponible'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}