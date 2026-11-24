import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/models/seller_auth_models.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/bloc/seller_register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAuthRepository implements SellerAuthRepository {
  _FakeAuthRepository({this.signUpFields = const [], this.failWith});

  final List<SellerAttribute> signUpFields;
  final SellerApiException? failWith;
  Map<String, String>? capturedAttributes;
  String? capturedSlug;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<List<SellerAttribute>> signUpAttributes() async => signUpFields;

  @override
  Future<String> register({
    required String name,
    required String email,
    required String slug,
    required String password,
    required String passwordConfirmation,
    String? phone,
    Map<String, String> attributes = const {},
  }) async {
    if (failWith != null) throw failWith!;
    capturedSlug = slug;
    capturedAttributes = attributes;
    return 'Your shop is awaiting admin approval.';
  }

  @override
  Future<SellerLoginResult> login({
    required String email,
    required String password,
  }) async => const SellerLoginResult(success: true, token: 'x');

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> logout() async {}
}

const _customAttribute = SellerAttribute(
  code: 'vatNumber',
  name: 'VAT Number',
  type: 'text',
  isRequired: true,
);

void main() {
  test('loads the sign-up attributes the admin configured', () async {
    final cubit = SellerRegisterCubit(
      repository: _FakeAuthRepository(
        signUpFields: const [
          SellerAttribute(
            code: 'name',
            name: 'Name',
            type: 'text',
            isRequired: true,
          ),
          _customAttribute,
        ],
      ),
    );

    await cubit.loadAttributes();

    expect(cubit.state.status, SellerRegisterStatus.ready);
    // Fixed fields have their own form controls, so only custom ones are
    // rendered dynamically.
    expect(cubit.state.customAttributes.single.code, 'vatNumber');
  });

  test('submits custom attributes as code/value pairs', () async {
    final repository = _FakeAuthRepository(
      signUpFields: const [_customAttribute],
    );
    final cubit = SellerRegisterCubit(repository: repository);
    await cubit.loadAttributes();

    await cubit.submit(
      name: 'Demo Seller',
      email: 'demo@example.com',
      slug: 'demo-shop',
      password: 'secret123',
      passwordConfirmation: 'secret123',
      customValues: const {'vatNumber': '123456789'},
    );

    expect(cubit.state.status, SellerRegisterStatus.submitted);
    expect(cubit.state.message, 'Your shop is awaiting admin approval.');
    expect(repository.capturedSlug, 'demo-shop');
    expect(repository.capturedAttributes, {'vatNumber': '123456789'});
  });

  test('a rejected registration surfaces the server message', () async {
    final cubit = SellerRegisterCubit(
      repository: _FakeAuthRepository(
        failWith: const SellerApiException(
          'The email has already been taken.',
          SellerApiFailure.validation,
        ),
      ),
    );

    await cubit.submit(
      name: 'Demo Seller',
      email: 'taken@example.com',
      slug: 'demo-shop',
      password: 'secret123',
      passwordConfirmation: 'secret123',
    );

    expect(cubit.state.status, SellerRegisterStatus.failed);
    expect(cubit.state.errorMessage, 'The email has already been taken.');
  });
}
