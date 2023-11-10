
import 'package:encrypt/encrypt.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

import '../service/secured_shared_preference.dart';


FlutterLocalSecuredStorage storage = FlutterLocalSecuredStorage();

class EncryptionDecryption {
  static final key = encrypt.Key.fromUtf8(decodePublicKey());
  static final iv = encrypt.IV.fromUtf8(decodePublicIV());
  
  static final userkey = encrypt.Key.fromUtf8(Globalstates.userKey);
  static final userIv = encrypt.IV.fromUtf8(Globalstates.userIV);
  static final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: AESMode.cbc));
  static final userEncrypter =
      encrypt.Encrypter(encrypt.AES(userkey, mode: AESMode.cbc));

  static decodePublicKey() {
    final base64Str = "QU1CVUxBTkNFU0VDS0VZUw==";
    return utf8.decode(base64.decode(base64Str));
  }

  static decodePublicIV() {
    final base64Str = "U1lFQ0tFU0VDTkFMVUJNQQ==";
    return utf8.decode(base64.decode(base64Str));
  }

  static encryptAES(text) {
    return encrypter.encrypt(text, iv: iv);
  }

  static String decryptAES(text) {
    return encrypter.decrypt(text, iv: iv);
  }

  static userEncryptAES(text) {
    return userEncrypter.encrypt(text, iv: userIv);
  }

  static String userDecryptAES(text) {
    return userEncrypter.decrypt(text, iv: userIv);
  }
}

abstract class Globalstates {
  
  static String userKey="";
  static String userIV="";
}