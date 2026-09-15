import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator Kabataku',
      home: const KalkulatorScreen(),
    );
  }
}

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final TextEditingController _angka1Controller = TextEditingController();
  final TextEditingController _angka2Controller = TextEditingController();
  String _hasil = '0';

  void _hitung(String operasi) {
    double? angka1 = double.tryParse(_angka1Controller.text);
    double? angka2 = double.tryParse(_angka2Controller.text);

    if (angka1 == null || angka2 == null) {
      setState(() {
        _hasil = 'Masukkan angka yang valid!';
      });
      return;
    }

    setState(() {
      switch (operasi) {
        case 'tambah':
          _hasil = (angka1 + angka2).toString();
          break;
        case 'kurang':
          _hasil = (angka1 - angka2).toString();
          break;
        case 'kali':
          _hasil = (angka1 * angka2).toString();
          break;
        case 'bagi':
          if (angka2 == 0) {
            _hasil = 'Tidak bisa dibagi 0!';
          } else {
            _hasil = (angka1 / angka2).toString();
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Kabataku Praktikum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _angka1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Angka Pertama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _angka2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Angka Kedua',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _hitung('tambah'),
                  child: const Text('+ Tambah'),
                ),
                ElevatedButton(
                  onPressed: () => _hitung('kurang'),
                  child: const Text('- Kurang'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _hitung('kali'),
                  child: const Text('× Kali'),
                ),
                ElevatedButton(
                  onPressed: () => _hitung('bagi'),
                  child: const Text('÷ Bagi'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Hasil: $_hasil',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}