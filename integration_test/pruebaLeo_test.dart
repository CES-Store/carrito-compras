import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import '../robots/login_robot.dart';

void main() {
  patrolTest('Login exitoso', ($) async {
    final loginRobot = LoginRobot($);

    await loginRobot.ingresarEmail('usuario@test.com');
    await loginRobot.ingresarPassword('123456');
    await loginRobot.presionarBotonLogin();

    await loginRobot.verificarInicioDeSesionExitoso();
  });

  patrolTest('Login con credenciales inválidas', ($) async {
    final loginRobot = LoginRobot($);

    await loginRobot.ingresarEmail('usuario@test.com');
    await loginRobot.ingresarPassword('incorrecto');
    await loginRobot.presionarBotonLogin();

    await loginRobot.verificarMensajeDeError('Credenciales inválidas');
  });
}
