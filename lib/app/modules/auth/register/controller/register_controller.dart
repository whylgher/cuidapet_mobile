// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'package:cuidapet/app/core/exception/user_exists_exception.dart';
import 'package:cuidapet/app/core/ui/widgets/messages.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/logger/app_logger.dart';
import '../../../../core/ui/widgets/loader.dart';
import '../../../../services/user/user_service.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;

  RegisterControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> register(
      {required String email, required String password}) async {
    try {
      Loader.show();
      await _userService.register(email, password);
      Loader.hide();
      Messages.info(
          'Email de confirmação enviado. Olhe sua caixa de entrada. (Obs.: Pode estar em sua lixeira ou Spam.');
    } on UserExistsException {
      Loader.hide();
      Messages.alert('Email já utilizado');
    } catch (e, s) {
      _log.error('Erro ao registar usuário', e, s);
      Loader.hide();
      Messages.alert('Erro ao registar usuário');
    }
  }
}
