import 'package:calc_web/logic/calculator.dart';
import 'package:calc_web/logic/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Тестирование Calculator', () {
    test('Сложение чисел с плавающей точкой', () {
      final res = calculate('10.5', '+', '4.5');
      expect(res, isA<CalcSuccess>());
      expect((res as CalcSuccess).formatted, '15');
    });

    test('Деление на ноль возвращает ошибку', () {
      final res = calculate('42', '/', '0');
      expect(res, isA<CalcFailure>());
      expect((res as CalcFailure).message, 'Деление на ноль невозможно');
    });

    test('Нечисловой параметр приводит к ошибке', () {
      final res = calculate('abc', '*', '5');
      expect(res, isA<CalcFailure>());
      expect((res as CalcFailure).message, 'В адресе переданы нечисловые значения');
    });

    test('Неизвестная операция обрабатывается', () {
      final res = calculate('10', '^', '2');
      expect(res, isA<CalcFailure>());
      expect((res as CalcFailure).message, 'Неизвестная математическая операция');
    });

    test('Округление дробей (исключение хвоста 3.3333333333333335)', () {
      final res = calculate('10', '/', '3');
      expect(res, isA<CalcSuccess>());
      expect((res as CalcSuccess).formatted, '3.333333');
    });
  });

  group('Тестирование Currency Converter', () {
    test('Корректная конвертация валюты', () {
      final res = convertCurrency(from: 'USD', to: 'USD', rawAmount: '100');
      expect(res, isA<CurrencySuccess>());
      expect((res as CurrencySuccess).formatted, '100');
    });

    test('Отрицательная сумма блокируется', () {
      final res = convertCurrency(from: 'EUR', to: 'RUB', rawAmount: '-50');
      expect(res, isA<CurrencyFailure>());
      expect((res as CurrencyFailure).message, 'Сумма не может быть отрицательной');
    });

    test('Неизвестная валюта вызывает ошибку', () {
      final res = convertCurrency(from: 'GBP', to: 'USD', rawAmount: '100');
      expect(res, isA<CurrencyFailure>());
      expect((res as CurrencyFailure).message, 'Указана неподдерживаемая валюта');
    });
  });
}