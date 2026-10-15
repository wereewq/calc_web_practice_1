import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../logic/calculator.dart';
import '../logic/currency.dart';

class ResultScreen extends StatelessWidget {
  final String title;
  final String backPath;
  final String subtitle;
  final bool isError;
  final String displayValue;

  const ResultScreen({
    super.key,
    required this.title,
    required this.backPath,
    required this.subtitle,
    required this.isError,
    required this.displayValue,
  });

  factory ResultScreen.forCalculator({
    required String? rawA,
    required String? rawOp,
    required String? rawB,
  }) {
    final calc = calculate(rawA, rawOp, rawB);
    final expression = '${rawA ?? "?"} ${rawOp ?? "?"} ${rawB ?? "?"}';

    return switch (calc) {
      CalcSuccess(:final formatted) => ResultScreen(
          title: 'Результат вычисления',
          backPath: '/calculator',
          subtitle: 'Выражение: $expression',
          isError: false,
          displayValue: formatted,
        ),
      CalcFailure(:final message) => ResultScreen(
          title: 'Ошибка вычисления',
          backPath: '/calculator',
          subtitle: 'Запрос: $expression',
          isError: true,
          displayValue: message,
        ),
    };
  }

  factory ResultScreen.forConverter({
    required String? from,
    required String? to,
    required String? amount,
  }) {
    final conv = convertCurrency(from: from, to: to, rawAmount: amount);
    final summary = '${amount ?? "?"} ${from ?? "?"} ➔ ${to ?? "?"}';

    return switch (conv) {
      CurrencySuccess(:final formatted) => ResultScreen(
          title: 'Результат конвертации',
          backPath: '/converter',
          subtitle: 'Направление: $summary',
          isError: false,
          displayValue: '$formatted $to',
        ),
      CurrencyFailure(:final message) => ResultScreen(
          title: 'Ошибка конвертации',
          backPath: '/converter',
          subtitle: 'Параметры: $summary',
          isError: true,
          displayValue: message,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(backPath),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              color: isError
                  ? Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isError ? Icons.error_outline : Icons.check_circle_outline,
                      size: 64,
                      color: isError
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SelectableText(
                      displayValue,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isError
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => context.go(backPath),
                      icon: const Icon(Icons.replay),
                      label: const Text('Вернуться назад'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}