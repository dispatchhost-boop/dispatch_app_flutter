import '../services/flavor_config.dart';

class ApiUrl{

  static String get baseUrl => FlavorConfig.instance.values.baseUrl;
  // static String baseUrl = "http://192.168.1.54:8008/";// for development
  // static String baseUrl = "https://dispatchsolutions.in/";// for production

  static String signUp = "${baseUrl}signup";
  static String logIn = baseUrl;
  static String panCard = "${baseUrl}client-kyc-verification";
  static String gstVerify = "${baseUrl}client-gstin-verification";
  static String dashboardOverView = "${baseUrl}api/dashboard";
  static String clientsList  = "${baseUrl}api/all-clients";
  static String dashboardShipment = "${baseUrl}api/dashboard/shipments";
  static String clientChange = "${baseUrl}auth/change-client";
  static String clientKycData = "${baseUrl}api/kyc/userdata";
  static String submitKycData = "${baseUrl}submit-kyc";
}
