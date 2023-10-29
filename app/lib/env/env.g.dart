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
    180,
    13,
    38,
    171,
    227,
    110,
    128,
    2,
    143,
    18,
    102,
    249,
    125,
    88,
    85,
    15,
    163,
    32,
    40,
    117,
    253,
    214,
    198,
    116,
    166,
    220,
    250,
    133,
    89,
    166,
    150,
    164,
    130,
    168,
    193,
    41,
    91,
    219,
    194,
    221,
    9,
    63,
    96,
    11,
    223,
    3,
    193,
    49,
    104,
    122,
    11,
    39,
    145,
    122,
    150,
    113,
    210,
    78,
    240,
    73,
    72,
    218,
    101,
    70,
    85,
    222,
    181,
    177,
    3,
    129,
    61,
    155,
    189,
    41,
    37,
    189,
    221,
    0,
    11,
    114,
    9,
    223,
    42,
    189,
    235,
    163,
    74,
    138,
    158,
    208,
    196,
    32,
    151,
    99,
    18,
    47,
    86,
    58,
    22,
    173,
    48,
    207,
    42,
    117,
    16,
    22,
    139,
    226,
    57,
    167,
    89,
    173,
    40,
    194,
    239,
    252,
    150,
    114,
    225,
    16,
    132,
    235,
    201,
    28,
    92,
    144,
    252,
    43,
    82,
    47,
    218,
    187,
    155,
    190,
    20,
    75,
    163,
    55,
    38,
    250,
    44,
    249,
    232,
    4,
    248,
    68,
    59,
    79,
    47,
    6,
    22,
    52,
    174,
    149,
    220,
    99,
    51,
    185,
    158,
    250,
    211,
    16,
    211,
    51,
    154,
    231,
    60,
    146,
    213,
    167,
    76,
    181,
    21,
    64,
    16,
    199,
    223,
    8,
    116,
    58,
    47,
    26,
    59,
    46,
    61,
    203,
    139,
    92,
    19,
    47,
    7,
    189,
    4,
    59,
    109,
    145,
    110,
    91,
    107,
    57,
    59,
    183,
    240,
    82,
    194,
    71,
    66,
    169,
    165,
    108,
    37,
    4,
    160,
    76,
    110,
    150,
    148,
    193,
    241,
    169,
    112,
    178,
    87,
    54,
    252,
    153,
    66,
    88,
    238,
    57,
    23,
    217,
    134,
    29,
    123,
    204,
    86,
    1,
    0,
    196,
    95,
    167,
    169,
    105,
    209,
    195,
    134,
    174,
    121,
    215,
    38,
    139,
    114,
    161,
    229,
    202,
    134,
    192,
    97,
    244,
    170,
    125,
    203,
    148,
    235,
    206,
    76,
    85,
    33,
    37,
    79,
    251,
    241,
    80,
    100,
    53,
    124,
    25,
    37,
    87,
    6,
    127,
    113,
    167,
    196,
    129,
    25,
    129,
    247,
    188,
    154,
    72,
    10,
    110,
    107,
    251,
    15,
    7,
    102,
    151,
    10,
    183,
    11,
    85
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
