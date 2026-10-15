sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  final double value;
  final String formatted;
  const CalcSuccess(this.value, this.formatted);
}

class CalcFailure extends CalcResult {
  final String message;
  const CalcFailure(this.message);
}

String formatNumber(double number) {
  if (number.isInfinite || number.isNaN) return number.toString();
  final fixed = number.toStringAsFixed(6);
  final trimmed = fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  return trimmed;
}

CalcResult calculate(String? rawA, String? rawOp, String? rawB) {
  if (rawA == null || rawA.trim().isEmpty || rawB == null || rawB.trim().isEmpty) {
    return const CalcFailure('Отсутствуют обязательные параметры чисел');
  }

  final a = double.tryParse(rawA.replaceAll(',', '.').trim());
  final b = double.tryParse(rawB.replaceAll(',', '.').trim());

  if (a == null || b == null) {
    return const CalcFailure('В адресе переданы нечисловые значения');
  }

  final op = rawOp?.trim();
  return switch (op) {
    '+' => CalcSuccess(a + b, formatNumber(a + b)),
    '-' => CalcSuccess(a - b, formatNumber(a - b)),
    '*' => CalcSuccess(a * b, formatNumber(a * b)),
    '/' => b == 0
        ? const CalcFailure('Деление на ноль невозможно')
        : CalcSuccess(a / b, formatNumber(a / b)),
    _ => const CalcFailure('Неизвестная математическая операция'),
  };
}