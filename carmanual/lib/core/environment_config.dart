enum Env { DEV, STAGE, PROD }
enum FLAVOR { TEST }

class EnvironmentConfig {
  static const APP_NAME = String.fromEnvironment(
    'APP_NAME',
    defaultValue: "Car manual",
  );
  static const FLAVOR = String.fromEnvironment('FLAVOR');
  static const ENV = String.fromEnvironment(
    'ENV',
    defaultValue: "DEV",
  );
}
