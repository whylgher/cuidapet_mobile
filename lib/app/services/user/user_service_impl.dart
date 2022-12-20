import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';
import '../../core/exception/failure.dart';
import '../../core/exception/user_exists_exception.dart';
import '../../core/exception/user_not_exists_exception.dart';
import '../../core/helpers/constants.dart';
import '../../core/local_storage/local_storage.dart';
import '../../core/logger/app_logger.dart';
import '../../repositories/user/user_repository.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;
  final LocalStorage _localStorage;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
    required LocalStorage localStorage,
  })  : _userRepository = userRepository,
        _localStorage = localStorage,
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
        final xx = await _localStorage
            .read<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY);
        print(xx);
      } else {
        throw Failure(
            message:
                'Login não pode ser feito por email e password, por favor, utilize outro método, facebook ou google.');
      }
    } on FirebaseAuthException catch (e, s) {
      _log.error('Usuário ou senha inválidos FirebaseAuthError: [{$e.code}]');
      throw Failure(message: 'Usuária ou senha inválidos!!!');
    }
  }

  Future<void> _saveAccessToken(String accessToken) => _localStorage
      .write<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY, accessToken);
}
