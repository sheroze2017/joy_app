import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/utils/token.dart';

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
    final dio = Dio(opts);
    return addInterceptors(dio);
  }

  static Dio addInterceptors(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // Ensure headers map exists
            if (options.headers == null) {
              options.headers = <String, dynamic>{};
            }
            
            var token = await getToken();
            
            if (token != null && token.isNotEmpty) {
              // Always set Authorization header, even if it already exists
              options.headers['Authorization'] = 'Bearer $token';
            }
            
            // Log request details for upload requests
            if (options.method == 'POST' && options.data is FormData) {
              final formData = options.data as FormData;
              print('🔍 [Interceptor] Upload Request Intercepted:');
              print('   - URL: ${options.uri}');
              print('   - Method: ${options.method}');
              print('   - Headers: ${options.headers}');
              print('   - FormData Files: ${formData.files.length}');
              for (var file in formData.files) {
                print('     * Field: "${file.key}", File: "${file.value.filename}"');
              }
            }
          } catch (e) {
            print('❌ [DioClient Interceptor] Error adding token: $e');
            print('❌ [DioClient Interceptor] Stack trace: ${StackTrace.current}');
            // Ensure headers map exists even on error
            if (options.headers == null) {
              options.headers = <String, dynamic>{};
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          handler.next(error);
        },
      ),
    );
    return dio;
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

  String _escapeShell(String value) {
    return value.replaceAll("'", "'\"'\"'");
  }

  String _buildFullUrl(String url, {Map<String, dynamic>? queryParameters}) {
    final base = Endpoints.baseUrl;
    final uri = Uri.parse('$base$url');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri.toString();
    }
    final params = <String, String>{};
    queryParameters.forEach((key, value) {
      if (value != null) {
        params[key] = value.toString();
      }
    });
    return uri.replace(queryParameters: params).toString();
  }

  String _buildCurlCommand(
      String method, String url, Map<String, String> headers, String? body) {
    final buffer = StringBuffer('curl -X $method ');
    buffer.write("'${_escapeShell(url)}'");
    headers.forEach((key, value) {
      buffer.write(" -H '${_escapeShell('$key: $value')}'");
    });
    if (body != null && body.isNotEmpty) {
      buffer.write(" -d '${_escapeShell(body)}'");
    }
    return buffer.toString();
  }

  Future<void> _logCurl(
      String method, String url, Map<String, dynamic>? queryParameters,
      {dynamic data}) async {
    final fullUrl = _buildFullUrl(url, queryParameters: queryParameters);
    final headers = <String, String>{};
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (method != 'GET') {
      headers['Content-Type'] = 'application/json';
    }
    String? body;
    if (data != null) {
      if (data is String) {
        body = data;
      } else {
        try {
          body = jsonEncode(data);
        } catch (_) {
          body = data.toString();
        }
      }
    }
    final curlCommand = _buildCurlCommand(method, fullUrl, headers, body);
    print('📡 [CURL] $curlCommand');
  }

  Future<dynamic> get(String url, {dynamic queryParameters}) async {
    try {
      dio.options.baseUrl = Endpoints.baseUrl;
      final fullUrl = _buildFullUrl(url, queryParameters: queryParameters);
      print('📡 [GET] Request URL: $fullUrl');
      if (queryParameters != null) {
        print('📤 [GET] Query Parameters: $queryParameters');
      }
      await _logCurl('GET', url, queryParameters);

      final response = await dio.get(url, queryParameters: queryParameters);

      print('✅ [GET] Response Status: ${response.statusCode}');
      print('📥 [GET] Response Data: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ [GET] Error: $e');
      if (e is DioException) {
        print('❌ [GET] Error Response: ${e.response?.data}');
        print('❌ [GET] Error Status Code: ${e.response?.statusCode}');
      }
      throw (e);
    }
  }

  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      dio.options.baseUrl = Endpoints.baseUrl;
      // Don't set headers directly on dio.options - let interceptor handle Authorization
      // Content-Type will be set automatically by Dio based on data type
      final fullUrl = '${Endpoints.baseUrl}$url';
      print('📡 [POST] Request URL: $fullUrl');
      print('📤 [POST] Request Data: $data');
      await _logCurl('POST', url, null, data: data);

      // Use Options to set Content-Type per request, not globally
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final response = await dio.post(url, data: data, options: options);

      print('✅ [POST] Response Status: ${response.statusCode}');
      print('📥 [POST] Response Data: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ [POST] Error: $e');
      if (e is DioException) {
        print('❌ [POST] Error Response: ${e.response?.data}');
        print('❌ [POST] Error Status Code: ${e.response?.statusCode}');
        print('❌ [POST] Error URL: ${e.requestOptions.uri}');
      }
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
      dio.options.baseUrl = Endpoints.baseUrl;
      final fullUrl = '${Endpoints.baseUrl}$url';
      print('📡 [PUT] Request URL: $fullUrl');
      print('📤 [PUT] Request Data: $data');
      await _logCurl('PUT', url, null, data: data);

      // Use Options to set Content-Type per request
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final response = await dio.put(url, data: data, options: options);

      print('✅ [PUT] Response Status: ${response.statusCode}');
      print('📥 [PUT] Response Data: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ [PUT] Error: $e');
      if (e is DioException) {
        print('❌ [PUT] Error Response: ${e.response?.data}');
        print('❌ [PUT] Error Status Code: ${e.response?.statusCode}');
        print('❌ [PUT] Error URL: ${e.requestOptions.uri}');
      }
      throw (e);
    }
  }

  Future<dynamic> delete(String url, {dynamic data}) async {
    try {
      dio.options.baseUrl = Endpoints.baseUrl;
      // dio.options.headers['marketplace_id'] = getMarketplaceId();
      final fullUrl = '${Endpoints.baseUrl}$url';
      print('📡 [DELETE] Request URL: $fullUrl');
      if (data != null) {
        print('📤 [DELETE] Request Data: $data');
      }
      await _logCurl('DELETE', url, null, data: data);

      final response = await dio.delete(url, data: data);

      print('✅ [DELETE] Response Status: ${response.statusCode}');
      print('📥 [DELETE] Response Data: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ [DELETE] Error: $e');
      if (e is DioException) {
        print('❌ [DELETE] Error Response: ${e.response?.data}');
        print('❌ [DELETE] Error Status Code: ${e.response?.statusCode}');
        print('❌ [DELETE] Error URL: ${e.requestOptions.uri}');
      }
      throw (e);
    }
  }

  Future<dynamic> upload(String url, {data}) async {
    try {
      print('📤 [UPLOAD] ========== UPLOAD REQUEST START ==========');
      dio.options.baseUrl = Endpoints.baseUrl;
      // dio.options.headers['marketplace_id'] = getMarketplaceId();
      final fullUrl = '${Endpoints.baseUrl}$url';
      print('📤 [UPLOAD] Request URL: $fullUrl');
      print('📤 [UPLOAD] Base URL: ${Endpoints.baseUrl}');
      print('📤 [UPLOAD] Endpoint Path: $url');
      print('📤 [UPLOAD] Data Type: ${data.runtimeType}');
      
      // Get token for logging
      String? token;
      try {
        token = await getToken();
        if (token != null && token.isNotEmpty) {
          print('🔑 [UPLOAD] Authorization Token: ${token.substring(0, 20)}... (length: ${token.length})');
        } else {
          print('⚠️ [UPLOAD] Authorization Token: null or empty');
        }
      } catch (e) {
        print('⚠️ [UPLOAD] Failed to get token: $e');
      }

      // Detailed FormData logging
      if (data is FormData) {
        print('📋 [UPLOAD] FormData Details:');
        print('   - Fields Count: ${data.fields.length}');
        print('   - Files Count: ${data.files.length}');
        if (data.fields.isNotEmpty) {
          print('   - FormData Fields:');
          for (var field in data.fields) {
            print('     * "${field.key}": "${field.value}"');
          }
        }
        if (data.files.isNotEmpty) {
          print('   - FormData Files:');
          for (var file in data.files) {
            print('     * Key: "${file.key}"');
            print('       - FileName: "${file.value.filename}"');
            print('       - ContentType: ${file.value.contentType}');
            print('       - Length: ${file.value.length} bytes');
            print('       - Headers: ${file.value.headers}');
          }
        } else {
          print('   ⚠️ [UPLOAD] No files in FormData!');
        }
      } else {
        print('⚠️ [UPLOAD] Data is not FormData: ${data.runtimeType}');
        print('📤 [UPLOAD] Data content: $data');
      }

      // When using FormData, Dio automatically sets Content-Type with boundary
      // Don't manually set Content-Type for FormData
      Options? options;
      if (data is! FormData) {
        options = Options();
        options.headers?.putIfAbsent('Content-Type', () => 'multipart/form-data');
        print('📤 [UPLOAD] Setting Content-Type header manually (not FormData)');
      } else {
        print('📤 [UPLOAD] Using FormData - Content-Type will be set automatically by Dio with boundary');
      }

      // Final summary before sending request
      print('');
      print('📡 [UPLOAD] ========== FINAL REQUEST SUMMARY ==========');
      print('📡 [UPLOAD] API Endpoint: $fullUrl');
      print('📡 [UPLOAD] HTTP Method: POST');
      print('📡 [UPLOAD] Request Headers:');
      if (token != null && token.isNotEmpty) {
        print('   - Authorization: Bearer ${token.substring(0, 20)}...');
      }
      if (data is FormData) {
        print('   - Content-Type: multipart/form-data (with boundary - auto-set by Dio)');
      }
      print('📡 [UPLOAD] Request Payload:');
      if (data is FormData) {
        print('   Type: FormData');
        print('   Fields: ${data.fields.length}');
        print('   Files: ${data.files.length}');
        if (data.files.isNotEmpty) {
          for (var file in data.files) {
            print('   📎 Field Name: "${file.key}"');
            print('      File: "${file.value.filename}"');
            print('      Size: ${file.value.length} bytes');
            print('      Type: ${file.value.contentType}');
          }
        }
        if (data.fields.isNotEmpty) {
          for (var field in data.fields) {
            print('   📎 "${field.key}": "${field.value}"');
          }
        }
      } else {
        print('   Type: ${data.runtimeType}');
        print('   Content: $data');
      }
      print('📡 [UPLOAD] ===========================================');
      print('');

      print('📤 [UPLOAD] Sending POST request...');
      final response = await dio.post(url, data: data, options: options);

      print('✅ [UPLOAD] ========== UPLOAD RESPONSE ==========');
      print('✅ [UPLOAD] Response Status Code: ${response.statusCode}');
      print('✅ [UPLOAD] Response Status Message: ${response.statusMessage}');
      print('✅ [UPLOAD] Response Headers:');
      response.headers.forEach((key, values) {
        print('   - $key: ${values.join(", ")}');
      });
      print('✅ [UPLOAD] Response Data Type: ${response.data.runtimeType}');
      print('');
      print('📥 [UPLOAD] ========== COMPLETE RESPONSE DATA ==========');
      
      // Parse response if it's a Map
      if (response.data is Map) {
        final responseMap = response.data as Map;
        print('📥 [UPLOAD] Response Structure: Map');
        print('📥 [UPLOAD] Response Keys: ${responseMap.keys.toList()}');
        print('');
        
        // Log all top-level keys
        responseMap.forEach((key, value) {
          print('📥 [UPLOAD] "$key": ${value.runtimeType} = $value');
          
          // If value is a Map, show its structure
          if (value is Map) {
            print('   └─ Map Keys: ${value.keys.toList()}');
            value.forEach((nestedKey, nestedValue) {
              print('      "$nestedKey": ${nestedValue.runtimeType} = $nestedValue');
              
              // Check for URLs in nested values
              if (nestedValue is String && (nestedValue.toString().startsWith('http://') || nestedValue.toString().startsWith('https://'))) {
                print('      🔗 [URL FOUND] $nestedKey: $nestedValue');
              }
              
              // If nested value is also a Map, show its structure
              if (nestedValue is Map) {
                nestedValue.forEach((deepKey, deepValue) {
                  print('         "$deepKey": ${deepValue.runtimeType} = $deepValue');
                  if (deepValue is String && (deepValue.toString().startsWith('http://') || deepValue.toString().startsWith('https://'))) {
                    print('         🔗 [URL FOUND] $deepKey: $deepValue');
                  }
                });
              }
            });
          }
          
          // If value is a List, show its structure
          if (value is List) {
            print('   └─ List Length: ${value.length}');
            for (int i = 0; i < value.length && i < 5; i++) {
              print('      [$i]: ${value[i].runtimeType} = ${value[i]}');
              if (value[i] is Map) {
                (value[i] as Map).forEach((listKey, listValue) {
                  print('         "$listKey": ${listValue.runtimeType} = $listValue');
                  if (listValue is String && (listValue.toString().startsWith('http://') || listValue.toString().startsWith('https://'))) {
                    print('         🔗 [URL FOUND] $listKey: $listValue');
                  }
                });
              }
            }
            if (value.length > 5) {
              print('      ... and ${value.length - 5} more items');
            }
          }
          
          // Check for URLs in string values
          if (value is String && (value.toString().startsWith('http://') || value.toString().startsWith('https://'))) {
            print('   🔗 [URL FOUND] $key: $value');
          }
        });
        
        print('');
        print('📥 [UPLOAD] Parsed Values:');
        print('   - code: ${responseMap['code']}');
        print('   - success: ${responseMap['success'] ?? responseMap['sucess']}');
        print('   - message: ${responseMap['message']}');
        
        if (responseMap['data'] != null) {
          print('   - data: ${responseMap['data']}');
          print('   - data type: ${responseMap['data'].runtimeType}');
          
          // Check if data contains URL
          if (responseMap['data'] is String) {
            final dataString = responseMap['data'] as String;
            if (dataString.startsWith('http://') || dataString.startsWith('https://')) {
              print('   🔗 [URL IN DATA] $dataString');
            }
          } else if (responseMap['data'] is Map) {
            final dataMap = responseMap['data'] as Map;
            dataMap.forEach((dataKey, dataValue) {
              if (dataValue is String && (dataValue.toString().startsWith('http://') || dataValue.toString().startsWith('https://'))) {
                print('   🔗 [URL IN DATA.$dataKey] $dataValue');
              }
              // Check common URL field names
              if (['url', 'image_url', 'imageUrl', 'image', 'file_url', 'fileUrl', 'link', 'src'].contains(dataKey.toString().toLowerCase())) {
                print('   🔗 [POSSIBLE URL FIELD: $dataKey] $dataValue');
              }
            });
          }
        }
        
        // Check for common URL field names in response
        final urlFields = ['url', 'image_url', 'imageUrl', 'image', 'file_url', 'fileUrl', 'link', 'src', 'media_url', 'mediaUrl'];
        for (var urlField in urlFields) {
          if (responseMap.containsKey(urlField)) {
            print('   🔗 [URL FIELD FOUND: $urlField] ${responseMap[urlField]}');
          }
        }
      } else if (response.data is String) {
        print('📥 [UPLOAD] Response Structure: String');
        print('📥 [UPLOAD] Response Content: ${response.data}');
        if ((response.data as String).startsWith('http://') || (response.data as String).startsWith('https://')) {
          print('🔗 [URL FOUND IN RESPONSE] ${response.data}');
        }
      } else if (response.data is List) {
        print('📥 [UPLOAD] Response Structure: List');
        print('📥 [UPLOAD] Response Length: ${(response.data as List).length}');
        for (int i = 0; i < (response.data as List).length && i < 10; i++) {
          print('   [$i]: ${(response.data as List)[i]}');
        }
      } else {
        print('📥 [UPLOAD] Response Content: ${response.data}');
      }
      
      print('📥 [UPLOAD] ===========================================');
      print('✅ [UPLOAD] ======================================');
      return response.data;
    } catch (e, stackTrace) {
      print('❌ [UPLOAD] ========== UPLOAD ERROR ==========');
      print('❌ [UPLOAD] Error: $e');
      print('❌ [UPLOAD] Error Type: ${e.runtimeType}');
      if (e is DioException) {
        print('❌ [UPLOAD] DioException Details:');
        print('   - Type: ${e.type}');
        print('   - Message: ${e.message}');
        print('   - Request Path: ${e.requestOptions.path}');
        print('   - Request Method: ${e.requestOptions.method}');
        print('   - Request URL: ${e.requestOptions.uri}');
        print('   - Request Headers: ${e.requestOptions.headers}');
        print('   - Request Data Type: ${e.requestOptions.data.runtimeType}');
        
        if (e.requestOptions.data is FormData) {
          final fd = e.requestOptions.data as FormData;
          print('   - FormData Fields Count: ${fd.fields.length}');
          print('   - FormData Files Count: ${fd.files.length}');
          if (fd.fields.isNotEmpty) {
            print('   - FormData Fields:');
            for (var field in fd.fields) {
              print('     * "${field.key}": "${field.value}"');
            }
          }
          if (fd.files.isNotEmpty) {
            print('   - FormData Files:');
            for (var file in fd.files) {
              print('     * Key: "${file.key}"');
              print('       - FileName: "${file.value.filename}"');
              print('       - ContentType: ${file.value.contentType}');
              print('       - Length: ${file.value.length} bytes');
            }
          }
        } else {
          print('   - Request Data: ${e.requestOptions.data}');
        }
        
        print('   - Response Status Code: ${e.response?.statusCode}');
        print('   - Response Status Message: ${e.response?.statusMessage}');
        print('   - Response Headers: ${e.response?.headers}');
        print('   - Response Data: ${e.response?.data}');
        print('   - Response Data Type: ${e.response?.data.runtimeType}');
        
        if (e.response?.data is Map) {
          final errorData = e.response!.data as Map;
          print('   - Error Response Keys: ${errorData.keys.toList()}');
          print('   - Error Code: ${errorData['code']}');
          print('   - Error Message: ${errorData['message']}');
          print('   - Error Success: ${errorData['success'] ?? errorData['sucess']}');
        }
      }
      print('❌ [UPLOAD] Stack Trace: $stackTrace');
      print('❌ [UPLOAD] ======================================');
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
