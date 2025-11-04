import 'package:jwt_decoder/jwt_decoder.dart';
import 'login_credentials.dart';

class UserAuthentication {
  static final UserAuthentication _instance = UserAuthentication._internal();

  factory UserAuthentication() => _instance;

  UserAuthentication._internal();

  String? _token;
  Map<String, dynamic>? _decodedToken;

  /// Call this once during app startup
  Future<void> loadTokenFromStorage() async {
    final storedToken = await LoginCredentials().getToken();

    if (storedToken.isNotEmpty && storedToken.isNotEmpty && !JwtDecoder.isExpired(storedToken)) {
      _token = storedToken;
      _decodedToken = JwtDecoder.decode(storedToken);
    } else {
      await clearToken();
    }
  }

  /// Set the JWT token (ideally once, after login or retrieval)
  Future<void> setToken(String token) async {
    _token = token;
    _decodedToken = JwtDecoder.decode(token);
    await LoginCredentials().saveToken(token);
  }

  Future<void> clearToken() async {
    _token = null;
    _decodedToken = null;
    await LoginCredentials().deleteToken();
  }

  /// Get entire decoded payload
  Map<String, dynamic>? get payload => _decodedToken;

  /// Check if token is expired
  bool get isTokenExpired => _token == null || JwtDecoder.isExpired(_token!);

  /// Get token expiration time
  DateTime? get expirationDate =>
      _token != null ? JwtDecoder.getExpirationDate(_token!) : null;

  /// Getters based on your JWT payload
  // expose token globally
  String? get token => _token;
  int? get id => _decodedToken?['id'];
  String? get name => _decodedToken?['name'];
  String? get email => _decodedToken?['email'];
  int? get isActive => _decodedToken?['isActive'];
  int? get level => _decodedToken?['level'];
  int? get roleId => _decodedToken?['role_id'];   // ✅ fixed
  String? get roleName => _decodedToken?['roleName'];
  String? get lastName => _decodedToken?['last_name'];
  String? get companyName => _decodedToken?['company_name'];
  String? get logoPath => _decodedToken?['logo_path'];  // ✅ fixed
  int? get isKycVerified => _decodedToken?['is_kyc_verified'];
  int? get selectedClientId => _decodedToken?['selectedClientId'];

  /// Roles list
  List<String> get rolesArray {
    final roles = _decodedToken?['rolesArray'];
    if (roles is List) {
      return roles.map((e) => e.toString()).toList();
    }
    return [];
  }

  Map<String, String> getClientDetails(String id){
    return {
      "selectedClientId": id,
    };
  }

  /// Replace the existing token with a new one and reload decoded data
  /// Replace the existing token with a new one and reload decoded data
  Future<bool> replaceToken(String newToken) async {
    try {
      // clear old
      await clearToken();

      // save + decode new
      _token = newToken;
      _decodedToken = JwtDecoder.decode(newToken);
      await LoginCredentials().saveToken(newToken);

      // reload from storage to ensure consistency
      await loadTokenFromStorage();

      // ✅ if still valid, return true
      return _token != null && !JwtDecoder.isExpired(_token!);
    } catch (e) {
      // in case of error
      await clearToken();
      return false;
    }
  }




}
