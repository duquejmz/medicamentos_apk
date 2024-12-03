import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/api_service_medicine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiServiceMedicine _apiService = ApiServiceMedicine();
  final TextEditingController _searchController = TextEditingController();
  List<Medicine> _medicines = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _searchMedicines(String query) async {
    if (query.isEmpty) {
      setState(() {
        _medicines = [];
        _error = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final results = await _apiService.searchMedicines(query);
      setState(() {
        _medicines = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Búsqueda de Medicamentos'),
        backgroundColor: const Color.fromARGB(255, 138, 234, 151),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nombre del medicamento',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMedicines(_searchController.text),
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: _searchMedicines,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = _medicines[index];
                    return Card(
                      child: ListTile(
                        title: Text(medicine.nombreComercial),
                        subtitle: Text(medicine.principioActivo),
                        onTap: () => _showMedicineDetails(medicine),
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

  void _showMedicineDetails(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(medicine.nombreComercial),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Principio activo: ${medicine.principioActivo}'),
              Text('Titular: ${medicine.titular}'),
              Text('Registro sanitario: ${medicine.registroSanitario}'),
              Text('Forma farmacéutica: ${medicine.formaFarmaceutica}'),
              Text('Presentación: ${medicine.presentacionComercial}'),
              Text('Estado registro: ${medicine.estadoRegistro}'),
              Text('Fecha vencimiento: ${medicine.fechaVencimiento}'),
              Text('Modalidad: ${medicine.modalidad}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
