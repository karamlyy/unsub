import 'package:unsub/data/service/crypto-service/crypto_service.dart';

class PaymentValueCrypto {
  static const _prefix = 'enc';

  static Future<String> encryptToValue(String plaintext) async {
    final crypto = CryptoService();
    final e = await crypto.encryptString(plaintext);
    return '$_prefix:${e['keyId']}:${e['alg']}:${e['nonce']}:${e['tag']}:${e['ciphertext']}';
  }

  static bool isEncrypted(String? value) {
    return value != null && value.startsWith('$_prefix:');
  }

  static Future<String?> tryDecryptValue(String? value) async {
    if (value == null || !isEncrypted(value)) return value; // plaintext ola bilər
    final parts = value.split(':');
    if (parts.length != 6) return null; // uyğunsuz format
    final keyId = parts[1]; // lazımdırsa istifadə et
    final alg   = parts[2]; // "AES-GCM"
    final nonce = parts[3];
    final tag   = parts[4];
    final ct    = parts[5];
    if (alg != 'AES-GCM') return null;
    final crypto = CryptoService();
    return crypto.decryptString(nonceB64: nonce, tagB64: tag, ciphertextB64: ct);
  }
}

/// UI üçün təhlükəsiz mask
String maskLast4(String? v) {
  if (v == null || v.isEmpty) return '****';
  if (v.length <= 2) return '****';
  return '****${v.substring(v.length - 2)}'; // və ya sadəcə '****$v'
}