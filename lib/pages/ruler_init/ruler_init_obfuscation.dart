import 'dart:convert';

class RulerInitObfuscation {
  static const String encryptedUrl =
      'BRsWGR9fQnAWRwsPAy9eCgwAZgIJXEEBBQMQCTkAGgIRXDEMGkYmDQRSGyE1';
  static const String encryptionKey = 'mobilem_ruler_init_v1';

  static String decodeUrl(String encryptedValue) {
    final keyBytes = utf8.encode(encryptionKey);
    final encryptedBytes = base64Decode(encryptedValue);
    final decodedBytes = List<int>.generate(
      encryptedBytes.length,
      (index) => encryptedBytes[index] ^ keyBytes[index % keyBytes.length],
    );
    return utf8.decode(decodedBytes);
  }
}
