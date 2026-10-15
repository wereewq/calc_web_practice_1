import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/currency.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String _from = 'USD';
  String _to = 'RUB';
  bool _isLoadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPair();
  }

  Future<void> _loadSavedPair() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _from = prefs.getString('conv_from') ?? 'USD';
      _to = prefs.getString('conv_to') ?? 'RUB';
      _isLoadingPrefs = false;
    });
  }

  Future<void> _saveSelectedPair(String from, String to) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('conv_from', from);
    await prefs.setString('conv_to', to);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = _amountController.text.trim();
    _saveSelectedPair(_from, _to);

    context.go('/converter/result?from=$_from&to=$_to&amount=$amount');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPrefs) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер валют'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _from,
                        decoration: const InputDecoration(
                          labelText: 'Исходная валюта',
                          border: OutlineInputBorder(),
                        ),
                        items: CurrencyRates.supportedCurrencies
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _from = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _to,
                        decoration: const InputDecoration(
                          labelText: 'Целевая валюта',
                          border: OutlineInputBorder(),
                        ),
                        items: CurrencyRates.supportedCurrencies
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _to = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Сумма',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Введите сумму';
                          final n = double.tryParse(value.replaceAll(',', '.').trim());
                          if (n == null) return 'Введите корректное число';
                          if (n < 0) return 'Сумма не может быть отрицательной';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Конвертировать', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}