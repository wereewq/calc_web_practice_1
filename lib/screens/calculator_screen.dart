import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  String _operation = '+';
  static const _operations = ['+', '-', '*', '/'];

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Введите число';
    if (double.tryParse(value.replaceAll(',', '.').trim()) == null) {
      return 'Некорректное числовое значение';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final a = _aController.text.trim();
    final b = _bController.text.trim();
    final encodedOp = Uri.encodeComponent(_operation);

    // Передаем параметры через URL-адрес
    context.go('/calculator/result?a=$a&op=$encodedOp&b=$b');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
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
                      TextFormField(
                        controller: _aController,
                        decoration: const InputDecoration(
                          labelText: 'Первое число',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.looks_one_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _operation,
                        decoration: const InputDecoration(
                          labelText: 'Операция',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.functions),
                        ),
                        items: _operations
                            .map((op) => DropdownMenuItem(value: op, child: Text(op)))
                            .toList(),
                        onChanged: (value) => setState(() => _operation = value ?? '+'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bController,
                        decoration: const InputDecoration(
                          labelText: 'Второе число',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.looks_two_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Вычислить', style: TextStyle(fontSize: 16)),
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