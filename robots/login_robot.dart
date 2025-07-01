import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

class LoginRobot {
  final PatrolIntegrationTester $;

  LoginRobot(this.$);

  Future<void> ingresarEmail(String email) async {
    await $('email_field').enterText(email);
  }

  Future<void> ingresarPassword(String password) async {
    await $('password_field').enterText(password);
  }

  Future<void> presionarBotonLogin() async {
    await $('login_button').tap();
  }

  Future<void> verificarInicioDeSesionExitoso() async {
    await $('home_screen').waitUntilVisible();
  }

  Future<void> verificarMensajeDeError(String mensaje) async {
    await $(mensaje).waitUntilVisible();
  }
}
