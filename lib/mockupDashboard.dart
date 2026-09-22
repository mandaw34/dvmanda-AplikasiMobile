import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. WIDGET UTAMA
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(), // Halaman awal aplikasi
    );
  }
}

// 2. HALAMAN UTAMA (Scaffold)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 2: Layouting'),
        backgroundColor: Colors.blue,
      ),
      // Padding untuk memberikan jarak dari tepi layar
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingWidget(),     // Memanggil StatelessWidget
            SizedBox(height: 20), // Jarak vertikal
            BalanceCardWidget(), 
            SizedBox(height: 20), // Jarak vertikal
            ActionButtonsWidget(), // Memanggil StatelessWidget
            SizedBox(height: 20), // Jarak vertikal
            RecentTransactionsWidget(), // Memanggil StatelessWidget
          ],
        ),
      ),
    );
  }
}

// 3. STATELESS WIDGET (Sapaan Pengguna)
class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Ikon Profil
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 30, color: Colors.white),
        ),
        const SizedBox(width: 12),
        // Teks Sapaan
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Halo, Manda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Selamat datang kembali!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 4. STATEFUL WIDGET (Kartu Saldo dengan Toggle)
class BalanceCardWidget extends StatefulWidget {
  const BalanceCardWidget({super.key});

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  // Variabel State: Menyimpan status apakah saldo terlihat atau disensor
  bool _isBalanceVisible = true;

  // Fungsi untuk mengubah state
  void _toggleVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible; // Membalik nilai boolean (true <-> false)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.teal,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas kartu: Teks "Saldo Utama" & Tombol Ikon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saldo Utama',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                // Tombol Mata
                IconButton(
                  icon: Icon(
                    // Logika if-else singkat (Ternary Operator)
                    _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleVisibility, // Memanggil fungsi ubah state
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Teks Nominal Saldo
            Text(
              // Logika if-else untuk menampilkan saldo atau sensor
              _isBalanceVisible ? 'Rp 5.000.000' : 'Rp *********',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12), // Jarak ke nomor rekening
            // Teks Statis No. Rekening (Tambahan Tugas 2)
            const Text(
              'No. Rekening: 1234-5678',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,),
            ),
          ],
        ),
      ),
    );
  }
}

    // widget tombol aksi
    class ActionButtonsWidget extends StatelessWidget {
      const ActionButtonsWidget({super.key});

      @override
      Widget build(BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(Icons.arrow_downward, 'Pemasukan', Colors.green),
            _buildActionButton(Icons.arrow_upward, 'Pengeluaran', Colors.red),
            _buildActionButton(Icons.swap_horiz, 'Transfer', Colors.blue),
          ],
        );
      }

      Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// widget daftar transaksi
class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaksi Terakhir',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.fastfood, color: Colors.white),
                ),
                title: Text('Makan Siang'),
                subtitle: Text('Hari Ini'),
                trailing: Text(
                  '- Rp 50.000',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.work, color: Colors.white),
                ),
                title: Text('Gaji Bulanan'),
                subtitle: Text('Hari Ini'),
                trailing: Text(
                  '+ Rp 5.000.000',
                  style: TextStyle(color: Colors.green),
                ),
              ),
               const Divider(height: 1),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.work, color: Colors.white),
                ),
                title: Text('Kopi Kenangan'),
                subtitle: Text('Hari Ini'),
                trailing: Text(
                  '+ Rp 25.000',
                  style: TextStyle(color: Colors.red),
                ),
              ),
               const Divider(height: 1),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.work, color: Colors.white),
                ),
                title: Text('Makeup'),
                subtitle: Text('Hari Ini'),
                trailing: Text(
                  '+ Rp 300.000',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}