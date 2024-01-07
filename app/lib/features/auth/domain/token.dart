// ignore_for_file: public_member_api_docs, sort_constructors_first
enum TokenType { fcm, apns }

class Token {
  Token({required this.fcmValue, this.apnsValue});

  final String fcmValue;
  final String? apnsValue;

  Map<String, dynamic> toMap() {
    final resultMap = {'fcm': fcmValue};
    if (apnsValue != null) resultMap['apns'] = apnsValue as String;
    return resultMap;
  }

  Token copyWith({
    String? fcmValue,
    String? apnsValue,
  }) {
    return Token(
      fcmValue: fcmValue ?? this.fcmValue,
      apnsValue: apnsValue ?? this.apnsValue,
    );
  }
}
