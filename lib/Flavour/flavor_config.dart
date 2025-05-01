

enum Flavor {
  sit,
  uat,
  prod,
}

class FlavorConfig {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.sit:
        return 'WasteManagement SIT';
      case Flavor.uat:
        return 'WasteManagement UAT';
      case Flavor.prod:
        return 'WasteManagement';
      default:
        return 'WasteManagement';
    }
  }

  static bool get isDevelopment {
    switch (appFlavor) {
      case Flavor.sit:
        return false;
      case Flavor.uat:
        return false;
      case Flavor.prod:
        return true;
      default:
        return false;
    }
  }

  static bool get isWasteManagement {
    switch (appFlavor) {
      case Flavor.sit:
        return true;
      case Flavor.uat:
        return true;
      case Flavor.prod:
        return true;
      default:
        return true;
    }
  }
}
