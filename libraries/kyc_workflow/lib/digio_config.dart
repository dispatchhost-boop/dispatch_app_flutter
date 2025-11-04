import 'service_mode.dart';
import 'environment.dart';
import 'theme.dart';

class DigioConfig {
  String? logo;
  Environment environment = Environment.PRODUCTION;
  Theme theme = Theme();
  ServiceMode serviceMode = ServiceMode.OTP;
}
