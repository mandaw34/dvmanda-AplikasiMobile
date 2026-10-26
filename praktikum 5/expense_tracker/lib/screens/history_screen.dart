import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  final String userEmail; 

  const HistoryScreen({super.key, required this.userEmail});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _transactions = [];

  void _loadData() async {
    final data = await DatabaseHelper.instance.getTransactions(widget.userEmail);
    setState(() {
      _transactions = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    _loadData(); 

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: _transactions.isEmpty
          ? const Center(child: Text('Belum ada transaksi tersimpan.'))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final item = _transactions[index];
                final isIncome = item['type'].toString().toLowerCase() == 'pemasukan';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green : Colors.red,
                      child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
                    ),
                    title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['type']),
                    trailing: Text(
                      '${isIncome ? "+ " : "- "}Rp ${item['amount']}',
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}