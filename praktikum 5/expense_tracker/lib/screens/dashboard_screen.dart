import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userEmail; 

  const DashboardScreen({super.key, required this.userEmail});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _balance = 0.0;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    final balance = await DatabaseHelper.instance.calculateBalance(widget.userEmail);
    final transactions = await DatabaseHelper.instance.getTransactions(widget.userEmail);
    
    setState(() {
      _balance = balance;
      _transactions = transactions;
    });
  }

  String _formatCurrency(dynamic amount) {
    double value = 0.0;
    if (amount is double) {
      value = amount;
    } else if (amount is int) {
      value = amount.toDouble();
    } else if (amount is String) {
      String clean = amount.replaceAll('.', '').replaceAll(',', '.');
      value = double.tryParse(clean) ?? 0.0;
    }

    String result = value.toStringAsFixed(0);
    RegExp regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    result = result.replaceAllMapped(regExp, (Match m) => '${m[1]}.');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    String displayName = widget.userEmail.contains('@') 
        ? widget.userEmail.split('@')[0] 
        : widget.userEmail;
    if (displayName.isNotEmpty) {
      displayName = displayName[0].toUpperCase() + displayName.substring(1);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(userEmail: widget.userEmail),
            ),
          );
          if (result == true) {
            _loadDashboardData();
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, $displayName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildBalanceCard(),
            const SizedBox(height: 20),
            const Text('Transaksi Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      elevation: 4,
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saldo Utama', style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 8),
            // Saldo utama diformat pakai titik ribuan
            Text('Rp ${_formatCurrency(_balance)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Belum ada transaksi.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final recentTransactions = _transactions.take(5).toList();

    return Card(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentTransactions.length,
        itemBuilder: (context, index) {
          final tx = recentTransactions[index];
          final isIncome = tx['type'].toString().toLowerCase() == 'pemasukan';
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isIncome ? Colors.green : Colors.orange,
              child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
            ),
            title: Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(tx['type']),
            trailing: Text(
              '${isIncome ? "+ " : "- "}Rp ${_formatCurrency(tx['amount'])}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}