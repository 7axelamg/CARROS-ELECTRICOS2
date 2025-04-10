import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:evaluacion2/models/car_model.dart';
import 'package:evaluacion2/services/api_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  Car? _car;
  bool _isLoading = false;

  Future<void> _scanQR() async {
    try {
      setState(() => _isLoading = true);
      
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      
      if (qrCode == '-1') {
        setState(() => _isLoading = false);
        return;
      }

      final apiService = Provider.of<ApiService>(context, listen: false);
      final car = await apiService.getCarByQr(qrCode);
      
      if (!mounted) return;
      
      setState(() {
        _car = car;
        _isLoading = false;
      });

      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Carro encontrado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Placa: ${car.id}'),
              const SizedBox(height: 8),
              Text('Conductor: ${car.conductor ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner QR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _scanQR,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Escanear QR'),
            ),
            const SizedBox(height: 20),
            if (_car != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Placa: ${_car!.id}'),
                      const SizedBox(height: 8),
                      Text('Conductor: ${_car!.conductor ?? 'N/A'}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}