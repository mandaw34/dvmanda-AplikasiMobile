import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  final String userEmail; 

  const AddTransactionScreen({super.key, required this.userEmail});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  
  
  String _selectedType = 'Pengeluaran'; 
  final List<String> _types = ['Pemasukan', 'Pengeluaran'];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.instance.insertTransaction({
        'userEmail': widget.userEmail,
        'title': _titleController.text,
        'amount': _amountController.text,
        'type': _selectedType,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi Berhasil Disimpan!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catat Transaksi"), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Judul Transaksi (Contoh: Gaji / Makan)", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal (Rp)", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: "Tipe Transaksi", border: OutlineInputBorder()),
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(value: type, child: Text(type));
                }).toList(),
                onChanged: (String? newValue) => setState(() => _selectedType = newValue!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _saveTransaction,
                child: const Text("Simpan", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}