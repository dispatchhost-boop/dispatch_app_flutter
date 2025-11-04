
enum Flavor {
  DEV,
  PROD,
}

class FlavorValues {
  final String baseUrl;

  FlavorValues({required this.baseUrl});
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;

  static late FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance = FlavorConfig._internal(flavor, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance => _instance;

  static bool isProduction() => _instance.flavor == Flavor.PROD;

  static bool isDevelopment() => _instance.flavor == Flavor.DEV;
}
