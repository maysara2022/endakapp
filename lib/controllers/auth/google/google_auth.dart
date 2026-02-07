import 'dart:async';
import 'package:endakapp/core/constants/end_points.dart';
import 'package:endakapp/core/prfs/userPrfs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';


class GoogleAuth {
  final Dio _dio = Dio();
  late GoogleSignIn _googleSignIn;

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _errorMessage = '';

  final Function(String)? onError;
  final Function(GoogleSignInAccount?)? onUserChanged;
  final Function(bool)? onAuthorizationChanged;
  final Function(Map<String, dynamic>)? onServerResponse;

  // Scopes المطلوبة
  static const List<String> scopes = <String>[
    'email',
    'profile',
  ];

  GoogleAuth({
    this.onError,
    this.onUserChanged,
    this.onAuthorizationChanged,
    this.onServerResponse,
  }) {
    _dio.options.baseUrl = EndPoints.main;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<void> initialize({String? clientId, required String serverClientId}) async {
    _googleSignIn = GoogleSignIn.instance;

    await _googleSignIn.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );

    _googleSignIn.authenticationEvents
        .listen(_handleAuthenticationEvent)
        .onError(_handleAuthenticationError);

  }
  Future<void> _handleAuthenticationEvent(
      GoogleSignInAuthenticationEvent event,
      ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);

    _currentUser = user;
    _isAuthorized = authorization != null;
    _errorMessage = '';

    onUserChanged?.call(_currentUser);
    onAuthorizationChanged?.call(_isAuthorized);

    if (user != null && authorization != null) {
      await _sendTokenToServer(user);
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    _currentUser = null;
    _isAuthorized = false;
    _errorMessage = e is GoogleSignInException
        ? _errorMessageFromSignInException(e)
        : 'Unknown error: $e';

    onUserChanged?.call(null);
    onAuthorizationChanged?.call(false);
    onError?.call(_errorMessage);

  }

  Future<void> _sendTokenToServer(GoogleSignInAccount user) async {
    try {
      final Map<String, String>? headers = await user
          .authorizationClient
          .authorizationHeaders(scopes);

      if (headers == null) {
        _errorMessage = 'Failed to get authorization headers';
        onError?.call(_errorMessage);
        return;
      }

      final String? accessToken = headers['Authorization']?.replaceFirst('Bearer ', '');

      if (accessToken == null || accessToken.isEmpty) {
        _errorMessage = 'Failed to extract access token';
        onError?.call(_errorMessage);
        return;
      }


      final Map<String, dynamic> requestBody = {
        'access_token': accessToken,
        'device_token': 'optional_device_token',
      };


      final Response response = await _dio.post(
        '/auth/google',
        data: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = await response.data['data'];
        await UserPrefs.saveToken(data['token']);
        await UserPrefs.saveId(data['user']['id'].toString());
        final Map<String, dynamic> responseData = response.data;
        onServerResponse?.call(responseData);
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        onError?.call(_errorMessage);
      }
    } on DioException catch (e) {
      _errorMessage = _handleDioError(e);
      onError?.call(_errorMessage);
    } catch (e) {
      _errorMessage = 'Error: $e';
      onError?.call(_errorMessage);
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'انتهت مهلة الاتصال';
      case DioExceptionType.sendTimeout:
        return 'انتهت مهلة الإرسال';
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاستقبال';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'];
        }
        return 'خطأ في الخادم: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'خطأ في الاتصال بالإنترنت';
      default:
        return 'خطأ غير معروف';
    }
  }

  Future<void> signIn() async {
    try {
      if (_googleSignIn.supportsAuthenticate()) {
        await _googleSignIn.authenticate();
      } else {
        _errorMessage = 'This platform does not support authentication';
        onError?.call(_errorMessage);
      }
    } catch (e) {
      _errorMessage = e.toString();
      onError?.call(_errorMessage);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'تم إلغاء تسجيل الدخول',
      GoogleSignInExceptionCode.clientConfigurationError => 'خطأ في إعدادات Google',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
  }
  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isAuthorized => _isAuthorized;
  String get errorMessage => _errorMessage;

  void dispose() {
    _dio.close();
  }
}