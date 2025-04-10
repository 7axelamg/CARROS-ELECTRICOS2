import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evaluacion2/services/auth_service.dart';
import 'package:evaluacion2/screens/car_list_screen.dart';
import 'package:evaluacion2/screens/qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;
    
    setState(() => _isLoggingOut = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logout();
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electric Car App'),
        actions: [
          IconButton(
            icon: _isLoggingOut
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.logout),
            onPressed: _isLoggingOut ? null : _handleLogout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Ver mis Carros'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QrScannerScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Escanear QR'),
            ),
          ],
        ),
      ),
    );
  }
}