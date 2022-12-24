import 'package:mobx/mobx.dart';

import '../../core/life_cycle/controller_life_cycle.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store, ControllerLifeCycle {
  @override
  void onInit(Map<String, dynamic>? params) {
    print('OnInit Chamado');
  }

  @override
  void onReady() {
    print('OnRead Chamado');
  }

  @override
  void dispose() {
    print('Dispose Chamado');
  }
}
