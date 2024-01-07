enum TokenType { fcm, apns }

class Token {
  Token({required this.value, required this.type});

  final String value;
  final TokenType type;

  Map<String, dynamic> toMap() {
    return {type.name: value};
  }
}
