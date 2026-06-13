enum Flavor { dev, staging, prod }

class AppConfig {
  static late String baseUrl;
  static late String appName;
  static late Flavor flavor;

  static void configure({
    required String baseUrl,
    required String appName,
    required Flavor flavor,
  }) {
    AppConfig.baseUrl = baseUrl;
    AppConfig.appName = appName;
    AppConfig.flavor = flavor;
  }

  static bool get isDev => flavor == Flavor.dev;
  static bool get isStaging => flavor == Flavor.staging;
  static bool get isProd => flavor == Flavor.prod;
}
