import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CryptoService {
  static const _keyStorageKey = 'app_master_key_v1';
  static const _keySize = 32;   // 256-bit
  static const _nonceSize = 12; // 96-bit for GCM

  final FlutterSecureStorage _secureStorage;
  final AesGcm _aesgcm;

  CryptoService({
    FlutterSecureStorage? secureStorage,
    AesGcm? aesgcm,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _aesgcm = aesgcm ?? AesGcm.with256bits();

  Future<SecretKey> _getOrCreateKey() async {
    String? b64 = await _secureStorage.read(key: _keyStorageKey);
    if (b64 == null) {
      final bytes = List<int>.generate(_keySize, (_) => Random.secure().nextInt(256));
      b64 = base64Encode(bytes);
      await _secureStorage.write(key: _keyStorageKey, value: b64);
    }
    return SecretKey(base64Decode(b64));
  }

  Future<Map<String, String>> encryptString(String plaintext) async {
    final key = await _getOrCreateKey();
    final nonce = List<int>.generate(_nonceSize, (_) => Random.secure().nextInt(256));
    final sb = await _aesgcm.encrypt(
      utf8.encode(plaintext),
      secretKey: key,
      nonce: nonce,
    );
    return {
      'alg': 'AES-GCM',
      'keyId': 'v1',
      'nonce': base64Encode(sb.nonce),
      'tag': base64Encode(sb.mac.bytes),
      'ciphertext': base64Encode(sb.cipherText),
    };
  }

  Future<String> decryptString({
    required String nonceB64,
    required String tagB64,
    required String ciphertextB64,
  }) async {
    final key = await _getOrCreateKey();
    final secretBox = SecretBox(
      base64Decode(ciphertextB64),
      nonce: base64Decode(nonceB64),
      mac: Mac(base64Decode(tagB64)),
    );
    final clear = await _aesgcm.decrypt(secretBox, secretKey: key);
    return utf8.decode(clear);
  }
}