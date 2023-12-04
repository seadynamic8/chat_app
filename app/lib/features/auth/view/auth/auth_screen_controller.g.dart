// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authScreenControllerHash() =>
    r'8974039a4726aa8203045b6fc05ef6003eb69bb4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AuthScreenController
    extends BuildlessAutoDisposeNotifier<AuthFormState> {
  late final AuthFormType formType;

  AuthFormState build(
    AuthFormType formType,
  );
}

/// See also [AuthScreenController].
@ProviderFor(AuthScreenController)
const authScreenControllerProvider = AuthScreenControllerFamily();

/// See also [AuthScreenController].
class AuthScreenControllerFamily extends Family<AuthFormState> {
  /// See also [AuthScreenController].
  const AuthScreenControllerFamily();

  /// See also [AuthScreenController].
  AuthScreenControllerProvider call(
    AuthFormType formType,
  ) {
    return AuthScreenControllerProvider(
      formType,
    );
  }

  @override
  AuthScreenControllerProvider getProviderOverride(
    covariant AuthScreenControllerProvider provider,
  ) {
    return call(
      provider.formType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'authScreenControllerProvider';
}

/// See also [AuthScreenController].
class AuthScreenControllerProvider extends AutoDisposeNotifierProviderImpl<
    AuthScreenController, AuthFormState> {
  /// See also [AuthScreenController].
  AuthScreenControllerProvider(
    AuthFormType formType,
  ) : this._internal(
          () => AuthScreenController()..formType = formType,
          from: authScreenControllerProvider,
          name: r'authScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$authScreenControllerHash,
          dependencies: AuthScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              AuthScreenControllerFamily._allTransitiveDependencies,
          formType: formType,
        );

  AuthScreenControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.formType,
  }) : super.internal();

  final AuthFormType formType;

  @override
  AuthFormState runNotifierBuild(
    covariant AuthScreenController notifier,
  ) {
    return notifier.build(
      formType,
    );
  }

  @override
  Override overrideWith(AuthScreenController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AuthScreenControllerProvider._internal(
        () => create()..formType = formType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        formType: formType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AuthScreenController, AuthFormState>
      createElement() {
    return _AuthScreenControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthScreenControllerProvider && other.formType == formType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, formType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AuthScreenControllerRef on AutoDisposeNotifierProviderRef<AuthFormState> {
  /// The parameter `formType` of this provider.
  AuthFormType get formType;
}

class _AuthScreenControllerProviderElement
    extends AutoDisposeNotifierProviderElement<AuthScreenController,
        AuthFormState> with AuthScreenControllerRef {
  _AuthScreenControllerProviderElement(super.provider);

  @override
  AuthFormType get formType =>
      (origin as AuthScreenControllerProvider).formType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
