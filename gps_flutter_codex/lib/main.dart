import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPS Flutter Codex',
      home: const GPSPage(),
    );
  }
}

class GPSPage extends StatefulWidget {
  const GPSPage({super.key});

  @override
  State<GPSPage> createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {
  String latitud = "No disponible";
  String longitud = "No disponible";

  Future<void> obtenerUbicacion() async {
    bool servicioHabilitado;
    LocationPermission permiso;

    servicioHabilitado = await Geolocator.isLocationServiceEnabled();

    if (!servicioHabilitado) {
      setState(() {
        latitud = "GPS desactivado";
        longitud = "GPS desactivado";
      });
      return;
    }

    permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.deniedForever) {
      setState(() {
        latitud = "Permiso denegado";
        longitud = "Permiso denegado";
      });
      return;
    }

    Position posicion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitud = posicion.latitude.toString();
      longitud = posicion.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Flutter Codex'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitud: $latitud'),
            const SizedBox(height: 10),
            Text('Longitud: $longitud'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: obtenerUbicacion,
              child: const Text('Obtener Ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}