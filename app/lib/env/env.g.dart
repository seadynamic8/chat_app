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
    252,
    38,
    113,
    186,
    73,
    165,
    136,
    176,
    36,
    130,
    153,
    47,
    125,
    73,
    169,
    16,
    169,
    60,
    50,
    208,
    15,
    232,
    161,
    121,
    203,
    33,
    49,
    253,
    203,
    132,
    138,
    33,
    43,
    128,
    152,
    137,
    62,
    149,
    64,
    254,
    106,
    127,
    68,
    172,
    47,
    103,
    217,
    77,
    85,
    13,
    27,
    233,
    9,
    172,
    212,
    9,
    36,
    245,
    194,
    39,
    173,
    185,
    245,
    236,
    239,
    94,
    132,
    174,
    140,
    201,
    185,
    36,
    18,
    233,
    105,
    69,
    238,
    52,
    89,
    22,
    99,
    30,
    52,
    56,
    196,
    240,
    13,
    95,
    48,
    103,
    81,
    72,
    234,
    36,
    161,
    141,
    183,
    23,
    5,
    19,
    68,
    22,
    48,
    56,
    19,
    41,
    120,
    175,
    193,
    15,
    133,
    232,
    194,
    130,
    156,
    123,
    98,
    102,
    78,
    138,
    254,
    88,
    158,
    215,
    13,
    3,
    189,
    44,
    19,
    99,
    152,
    59,
    17,
    126,
    91,
    77,
    32,
    218,
    190,
    253,
    24,
    248,
    175,
    240,
    19,
    119,
    98,
    34,
    173,
    215,
    29,
    100,
    112,
    47,
    211,
    86,
    117,
    144,
    16,
    53,
    32,
    208,
    140,
    106,
    163,
    19,
    217,
    53,
    142,
    169,
    227,
    154,
    239,
    43,
    174,
    89,
    47,
    16,
    147,
    97,
    239,
    105,
    21,
    213,
    41,
    96,
    21,
    202,
    81,
    160,
    87,
    186,
    53,
    26,
    154,
    44,
    27,
    93,
    173,
    102,
    216,
    223,
    236,
    21,
    185,
    126,
    103,
    56,
    3,
    59,
    204,
    212,
    19,
    38,
    178,
    93,
    128,
    86,
    163,
    8,
    75,
    181,
    233,
    6,
    200,
    152,
    173,
    214,
    239,
    217,
    179,
    95,
    194,
    100,
    226,
    88,
    202,
    81,
    216,
    239,
    171,
    42,
    62,
    245,
    101,
    153,
    241,
    177,
    72,
    61,
    121,
    89,
    169,
    141,
    211,
    28,
    72,
    220,
    129,
    190,
    82,
    98,
    197,
    28,
    120,
    32,
    254,
    207,
    78,
    15,
    155,
    231,
    91,
    222,
    175,
    156,
    254,
    98,
    151,
    71,
    241,
    254,
    74,
    146,
    81,
    82,
    109,
    88,
    124,
    161,
    180,
    192,
    253,
    161,
    189,
    184,
    102,
    234,
    55,
    84,
    222,
    183,
    179,
    222,
    64,
    139,
    14,
    51,
    29,
    184,
    213,
    100,
    122,
    3,
    77,
    243,
    243,
    187,
    53,
    32,
    75,
    49,
    35,
    33,
    8,
    106,
    121,
    157,
    230,
    229,
    219,
    141,
    133,
    120,
    247,
    232,
    117,
    81,
    36,
    109,
    193,
    194,
    169,
    55,
    229,
    131,
    83,
    180,
    175,
    62,
    45,
    30,
    53,
    179,
    229,
    81,
    100,
    243,
    44,
    60,
    166,
    166,
    214,
    3,
    18,
    203,
    236,
    187,
    26,
    32,
    178,
    109,
    140,
    229,
    112,
    8,
    209,
    156,
    163,
    127,
    112,
    224,
    145,
    121,
    122,
    132,
    75,
    233,
    61,
    59,
    19,
    156,
    148,
    148,
    8,
    59,
    169,
    221,
    149,
    254,
    169,
    135,
    52,
    240,
    9,
    82,
    8,
    58,
    216,
    75,
    237,
    233,
    224,
    231,
    71,
    59,
    155,
    112,
    111,
    216,
    17,
    80,
    181,
    66,
    33,
    164,
    187,
    74,
    41,
    39,
    229,
    150
  ]);
  @override
  String get supabaseUrl => _get('SUPABASE_URL');

  @override
  String get supabaseKey => _get('SUPABASE_KEY');

  @override
  String get azureKey => _get('AZURE_KEY');

  @override
  String get azureRegion => _get('AZURE_REGION');

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
