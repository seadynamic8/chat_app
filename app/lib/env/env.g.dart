// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// SecureDotEnvAnnotationGenerator
// **************************************************************************

class _$Env extends Env {
  const _$Env(this._encryptionKey, this._iv) : super._();

  final String _encryptionKey;
  final String _iv;
  static final Uint8List _encryptedValues = Uint8List.fromList([
    31,
    12,
    74,
    41,
    115,
    51,
    13,
    196,
    215,
    168,
    210,
    115,
    22,
    226,
    66,
    115,
    117,
    98,
    104,
    98,
    5,
    34,
    187,
    58,
    68,
    110,
    22,
    113,
    244,
    8,
    223,
    134,
    41,
    77,
    151,
    246,
    110,
    106,
    172,
    96,
    112,
    176,
    231,
    112,
    155,
    213,
    58,
    214,
    244,
    30,
    193,
    81,
    19,
    39,
    61,
    228,
    206,
    138,
    224,
    130,
    118,
    58,
    175,
    91,
    212,
    76,
    208,
    145,
    56,
    211,
    37,
    22,
    7,
    166,
    184,
    172,
    18,
    230,
    39,
    49,
    195,
    32,
    157,
    220,
    5,
    47,
    31,
    236,
    86,
    249,
    61,
    44,
    209,
    110,
    75,
    246,
    115,
    109,
    27,
    55,
    245,
    212,
    253,
    110,
    194,
    146,
    240,
    68,
    239,
    35,
    144,
    246,
    217,
    92,
    5,
    94,
    161,
    202,
    170,
    84,
    105,
    32,
    83,
    90,
    176,
    130,
    2,
    18,
    225,
    206,
    185,
    101,
    21,
    3,
    83,
    23,
    235,
    184,
    135,
    47,
    46,
    131,
    96,
    173,
    200,
    104,
    162,
    108,
    193,
    12,
    49,
    199,
    170,
    187,
    65,
    226,
    176,
    103,
    28,
    236,
    136,
    11,
    245,
    134,
    219,
    169,
    194,
    52,
    15,
    46,
    117,
    122,
    98,
    15,
    193,
    40,
    173,
    34,
    156,
    140,
    30,
    231,
    134,
    204,
    73,
    38,
    248,
    225,
    71,
    236,
    153,
    21,
    210,
    92,
    243,
    152,
    86,
    3,
    148,
    42,
    79,
    190,
    87,
    18,
    126,
    225,
    241,
    5,
    215,
    251,
    4,
    80,
    36,
    128,
    13,
    123,
    91,
    99,
    118,
    211,
    9,
    61,
    79,
    165,
    8,
    248,
    254,
    49,
    90,
    122,
    162,
    145,
    148,
    189,
    230,
    177,
    15,
    75,
    152,
    29,
    210,
    10,
    216,
    125,
    51,
    186,
    35,
    51,
    183,
    236,
    180,
    151,
    36,
    41,
    224,
    129,
    199,
    28,
    180,
    242,
    218,
    98,
    24,
    245,
    106,
    237,
    159,
    140,
    208,
    218,
    37,
    1,
    41,
    114,
    7,
    237,
    194,
    98,
    227,
    205,
    129,
    0,
    219,
    122,
    235,
    239,
    192,
    95,
    132,
    62,
    157,
    202,
    67,
    85,
    141,
    137,
    110,
    9,
    134,
    170,
    212,
    110,
    143,
    77
  ]);
  @override
  String get supabaseUrl => _get('SUPABASE_URL');

  @override
  String get supabaseKey => _get('SUPABASE_KEY');

  T _get<T>(
    String key, {
    T Function(String)? fromString,
  }) {
    T _parseValue(String strValue) {
      if (T == String) {
        return (strValue) as T;
      } else if (T == int) {
        return int.parse(strValue) as T;
      } else if (T == double) {
        return double.parse(strValue) as T;
      } else if (T == bool) {
        return (strValue.toLowerCase() == 'true') as T;
      } else if (T == Enum || fromString != null) {
        if (fromString == null) {
          throw Exception('fromString is required for Enum');
        }

        return fromString(strValue.split('.').last);
      }

      throw Exception('Type ${T.toString()} not supported');
    }

    final encryptionKey = base64.decode(_encryptionKey.trim());
    final iv = base64.decode(_iv.trim());
    final decrypted =
        AESCBCEncryper.aesCbcDecrypt(encryptionKey, iv, _encryptedValues);
    final jsonMap = json.decode(decrypted) as Map<String, dynamic>;
    if (!jsonMap.containsKey(key)) {
      throw Exception('Key $key not found in .env file');
    }

    final encryptedValue = jsonMap[key] as String;
    final decryptedValue = AESCBCEncryper.aesCbcDecrypt(
      encryptionKey,
      iv,
      base64.decode(encryptedValue),
    );
    return _parseValue(decryptedValue);
  }
}
