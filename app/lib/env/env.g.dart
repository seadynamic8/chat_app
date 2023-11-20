// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// SecureDotEnvAnnotationGenerator
// **************************************************************************

class _$Env extends Env {
  const _$Env() : super._();

  static const String _encryptedValues =
      'eyJERVZfU1VQQUJBU0VfVVJMIjoiYUhSMGNEb3ZMekU1TWk0eE5qZ3VNUzR5TlRvMU5ETXlNUT09IiwiREVWX1NVUEFCQVNFX0tFWSI6IlpYbEthR0pIWTJsUGFVcEpWWHBKTVU1cFNYTkpibEkxWTBOSk5rbHJjRmhXUTBvNUxtVjVTbkJqTTAxcFQybEtlbVJZUW1oWmJVWjZXbE14YTFwWE1YWkphWGRwWTIwNWMxcFRTVFpKYlVaMVlqSTBhVXhEU214bFNFRnBUMnBGTlU5RVRUUk5WRWsxVDFSYU9TNURVbGhRTVVFM1YwOWxiMHBsV0hocVRtNXBORE5yWkZGM1oyNVhUbEpsYVd4RVRXSnNXVlJ1WDBrdyIsIlNUQUdFX1NVUEFCQVNFX1VSTCI6ImFIUjBjRG92TDNaeVlXaHRhM1pyWTJwNVltNXdkR2wxZW1SNkxuTjFjR0ZpWVhObExtTnYiLCJTVEFHRV9TVVBBQkFTRV9LRVkiOiJaWGxLYUdKSFkybFBhVXBKVlhwSk1VNXBTWE5KYmxJMVkwTkpOa2xyY0ZoV1EwbzVMbVY1U25Cak0wMXBUMmxLZW1SWVFtaFpiVVo2V2xOSmMwbHVTbXhhYVVrMlNXNWFlVmxYYUhSaE0xcHlXVEp3TlZsdE5YZGtSMnd4WlcxU05rbHBkMmxqYlRseldsTkpOa2x0Um5WaU1qUnBURU5LY0ZsWVVXbFBha1V6VFVSQk1FMXFWWGxOYWtselNXMVdOR05EU1RaTmFrRjRUbXBCZDAxVVNYbE5iakF1UTNNMGR6QTFVVmh3Y2pSRGVtNHpjWGh1TVZoR2JubG5ZbkpQYUVGSlVXVkpZVVJEVFRaelluRkxNQT09IiwiUFJPRF9TVVBBQkFTRV9VUkwiOiJhSFIwY0RvdkwzQjRiV2x4Ym1KNFltdHpjWGh5WW5ScmFtOTRMbk4xY0dGaVlYTmxMbU52IiwiUFJPRF9TVVBBQkFTRV9LRVkiOiJaWGxLYUdKSFkybFBhVXBKVlhwSk1VNXBTWE5KYmxJMVkwTkpOa2xyY0ZoV1EwbzVMbVY1U25Cak0wMXBUMmxLZW1SWVFtaFpiVVo2V2xOSmMwbHVTbXhhYVVrMlNXNUNOR0pYYkhoaWJVbzBXVzEwZW1OWWFIbFpibEp5WVcwNU5FbHBkMmxqYlRseldsTkpOa2x0Um5WaU1qUnBURU5LY0ZsWVVXbFBha1V5VDFSWmQwOUVUVE5OYWxGelNXMVdOR05EU1RaTmFrRjRUVlJaTVU5VVkzbE9TREF1UlZZd2VUUktVRlEwUW1WNk9DMDFUM1pyUW04NGVDMWtTVWczTjNwa1ZtVk9SMUZ4TkVoU1UyRnljdz09IiwiQVpVUkVfS0VZIjoiWldSaE5UVXhaR0UyTUdSaE5EaGlaR0kxT1dFMk9HSXlORGM1T0RKaU56VT0iLCJBWlVSRV9SRUdJT04iOiJaMnh2WW1GcyJ9';
  @override
  String get devSupabaseUrl => _get('DEV_SUPABASE_URL');

  @override
  String get devSupabaseKey => _get('DEV_SUPABASE_KEY');

  @override
  String get stageSupabaseUrl => _get('STAGE_SUPABASE_URL');

  @override
  String get stageSupabaseKey => _get('STAGE_SUPABASE_KEY');

  @override
  String get prodSupabaseUrl => _get('PROD_SUPABASE_URL');

  @override
  String get prodSupabaseKey => _get('PROD_SUPABASE_KEY');

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

    final bytes = base64.decode(_encryptedValues);
    final stringDecoded = String.fromCharCodes(bytes);
    final jsonMap = json.decode(stringDecoded) as Map<String, dynamic>;
    if (!jsonMap.containsKey(key)) {
      throw Exception('Key $key not found in .env file');
    }
    final encryptedValue = jsonMap[key] as String;
    final decryptedValue = base64.decode(encryptedValue);
    final stringValue = String.fromCharCodes(decryptedValue);
    return _parseValue(stringValue);
  }
}
