import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test("Should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });

    test("Can not logout if not initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test("Should be able to initialized.", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("User should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    test(
      "Should be able to initialize in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: Timeout(Duration(seconds: 2)),
    );
    test("Create user should delegate to Login function", () async {
      final badEmailUser = provider.createUser(
        email: "brij@gmail.com",
        password: "anypassword",
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<InvalidCredentialsAuthException>()),
      );

      final badPasswordUser = provider.createUser(
        email: "someone@gmail.com",
        password: "brijpatel",
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<InvalidCredentialsAuthException>()),
      );

      final user = await provider.createUser(email: "brij", password: "patel");
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Login user should be able to verified", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to logout and login again", () async {
      await provider.logOut();
      await provider.logIn(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "brij@gmail.com") {
      throw InvalidCredentialsAuthException();
    }
    if (password == "brijpatel") {
      throw InvalidCredentialsAuthException();
    }
    const user = AuthUser(
      id: "my_id",
      isEmailVerified: false,
      email: 'brij@patel.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw InvalidCredentialsAuthException();
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) {
      throw InvalidCredentialsAuthException();
    }
    const newUser = AuthUser(
      id: "my_id",
      isEmailVerified: true,
      email: 'brij@patel.com',
    );
    _user = newUser;
  }
}
