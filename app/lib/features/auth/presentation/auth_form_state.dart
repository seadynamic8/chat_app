import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_form_state.freezed.dart';

enum AuthFormType { login, signup }

@freezed
class AuthFormState with _$AuthFormState {
  const factory AuthFormState({
    required AuthFormType formType,
    @Default(AsyncData(null)) AsyncValue<void> value,
  }) = _AuthFormState;
}
