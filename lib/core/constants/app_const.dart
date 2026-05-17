abstract class AppConst {
  const AppConst._();

  static const baseUrl = String.fromEnvironment('BASE_URL');
  static const devMode = bool.fromEnvironment('DEV_MODE');

  static const timeOut = Duration(seconds: 60);
}
