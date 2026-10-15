import 'calculator.dart';

sealed class CurrencyResult {
  const CurrencyResult();
}

class CurrencySuccess extends CurrencyResult {
  final double value;
  final String formatted;
  const CurrencySuccess(this.value, this.formatted);
}

class CurrencyFailure extends CurrencyResult {
  final String message;
  const CurrencyFailure(this.message);
}

class CurrencyRates {
  // Базовая валюта: USD (не менее 5 валют по заданию)
  static const List<String> supportedCurrencies = ['USD', 'EUR', 'RUB', 'CNY', 'KZT'];

  static const Map<String, double> toUsdRate = {
    'USD': 1.0,
    'EUR': 1.08,
    'RUB': 0.011,
    'CNY': 0.14,
    'KZT': 0.0021,
  };
}

CurrencyResult convertCurrency({
  required String? from,
  required String? to,
  required String? rawAmount,
}) {
  if (from == null || to == null || rawAmount == null || rawAmount.trim().isEmpty) {
    return const CurrencyFailure('Не заданы все параметры для конвертации');
  }

  final upperFrom = from.toUpperCase().trim();
  final upperTo = to.toUpperCase().trim();

  if (!CurrencyRates.supportedCurrencies.contains(upperFrom) ||
      !CurrencyRates.supportedCurrencies.contains(upperTo)) {
    return const CurrencyFailure('Указана неподдерживаемая валюта');
  }

  final amount = double.tryParse(rawAmount.replaceAll(',', '.').trim());
  if (amount == null) {
    return const CurrencyFailure('Сумма должна быть корректным числом');
  }
  if (amount < 0) {
    return const CurrencyFailure('Сумма не может быть отрицательной');
  }

  final inUsd = amount * CurrencyRates.toUsdRate[upperFrom]!;
  final result = inUsd / CurrencyRates.toUsdRate[upperTo]!;

  return CurrencySuccess(result, formatNumber(result));
}