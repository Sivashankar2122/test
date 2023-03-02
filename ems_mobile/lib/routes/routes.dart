import 'package:ems_mobile/auth/config.dart';
import 'package:ems_mobile/pages/permission.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import '../auth/auth_screen.dart';
import '../auth/login_screen.dart';
import '../pages/dashboard.dart';

class GetRoutes {
  static const String login = "/login";
  static const String home = "/home";
  static const String auth = "/auth";
  static const String permission = "/persmission";
  static const String config = "/config";

  static List<GetPage> routes = [
    GetPage(
        name: GetRoutes.login,
        page: () => KeyboardVisibilityProvider(child: LoginScreen())),
    GetPage(name: GetRoutes.home, page: () => const Dashboard()),
    GetPage(name: GetRoutes.auth, page: () => const AppAuth()),
    GetPage(name: GetRoutes.permission, page:(() =>  const PermissionScreen())),
    GetPage(name: GetRoutes.config, page:(() =>  const ConfigScreen ())),
  ];
}
