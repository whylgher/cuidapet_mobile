import 'package:cuidapet/app/models/social_login_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';
import '../../core/exception/failure.dart';
import '../../core/exception/user_exists_exception.dart';
import '../../core/exception/user_not_exists_exception.dart';
import '../../core/helpers/constants.dart';
import '../../core/local_storage/local_storage.dart';
import '../../core/logger/app_logger.dart';
import '../../models/social_network_model.dart';
import '../../repositories/social/social_repository.dart';
import '../../repositories/user/user_repository.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;
  final LocalStorage _localStorage;
  final LocalSecureStorage _localSecureStore;
  final SocialRepository _socialRepository;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
    required SocialRepository socialRepository,
  })  : _userRepository = userRepository,
        _localStorage = localStorage,
        _localSecureStore = localSecureStorage,
        _socialRepository = socialRepository,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final userLoggedMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (userLoggedMethods.isNotEmpty) {
        throw UserExistsException();
      }

      await _userRepository.register(email, password);

      final userRegisterCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userRegisterCredential.user?.sendEmailVerification();
    } on FirebaseException catch (e, s) {
      _log.error('Erro ao criar usuário no Firebase', e, s);
      throw Failure(message: 'Erro ao criar usuário.');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final logindMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (logindMethods.isEmpty) {
        throw UserNotExistsException();
      }

      if (logindMethods.contains('password')) {
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        final userVerfied = userCredential.user?.emailVerified ?? false;

        if (!userVerfied) {
          userCredential.user?.sendEmailVerification();

          throw Failure(
              message:
                  'e-mail não confirmado, por favor conferir a caixa de spam');
        }
        final accessToken = await _userRepository.login(email, password);

        await _saveAccessToken(accessToken);
        await _confirmLogin();
        await _getUserData();
      } else {
        throw Failure(
            message:
                'Login não pode ser feito por email e password, por favor, utilize outro método, facebook ou google.');
      }
    } on FirebaseAuthException catch (e) {
      _log.error('Usuário ou senha inválidos FirebaseAuthError: [{$e.code}]');
      throw Failure(message: 'Usuária ou senha inválidos!!!');
    }
  }

  @override
  Future<void> socialLogin(SocialLoginType socialLoginType) async {
    try {
      final SocialNetworkModel socialModel;
      final AuthCredential authCredential;
      final firebaseAuth = FirebaseAuth.instance;

      switch (socialLoginType) {
        case SocialLoginType.facebook:
          throw Failure(message: 'Facebook not implemented');
        // break;
        case SocialLoginType.google:
          socialModel = await _socialRepository.googleLogin();

          authCredential = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );

          break;
      }

      final logindMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(socialModel.email);

      final methodCheck = _getMethodSocialLoginType(socialLoginType);

      if (logindMethods.isNotEmpty && !logindMethods.contains(methodCheck)) {
        throw Failure(
          message:
              'Login não pode ser feito por $methodCheck, por favor utilize outro método.',
        );
      }

      await firebaseAuth.signInWithCredential(authCredential);
      final accessToken = await _userRepository.loginSocial(socialModel);
      await _saveAccessToken(accessToken);
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao realizar login com $socialLoginType', e, s);
      throw Failure(message: 'Erro ao realizar login');
    }
  }

  String _getMethodSocialLoginType(SocialLoginType socialLoginType) {
    switch (socialLoginType) {
      case SocialLoginType.facebook:
        return 'facebook.com';
      case SocialLoginType.google:
        return 'google.com';
    }
  }

  Future<void> _saveAccessToken(String accessToken) => _localStorage
      .write<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY, accessToken);

  Future<void> _confirmLogin() async {
    final confirmLoginResultModel = await _userRepository.confirmLogin();

    await _saveAccessToken(confirmLoginResultModel.accessToken);

    await _localSecureStore.write(Constants.LOCAL_STORAGE_REFRESH_TOKEN_KEY,
        confirmLoginResultModel.refreshToken);
  }

  Future<void> _getUserData() async {
    final userModel = await _userRepository.getUserLogged();
    await _localStorage.write<String>(
      Constants.LOCAL_STORAGE_USER_LOGGED_DATA,
      userModel.toJson(),
    );
  }
}
