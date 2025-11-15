enum Flavor {
  vendor,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.vendor:
        return 'Deligo Vendor';
    }
  }

  static String get apiBase {
    switch (appFlavor) {
      case Flavor.vendor:
        return "http://10.0.2.2:8000/api/";
    }
  }

  static String get logo {
    switch (appFlavor) {
      case Flavor.vendor:
        return "assets/flavors/logo/vendor/logo.png";
    }
  }

  static String get logoLight {
    switch (appFlavor) {
      case Flavor.vendor:
        return "assets/flavors/logo/vendor/logo_light.png";
    }
  }
}
