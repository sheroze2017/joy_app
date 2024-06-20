import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';

class AuthApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  AuthApi(this._dioClient);

  Future<LoginModel> login(
    String email,
    String password,
    String authType,
    String roleId,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.loginApi, data: {
        "email": email,
        "password": password,
        "auth_type": authType,
        "role_id": roleId,
      });
      return LoginModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<LoginModel> register(
    String firstName,
    String lastName,
    String about,
    String location,
    String phoneNo,
    String associatedHospital,
    String deviceToken,
    String email,
    String password,
    String authType,
    String userRole,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.signUpApi, data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "associated_hospital": associatedHospital,
        "about": about,
        "location": location,
        "device_token": deviceToken
      });
      return LoginModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Future<OrdersDto> getOrders(List<String> statuses, int page,
  //     {int size = 20, bool fullDataForCaching = false}) async {
  //   try {
  //     final result = await _dioClient.get(Endpoints.ORDERS, queryParameters: {
  //       'order_by': 'order_number',
  //       'page': page,
  //       'simple': true,
  //       'size': size,
  //       // 'fullDataForCaching': fullDataForCaching,
  //       'status': statuses,
  //     });
  //     return OrdersDto.fromJson(result['data']);
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // Future<OrdersDto> getOrdersByLocation(List<String> statuses, int page,
  //     {int size = 20,
  //     required double latitude,
  //     required double longitude}) async {
  //   try {
  //     final result =
  //         await _dioClient.get(Endpoints.ORDERS_BY_LOCATION, queryParameters: {
  //       'page': page,
  //       'simple': true,
  //       'size': size,
  //       'status': statuses,
  //       'current_lat': latitude,
  //       'current_lng': longitude
  //     });
  //     return OrdersDto.fromJson(result['data']);
  //   } on DioError catch (error) {
  //     showErrorSnackBar(translate('info'), translate('routing_free_version'),
  //         durationSeconds: 3);
  //     throw getErrorMessage(error);
  //   } catch (e) {
  //     print(e.toString());

  //     throw e;
  //   }
  // }

  // Future<OrdersDto> searchOrders(List<String> statuses, int page,
  //     {int size = 20, String search = ''}) async {
  //   try {
  //     final result = await _dioClient.get(Endpoints.ORDERS, queryParameters: {
  //       'order_by': 'order_number',
  //       'page': page,
  //       'simple': true,
  //       'size': size,
  //       'search': search,
  //       'status': statuses,
  //     });
  //     return OrdersDto.fromJson(result['data']);
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // Future<OrderDto> getOrderById(int id) async {
  //   try {
  //     final result = await _dioClient.get('${Endpoints.ORDER}/$id');
  //     return OrderDto.fromJson(result['data']);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<String?> getAwb(int id) async {
  //   try {
  //     final result = await _dioClient.get('${Endpoints.GET_AWB}$id');

  //     return result['data']['value'];
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<int> updateImage(File file) async {
  //   try {
  //     FormData formData = FormData.fromMap({
  //       "title": "test",
  //       "uploadFile": await MultipartFile.fromFile(file.path),
  //     });

  //     final result = await _dioClient.upload(
  //       Endpoints.IMAGE_UPDATE,
  //       data: formData,
  //     );
  //     return result['data']['id'];
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<ImageData> updateImageOverload(File file) async {
  //   try {
  //     FormData formData = FormData.fromMap({
  //       "title": "test",
  //       "uploadFile": await MultipartFile.fromFile(file.path),
  //     });

  //     final result = await _dioClient.upload(
  //       Endpoints.IMAGE_UPDATE,
  //       data: formData,
  //     );
  //     return ImageData.fromJson(result);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<int> updateSignature(Uint8List byteImage) async {
  //   try {
  //     FormData formData = FormData.fromMap({
  //       "title": "test",
  //       "uploadFile": MultipartFile.fromBytes(byteImage,
  //           filename: 'signature.jpg', contentType: MediaType('image', 'jpg')),
  //     });

  //     final result = await _dioClient.upload(
  //       Endpoints.IMAGE_UPDATE,
  //       data: formData,
  //     );
  //     return result['data']['id'];
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<List<String>> getImages(List<String> imageIds) async {
  //   try {
  //     final result = await _dioClient.get(Endpoints.GET_MULTIPLE_IMAGES,
  //         queryParameters: {'attachment_ids': imageIds});
  //     return List<String>.from(result['data']);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<bool> updateOrderStatus(
  //     int orderId, UpdateOrderDto updatedOrder) async {
  //   //send location now
  //   Position? position = Position(
  //       longitude: 0.0,
  //       latitude: 0.0,
  //       accuracy: 0,
  //       altitude: 0,
  //       altitudeAccuracy: 0,
  //       heading: 0,
  //       headingAccuracy: 0,
  //       speed: 0,
  //       speedAccuracy: 0,
  //       timestamp: DateTime.now());
  //   try {
  //     position = await _locationService.getDevicePosition();
  //   } catch (err) {}

  //   try {
  //     await _dioClient
  //         .put('${Endpoints.ORDER_UPDATE_STATUS}/$orderId/status', data: {
  //       'status': updatedOrder.status,
  //       'event_date': updatedOrder.eventDate,
  //       'lat': position?.latitude,
  //       'lng': position?.longitude,
  //       'cancellation_reason': updatedOrder.cancellationReason
  //     });
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // Future<bool> receivePayment(
  //     int orderId, PaymentProofDto paymentProofDto) async {
  //   try {
  //     await _dioClient.put(
  //         '${Endpoints.RECEIVE_PAYMENT}/$orderId/receive_payment',
  //         data: paymentProofDto.toJson());
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // Future<bool> verifyOtp(int orderId, String otp) async {
  //   try {
  //     final result = await _dioClient
  //         .post('${Endpoints.VERIFY_ORDER}$orderId?verification_code=$otp');

  //     if (result['data']['verified'] == true) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // Future<bool> verifyOtpBtc(int orderId, String otp) async {
  //   try {
  //     var obj = {"order_id": orderId, "otp": otp};
  //     final result = await _dioClient.postCustomize(
  //         '${Endpoints.BTC_BASE_URL_FOR_OTP_VALIDATION + Endpoints.BTC_VALIDATE_OTP}',
  //         data: obj);
  //     // print('BTC OTP VERIFICATION Result: ${result.toString()}');

  //     if (result['message'].toString().toLowerCase() == "sucess" ||
  //         result['message'].toString().toLowerCase() == "success" ||
  //         result['message'].toString().toLowerCase() == "succes") {
  //       // print('BTC OTP VERIFICATION Result: SUCCESSFULL');

  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // Future<bool> updateOrderStatusWithImage(
  //     int orderId, UpdateOrderDto updatedOrder, String rescheduledDate) async {
  //   //send location now
  //   Position? position = Position(
  //       longitude: 0.0,
  //       latitude: 0.0,
  //       accuracy: 0,
  //       altitude: 0,
  //       altitudeAccuracy: 0,
  //       heading: 0,
  //       headingAccuracy: 0,
  //       speed: 0,
  //       speedAccuracy: 0,
  //       timestamp: DateTime.now());
  //   try {
  //     position = await _locationService.getDevicePosition();
  //   } catch (err) {}

  //   try {
  //     await _dioClient
  //         .put('${Endpoints.ORDER_UPDATE_STATUS}/$orderId/status', data: {
  //       'status': updatedOrder.status,
  //       'event_date': updatedOrder.eventDate,
  //       'lat': position?.latitude,
  //       'lng': position?.longitude,
  //       'cancellation_reason': rescheduledDate.isNotEmpty
  //           ? getFutureDeliveryOrPickupRescheduledText(rescheduledDate)
  //           : updatedOrder.cancellationReason,
  //       'signature': updatedOrder.signature!.toProofOfRejectionJson(),
  //       if (rescheduledDate != null && rescheduledDate.isNotEmpty)
  //         'rescheduled_date': rescheduledDate,
  //     });
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // getFutureDeliveryOrPickupRescheduledText(String rescheduledDate) {
  //   try {
  //     String whatsappMessage = translate('rescheduled_date_message');
  //     String date = DateTimePicker.getDateSplit(rescheduledDate);
  //     String time = DateTimePicker.getTimeSplit(rescheduledDate);

  //     List<String> dynamicData = [date, time];
  //     return WhatsappMessageUtils.replacePlaceholders(
  //         whatsappMessage, dynamicData);
  //   } catch (e) {
  //     return rescheduledDate;
  //   }
  // }

  // Future<bool> completeOrder(
  //     int orderId, UpdateOrderDto updatedOrder, String? receiverName) async {
  //   Position? position = Position(
  //       longitude: 0.0,
  //       latitude: 0.0,
  //       accuracy: 0,
  //       altitude: 0,
  //       altitudeAccuracy: 0,
  //       heading: 0,
  //       headingAccuracy: 0,
  //       speed: 0,
  //       speedAccuracy: 0,
  //       timestamp: DateTime.now());
  //   try {
  //     position = await _locationService.getDevicePosition();
  //   } catch (err) {}

  //   try {
  //     final obj = {
  //       'lat': position?.latitude,
  //       'lng': position?.longitude,
  //       'status': updatedOrder.status,
  //       'event_date': updatedOrder.eventDate,
  //       'signature': updatedOrder.signature!.toJson(),
  //     };

  //     try {
  //       /**To get receiver name as a note in backend dashboard
  //        * We have only one field in backend which can show note
  //        * 'cancelation_reason' can show notes.
  //        */
  //       if (receiverName != null && receiverName.isNotEmpty) {
  //         obj['cancellation_reason'] = 'Received by ${receiverName}';
  //       }
  //       /**Replace cancellation reason if actual cancellation reason is not empty */
  //       if (updatedOrder.cancellationReason != null &&
  //           updatedOrder.cancellationReason!.isNotEmpty) {
  //         obj['cancellation_reason'] = updatedOrder.cancellationReason;
  //       }
  //     } catch (error) {}
  //     await _dioClient.put('${Endpoints.ORDER_UPDATE_STATUS}/$orderId/status',
  //         data: obj);
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // /// batch_update branch

  // Future<String?> batchUpdateOrdersStatusChange(String orderNumber) async {
  //   try {
  //     final result = await _dioClient.get(
  //         '${Endpoints.API_BATCH_UPDATE_CHANGE_STATUS_URL}',
  //         queryParameters: {'orderNumber': orderNumber});

  //     return result['data'];
  //   } on DioError catch (error) {
  //     throw getErrorMessage(error);
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // Future<OrderDto> getOrderByBarcode(String barcode) async {
  //   var response =
  //       await _dioClient.get(Endpoints.ORDER_GET_BY_BARCODE + barcode);
  //   var order = OrderDto.fromJson(response['data']);
  //   return order;
  // }

  // Future<OrderDto> getAdminOrder(String barcode) async {
  //   var response = await _dioClient.get(Endpoints.GET_ADMIN_ORDER + barcode);

  //   print('reponse ${response.toString()}');
  //   var order = OrderDto.fromJson(response['data']['list'][0]);
  //   return order;
  // }

  // Future<AdminDriverInfoDto> getTransferDrivers(
  //     String? search, int page, int size) async {
  //   var queryParameters = {
  //     'page': page,
  //     'status': 'active',
  //     'search': search,
  //     'size': 20
  //   };

  //   var response = await _dioClient.get(Endpoints.GET_DRIVER,
  //       queryParameters: queryParameters);
  //   return AdminDriverInfoDto.fromJson(response['data']);
  //   //as List<AdminDriverInfoDto>;

  //   //TransferDriversDto.fromJson(response['data']);
  // }

  // Future<AdminWarehouseInfoDto> getWarehouse(
  //     String? search, int page, int size) async {
  //   var queryParameters = {
  //     'page': page,
  //     'status': 'active',
  //     'search': search,
  //     'size': 20
  //   };

  //   var response = await _dioClient.get(Endpoints.GET_WAREHOUSE,
  //       queryParameters: queryParameters);
  //   return AdminWarehouseInfoDto.fromJson(response['data']);
  //   //as List<AdminDriverInfoDto>;

  //   //TransferDriversDto.fromJson(response['data']);
  // }

  // Exception getErrorMessage(DioError error) {
  //   try {
  //     if (error.type == DioErrorType.response) {
  //       String errorMessage = error.response?.data['message'];
  //       return Exception(errorMessage);
  //     }
  //     return Exception(error.toString());
  //   } catch (exception) {
  //     return Exception(error.toString());
  //   }
  // }

  // Future<Map<int, List<String>>> batchUpdateOrders(List<String> orderNumbers,
  //     int? signatureId, int? photoId, String orderStatus) async {
  //   try {
  //     String type = "";
  //     if (orderStatus == OrderStatus.pickedUp) {
  //       type = "sender_signature";
  //     } else if (orderStatus == OrderStatus.completed) {
  //       type = "delivery_signature";
  //     }

  //     Map<String, dynamic> orderSignatureData = {
  //       "type": type,
  //     };
  //     if (signatureId != null) {
  //       orderSignatureData['signature_id'] = signatureId;
  //     }
  //     if (photoId != null) {
  //       orderSignatureData['photo_id'] = photoId;
  //     }

  //     final result = await _dioClient
  //         .post('${Endpoints.API_BATCH_ORDER_UPDATE_URL}', data: {
  //       'order_numbers': List<String>.from(orderNumbers.map((e) => e).toList()),
  //       'order_status': orderStatus,
  //       "order_signature": orderSignatureData
  //     });

  //     List<String> successOrderList =
  //         List<String>.from(result['data']['success_order_numbers']);
  //     List<String> failureOrderList =
  //         List<String>.from(result['data']['failed_order_numbers']);

  //     Map<int, List<String>> response = {
  //       0: successOrderList,
  //       1: failureOrderList
  //     };
  //     return response;
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // Future<Map<int, List<String>>> adminBatchUpdate(
  //     List<String> orderNumbers,
  //     int? signatureId,
  //     int? photoId,
  //     String orderStatus,
  //     Warehouse? warehouse,
  //     Drivers? driver,
  //     String? operationType) async {
  //   try {
  //     String type = "";
  //     if (orderStatus == OrderStatus.pickedUp) {
  //       type = "sender_signature";
  //     } else if (orderStatus == OrderStatus.completed) {
  //       type = "delivery_signature";
  //     }

  //     Map<String, dynamic> orderSignatureData = {
  //       "type": type,
  //     };
  //     if (signatureId != null) {
  //       orderSignatureData['signature_id'] = signatureId;
  //     }
  //     if (photoId != null) {
  //       orderSignatureData['photo_id'] = photoId;
  //     }

  //     Map<String, dynamic> object = {};

  //     if (operationType == OperationType.inTransit) {
  //       object = {
  //         'order_numbers':
  //             List<String>.from(orderNumbers.map((e) => e).toList()),
  //         'order_status': orderStatus,
  //         'privacy': 'public',
  //         'driver': {
  //           'id': driver!.id,
  //           'name': driver.driverName,
  //         },
  //         'warehouse': {
  //           'id': warehouse?.id,
  //           'name': warehouse?.name,
  //         }
  //       };
  //     }
  //     if (operationType == OperationType.inSorting) {
  //       object = {
  //         'order_numbers':
  //             List<String>.from(orderNumbers.map((e) => e).toList()),
  //         'order_status': orderStatus,
  //         'privacy': 'public',
  //         'warehouse': {
  //           'id': warehouse?.id,
  //           'name': warehouse?.name,
  //         }
  //       };
  //     }

  //     if (operationType == OperationType.dispatch) {
  //       object = {
  //         'order_numbers':
  //             List<String>.from(orderNumbers.map((e) => e).toList()),
  //         'order_status': orderStatus,
  //         'privacy': 'public',
  //         'driver': {
  //           'id': driver!.id,
  //           'name': driver.driverName,
  //         }
  //       };
  //     }

  //     final result =
  //         await _dioClient.put('${Endpoints.BATCH_UPDATE_ADMIN}', data: object);

  //     List<String> successOrderList = List<String>.from(orderNumbers);
  //     List<String> failureOrderList = List<String>.from([]);

  //     Map<int, List<String>> response = {
  //       0: successOrderList,
  //       1: failureOrderList
  //     };
  //     return response;
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // Future<List<OrderGroupDto>> getGroupOrder(
  //     FilterGroupBy filterGroupBy, List<String> statuses) async {
  //   try {
  //     final result =
  //         await _dioClient.get(Endpoints.ORDERS_GROUP_BY, queryParameters: {
  //       'group_by': '${filterGroupBy.value}',
  //       'status': statuses,
  //     });

  //     List<OrderGroupDto>? list;
  //     if (result['data'] != null) {
  //       List<dynamic> response = result['data'];
  //       list = response.map((e) => OrderGroupDto.fromJson(e)).toList();
  //     }

  //     return list ?? [];
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // Future<OrdersDto> getOrdersByGroupId(List<String> statuses, int page,
  //     {int? customerId,
  //     String? neighborhoodName,
  //     int size = 20,
  //     bool fullDataForCaching = false}) async {
  //   try {
  //     Map<String, dynamic> queryParameters = {};

  //     if (customerId != null) {
  //       queryParameters['customer_id'] = customerId;
  //     } else {
  //       String name = neighborhoodName.toString().replaceAll(" ", "");
  //       queryParameters['neighborhood_name'] = '$neighborhoodName';
  //     }

  //     queryParameters['page'] = page;
  //     queryParameters['simple'] = true;
  //     queryParameters['size'] = size;
  //     //queryParameters['fullDataForCaching'] = fullDataForCaching;
  //     queryParameters['status'] = statuses;

  //     final result = await _dioClient.get(Endpoints.ORDERS,
  //         queryParameters: queryParameters);

  //     return OrdersDto.fromJson(result['data']);
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // /// Orders group by
  // Future<OrdersMapDto> getOrdersByGroup(
  //     FilterGroupBy filterGroupBy, List<String> statuses, int page,
  //     {int size = 20, bool fullDataForCaching = false}) async {
  //   try {
  //     final result =
  //         await _dioClient.get(Endpoints.ORDERS_GROUP_BY, queryParameters: {
  //       'group_by': '${filterGroupBy.value}',
  //       'order_by': 'order_number',
  //       'page': page,
  //       'simple': true,
  //       'size': size,
  //       'status': statuses,
  //     });

  //     List<OrderMapDto>? ordersDtoList;
  //     if (result['data']['map'] != null)
  //       ordersDtoList = result['data']['map']
  //           .entries
  //           .map<OrderMapDto>(
  //               (entry) => OrderMapDto.fromJson(entry.key, entry.value))
  //           .toList();

  //     OrdersMapDto ordersMapDto = OrdersMapDto(
  //         total: result['data']['total'], orderMapDto: ordersDtoList ?? []);
  //     return ordersMapDto;
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // /// Matrix api
  // Future<MatrixDto> getBetweenLocationDistance(
  //     BetweenDistanceDto betweenDistanceDto) async {
  //   try {
  //     final result = await _dioClient.post(
  //         Endpoints.GET_BETWEEN_LOCATION_DISTANCE,
  //         data: betweenDistanceDto.toJson());

  //     List<dynamic> map = result['data']['matrix']['rows'];
  //     MatrixDto matrixDto = MatrixDto.fromJson(map.first);

  //     return matrixDto;
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // /// New Orders
  // Future<OrdersDto> getNewOrdersByDefault(
  //     String orderType, List<String> statuses, int page,
  //     {int size = 20, bool fullDataForCaching = false}) async {
  //   try {
  //     final result = await _dioClient.get(Endpoints.ORDERS, queryParameters: {
  //       'types': orderType,
  //       'tab': '1',
  //       'order_by_direction': 'desc',
  //       'order_by': 'created_date',
  //       'page': page,
  //       'simple': true,
  //       'size': size,
  //       // 'fullDataForCaching': fullDataForCaching,
  //       'status': statuses,
  //     });
  //     return OrdersDto.fromJson(result['data']);
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  // Future<Map<String, dynamic>> googleDistanceMatrix(String query) async {
  //   try {
  //     final result = await _dioClient
  //         .get(Endpoints.GOOGLE_DISTANCE_MATRIX_END_POINT + query);
  //     return result;
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }
}
