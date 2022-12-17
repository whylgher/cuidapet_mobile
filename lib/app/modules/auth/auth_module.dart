import 'package:cuidapet/app/repositories/user/user_repository.dart';
import 'package:cuidapet/app/repositories/user/user_repository_impl.dart';
import 'package:cuidapet/app/services/user/user_service.dart';
import 'package:cuidapet/app/services/user/user_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home/auth_home_page.dart';
import 'login/login_module.dart';
import 'register/register_module.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton<UserRepository>((i) => UserRepositoryImpl()),
    Bind.lazySingleton<UserService>((i) => UserServiceImpl()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, __) => AuthHomePage(
        authStore: Modular.get(),
      ),
    ),
    ModuleRoute('/login', module: LoginModule()),
    ModuleRoute('/register', module: RegisterModule()),
  ];
}
