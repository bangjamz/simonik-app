import 'dart:math';
import 'package:uuid/uuid.dart';

class CodeGenerator {
  static final _uuid = Uuid();
  static final _random = Random();

  // Generate unique session code (e.g., MONEV-2024-ABCD-1234)
  static String generateSessionCode() {
    final year = DateTime.now().year;
    final letters = _generateRandomString(4, useNumbers: false);
    final numbers = _generateRandomString(4, useLetters: false);
    return 'MONEV-$year-$letters-$numbers';
  }

  // Generate UUID
  static String generateUUID() {
    return _uuid.v4();
  }

  // Generate random string
  static String _generateRandomString(int length,
      {bool useLetters = true, bool useNumbers = true}) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';

    String chars = '';
    if (useLetters) chars += letters;
    if (useNumbers) chars += numbers;

    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
    ));
  }

  // Generate temporary password
  static String generateTempPassword() {
    return _generateRandomString(8);
  }
}
