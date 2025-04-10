import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evaluacion2/models/car_model.dart';
import 'package:evaluacion2/services/api_service.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late Future<List<Car>> _carsFuture;

  @override
  void initState() {
    super.initState();
    _carsFuture = Provider.of<ApiService>(context, listen: false).getCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Carros'),
      ),
      body: FutureBuilder<List<Car>>(
        future: _carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los carros'));
          }
          
          final cars = snapshot.data ?? [];
          if (cars.isEmpty) {
            return const Center(child: Text('No hay carros disponibles'));
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Placa: ${car.id}'),
                  subtitle: Text('Conductor: ${car.conductor ?? 'N/A'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}