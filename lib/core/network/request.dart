import 'package:dio/dio.dart';
import 'package:joy_app/core/constants/endpoints.dart';

class DioClient {
  static final DioClient _singletonRequest = DioClient._internal();

  static DioClient getInstance() {
    return _singletonRequest;
  }

  DioClient._internal();

  static final String url = Endpoints.baseUrl;
  //static final SecureStorage _secureStorage = SecureStorage();

  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    responseType: ResponseType.json,
    connectTimeout: Duration(seconds: 20),
    receiveTimeout: Duration(seconds: 20),
  );

  static Dio createDio() {
    return Dio(opts);
  }

  // static Dio addInterceptors(Dio dio) {
  //   dio
  //     ..options.headers = {
  //       'Content-Type': 'application/json; charset=utf-8',
  //       "x-app-type": Platform.isIOS ? "RIDER_IOS" : "RIDER_ANDROID",
  //     }
  //     ..interceptors.add(DioLogInterceptor())

  //     // ..interceptors.add(LogInterceptor(
  //     //   request: true,
  //     //   responseBody: true,
  //     //   requestBody: true,
  //     //   requestHeader: true,
  //     // ))
  //     ..interceptors.add(
  //       InterceptorsWrapper(
  //         onRequest: (options, handler) async {
  //           try {
  //             var token = await getToken();

  //             if (token != null) {
  //               //print('token added ' + token);
  //               options.headers
  //                   .putIfAbsent('Authorization', () => "Bearer $token");
  //             } else {
  //               print('Auth token is null');
  //             }
  //           } catch (e) {
  //             print('interceptor error');
  //           }
  //           handler.next(options);
  //         },
  //         onError: (e, handler) async {
  //           print('error');

  //           if (e.type == DioErrorType.connectTimeout ||
  //               e.type == DioErrorType.other ||
  //               e.type == DioErrorType.cancel) {
  //             Fluttertoast.showToast(
  //                 msg: translate("no_internet_connection"),
  //                 toastLength: Toast.LENGTH_SHORT,
  //                 gravity: ToastGravity.BOTTOM,
  //                 timeInSecForIosWeb: 1,
  //                 backgroundColor: Colors.red,
  //                 textColor: Colors.white,
  //                 fontSize: 12.0);
  //             return handler.next(e);
  //           }

  //           if (e.response != null) {
  //             if (e.response?.statusCode == 401) {
  //               print('dio log session expired');
  //               try {
  //                 var token = await getToken();
  //                 bool hasExpired = JwtDecoder.isExpired(token!);

  //                 if (true) {
  //                   print('has expired');
  //                   final isRefreshTokenSuccess = await _refreshToken();
  //                   if (isRefreshTokenSuccess) {
  //                     token = await getToken();
  //                     e.requestOptions.headers['Authorization'] =
  //                         'Bearer $token';
  //                   } else {
  //                     throw Exception('Refresh token failed');
  //                   }
  //                 } else {
  //                   e.requestOptions.headers['Authorization'] = 'Bearer $token';
  //                 }

  //                 final response = await _retry(e.requestOptions);
  //                 return handler.resolve(response);
  //               } catch (e) {
  //                 await _secureStorage.deleteAllData();
  //                 if (getx.Get.currentRoute != AuthScreen.routeName)
  //                   getx.Get.toNamed(AuthScreen.routeName);
  //               }
  //             } else if (e.response!.statusCode! >= 500) {
  //               Fluttertoast.showToast(
  //                   msg: translate("something_went_wrong"),
  //                   toastLength: Toast.LENGTH_SHORT,
  //                   gravity: ToastGravity.BOTTOM,
  //                   timeInSecForIosWeb: 1,
  //                   backgroundColor: Colors.red,
  //                   textColor: Colors.white,
  //                   fontSize: 12.0);
  //             }
  //           }
  //           return handler.next(e);
  //         },
  //       ),
  //     );

  //   return dio;
  // }

  // getMarketplaceId() async {
  //   if (await MarketPlaceUtils.getMarketPlaceId() == 0) {
  //     return "";
  //   }
  //   await MarketPlaceUtils.getMarketPlaceId();
  // }

  // static _getMarketplaceId() async {
  //   if (await MarketPlaceUtils.getMarketPlaceId() == 0) {
  //     return "";
  //   }
  //   await MarketPlaceUtils.getMarketPlaceId();
  // }

  static final dio = createDio();
  // static final baseAPI = addInterceptors(dio);

  Future<dynamic> get(String url, {dynamic queryParameters}) async {
    try {
      //  baseAPI.options.baseUrl = Endpoints.baseUrl;
      //dio.options.headers['marketplace_id'] = getMarketplaceId();

      final response = await dio.get(url, queryParameters: queryParameters);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      dio.options.baseUrl = Endpoints.baseUrl;
      // dio.options.headers['marketplace_id'] = getMarketplaceId();

      final response = await dio.post(url, data: data);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<dynamic> postCustomize(String url, {dynamic data}) async {
    try {
      print('URL: ${url}  data: ${data}');
      dio.options.baseUrl = url;
      final response = await dio.post(url, data: data);
      return response.data;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<dynamic> put(String url, {dynamic data}) async {
    try {
      print(url);
      print('data ${data.toString()}');
      dio.options.baseUrl = Endpoints.baseUrl;
      // dio.options.headers['marketplace_id'] = getMarketplaceId();

      final response = await dio.put(url, data: data);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<dynamic> delete(String url, {dynamic data}) async {
    try {
      dio.options.baseUrl = Endpoints.baseUrl;
      // dio.options.headers['marketplace_id'] = getMarketplaceId();

      final response = await dio.delete(url, data: data);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<dynamic> upload(String url, {data}) async {
    try {
      dio.options.baseUrl = Endpoints.baseUrl;
      // dio.options.headers['marketplace_id'] = getMarketplaceId();

      Options options = new Options();
      options.headers?.putIfAbsent('Content-Type', () => 'multipart/form-data');

      final response = await dio.post(url, data: data, options: options);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // helper methods
  // static Future<bool> _refreshToken() async {
  //   try {
  //     final SharedPreferences sharedPreferences = getx.Get.find();
  //     final environmentType =
  //         sharedPreferences.getString(Preferences.ENVIRONMENT_TYPE) ??
  //             Preferences.PROD_ENVIRONMENT;
  //     final secureStorage = SecureStorage();
  //     final userName = await secureStorage.getData(SecureKeys.USERNAME);
  //     final password = await secureStorage.getData(SecureKeys.PASSWORD);

  //     var data;
  //     var endpoint = Endpoints.LOGIN;
  //     if (environmentType == Preferences.PROD_ENVIRONMENT) {
  //       data = {
  //         "username": userName,
  //         "password": password,
  //       };
  //     } else {
  //       endpoint = Endpoints.LOGIN_DEV;
  //       data = {
  //         "company_id": 1,
  //         "username": userName,
  //         "password": password,
  //       };
  //     }

  //     baseAPI.options.baseUrl = Endpoints.baseUrl;
  //     dio.options.headers['marketplace_id'] = _getMarketplaceId();

  //     final response = await baseAPI.post(endpoint, data: data);
  //     final result = AuthResponse.fromJson(response.data['data']);
  //     await sharedPreferences.setString(Preferences.AUTH_TOKEN, result.token);

  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
