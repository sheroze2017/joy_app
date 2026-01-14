import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/auth/models/blood_bank_register_model.dart';
import 'package:joy_app/modules/auth/models/doctor_register_model.dart';
import 'package:joy_app/modules/auth/models/hospital_resgister_model.dart';
import 'package:joy_app/modules/auth/models/pharmacy_register_model.dart';
import 'package:joy_app/modules/auth/models/user_register_model.dart';

class AuthApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  AuthApi(this._dioClient);

  Future<LoginModel> login(
    String email,
    String password,
    String authType,
  ) async {
    try {
      print('🔐 [AuthApi] login() called');
      final requestData = {"email": email, "password": password, "auth_type": authType};
      print('📤 [AuthApi] login() Request Payload:');
      print('   - email: $email');
      print('   - password: ${password.isNotEmpty ? "***" : "empty"}');
      print('   - auth_type: $authType');
      print('📤 [AuthApi] login() Full Payload JSON: $requestData');
      
      final result = await _dioClient.post(Endpoints.loginApi, data: requestData);
      
      print('✅ [AuthApi] login() success');
      print('📥 [AuthApi] login() Response: $result');
      final loginModel = LoginModel.fromJson(result);
      print('📥 [AuthApi] login() Parsed Response:');
      print('   - Token: ${loginModel.data?.token != null ? "***" : "null"}');
      print('   - UserId: ${loginModel.data?.user?.userId}');
      print('   - Role: ${loginModel.data?.user?.userRole}');
      print('   - Success: ${loginModel.sucess}');
      print('   - Message: ${loginModel.message}');
      return loginModel;
    } catch (e) {
      print('❌ [AuthApi] login() error: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> checkEmail(
    String email,
  ) async {
    try {
      print('📧 [AuthApi] checkEmail() called');
      print('📧 [AuthApi] Email: $email');
      final result =
          await _dioClient.get(Endpoints.isValidEmail + '?email=${email}');
      print('✅ [AuthApi] checkEmail() response: $result');
      print('✅ [AuthApi] Email available: ${result['data']?['available']}');
      return result;
    } catch (e) {
      print('❌ [AuthApi] checkEmail() error: $e');
      throw e;
    }
  }

  Future<bool> updateDeviceToken(String userId, String deviceToken) async {
    try {
      final requestData = {
        "user_id": userId,
        "device_token": deviceToken,
      };
      print('📡 [AuthApi] updateDeviceToken() called');
      print('📤 [AuthApi] updateDeviceToken() Payload: $requestData');
      final result =
          await _dioClient.post(Endpoints.updateDeviceToken, data: requestData);
      print('📥 [AuthApi] updateDeviceToken() Response: $result');
      return result['sucess'] == true || result['success'] == true;
    } catch (e) {
      print('❌ [AuthApi] updateDeviceToken() error: $e');
      return false;
    }
  }

  // Legacy method for backward compatibility
  Future<int> isValidEmail(
    String email,
  ) async {
    try {
      final result = await checkEmail(email);
      return result['code'] ?? 400;
    } catch (e) {
      print('❌ [AuthApi] isValidEmail() error: $e');
      throw e;
    }
  }

  // Step 1: Create base user with minimal fields
  Future<UserRegisterModel> userSignup(
    String name,
    String email,
    String password,
    String userRole,
    String authType,
  ) async {
    try {
      print('👤 [AuthApi] userSignup() Step 1 called');
      print('👤 [AuthApi] Name: $name, Email: $email, Role: $userRole, AuthType: $authType');
      final requestData = {
        "name": name,
        "email": email,
        "password": password,
        "user_role": userRole,
        "auth_type": authType,
        "location": "",
        "device_token": "",
        "phone": "",
        "date_of_birth": null,
        "gender": null,
        "image": null,
        "about_me": null,
        "profile_completed": false
      };
      final result = await _dioClient.post(Endpoints.userSignUpApi, data: requestData);
      print('✅ [AuthApi] userSignup() Step 1 success');
      final userModel = UserRegisterModel.fromJson(result);
      print('✅ [AuthApi] userSignup() Step 1 - UserId: ${userModel.data?.userId}, Success: ${userModel.sucess}');
      return userModel;
    } catch (e) {
      print('❌ [AuthApi] userSignup() Step 1 error: $e');
      throw e;
    }
  }

  Future<UserRegisterModel> userRegister(
      String firstName,
      String email,
      String password,
      String location,
      String deviceToken,
      String dob,
      String gender,
      String phoneNo,
      String authType,
      String userRole,
      String image,
      String aboutMe) async {
    try {
      print('👤 [AuthApi] userRegister() called - Single-step USER signup');
      print('👤 [AuthApi] Name: $firstName, Email: $email, Role: $userRole');
      final requestData = {
        "name": firstName,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "date_of_birth": dob,
        "gender": gender,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "image": image,
        "about_me": aboutMe
      };
      print('📤 [AuthApi] userRegister() Request Payload:');
      print('   - name: $firstName');
      print('   - email: $email');
      print('   - password: ${password.isNotEmpty ? "***" : "empty"}');
      print('   - location: $location');
      print('   - device_token: $deviceToken');
      print('   - date_of_birth: $dob');
      print('   - gender: $gender');
      print('   - user_role: $userRole');
      print('   - auth_type: $authType');
      print('   - phone: $phoneNo');
      print('   - image: $image');
      print('   - about_me: $aboutMe');
      print('📤 [AuthApi] userRegister() Full Payload JSON: $requestData');
      
      final result = await _dioClient.post(Endpoints.userSignUpApi, data: requestData);
      
      print('📥 [AuthApi] userRegister() Raw Response: $result');
      
      // Check for errors in raw response first (handle both 'success' and 'sucess' spelling)
      bool isSuccess = result['success'] ?? result['sucess'] ?? false;
      int? responseCode = result['code'];
      String? errorMessage = result['message'];
      
      if (isSuccess == false || responseCode != 200) {
        print('❌ [AuthApi] userRegister() Error Response Detected:');
        print('   - Code: $responseCode');
        print('   - Success: $isSuccess');
        print('   - Message: $errorMessage');
        throw Exception(errorMessage ?? 'Registration failed');
      }
      
      final userModel = UserRegisterModel.fromJson(result);
      print('📥 [AuthApi] userRegister() Parsed Response:');
      print('   - Code: ${userModel.code}');
      print('   - Success: ${userModel.sucess}');
      print('   - Message: ${userModel.message}');
      print('   - UserId: ${userModel.data?.userId}');
      
      print('✅ [AuthApi] userRegister() success');
      return userModel;
    } catch (e) {
      print('❌ [AuthApi] userRegister() error: $e');
      throw e;
    }
  }

  Future<UserRegisterModel> editUser(
      String userId,
      String firstName,
      String email,
      String password,
      String location,
      String deviceToken,
      String dob,
      String gender,
      String phoneNo,
      String image,
      {bool profileCompleted = false}) async {
    try {
      print('✏️ [AuthApi] editUser() called - Step 2: Complete User Profile');
      print('✏️ [AuthApi] UserId: $userId, ProfileCompleted: $profileCompleted');
      final requestData = {
        "user_id": userId,
        "name": firstName,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "date_of_birth": dob,
        "gender": gender,
        "phone": phoneNo,
        "image": image,
        "profile_completed": profileCompleted
      };
      final result = await _dioClient.post(Endpoints.editUser, data: requestData);
      print('✅ [AuthApi] editUser() success - ProfileCompleted: $profileCompleted');
      final userModel = UserRegisterModel.fromJson(result);
      print('✅ [AuthApi] editUser() response - Success: ${userModel.sucess}, Message: ${userModel.message}');
      return userModel;
    } catch (e) {
      print('❌ [AuthApi] editUser() error: $e');
      throw e;
    }
  }

  Future<BloodBankRegisterModel> editBloodBank(
    String userId,
    String firstName,
    String email,
    String password,
    String location,
    String deviceToken,
    String phoneNo,
    String placeID,
    String lat,
    String lng,
    String image, {
    bool profileCompleted = false,
  }) async {
    try {
      print('🩸 [AuthApi] editBloodBank() called - Step 2: Complete Blood Bank Profile');
      print('🩸 [AuthApi] UserId: $userId, ProfileCompleted: $profileCompleted');
      final requestData = {
        "user_id": userId,
        "name": firstName,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "phone": phoneNo,
        "place_id": placeID,
        "lat": lat,
        "lng": lng,
        "image": image,
        "profile_completed": profileCompleted
      };
      final result = await _dioClient.post(Endpoints.editBloodBank, data: requestData);
      print('✅ [AuthApi] editBloodBank() success - ProfileCompleted: $profileCompleted');
      final bloodBankModel = BloodBankRegisterModel.fromJson(result);
      print('✅ [AuthApi] editBloodBank() response - Success: ${bloodBankModel.sucess}');
      return bloodBankModel;
    } catch (e) {
      print('❌ [AuthApi] editBloodBank() error: $e');
      throw e;
    }
  }

  Future<PharmacyRegisterModel> editPharmacy(
      String userId,
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String lat,
      String long,
      String placeId,
      String image, {
      bool profileCompleted = false,
      }) async {
    try {
      print('💊 [AuthApi] editPharmacy() called - Step 2: Complete Pharmacy Profile');
      print('💊 [AuthApi] UserId: $userId, ProfileCompleted: $profileCompleted');
      final requestData = {
        "user_id": userId,
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "image": image,
        "profile_completed": profileCompleted
      };
      final result = await _dioClient.post(Endpoints.editPharmacy, data: requestData);
      print('✅ [AuthApi] editPharmacy() success - ProfileCompleted: $profileCompleted');
      final pharmacyModel = PharmacyRegisterModel.fromJson(result);
      print('✅ [AuthApi] editPharmacy() response - Success: ${pharmacyModel.sucess}');
      return pharmacyModel;
    } catch (e) {
      print('❌ [AuthApi] editPharmacy() error: $e');
      throw e;
    }
  }

  Future<HospitalRegisterModel> editHospital(
      String userId,
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String lat,
      String long,
      String placeId,
      String instituteType,
      String about,
      String checkupFee,
      String image, {
      bool profileCompleted = false,
      }) async {
    try {
      print('🏥 [AuthApi] editHospital() called - Step 2: Complete Hospital Profile');
      print('🏥 [AuthApi] UserId: $userId, ProfileCompleted: $profileCompleted');
      final requestData = {
        "user_id": userId,
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "checkup_fee": checkupFee,
        "about": about,
        "institute": instituteType,
        "image": image,
        "profile_completed": profileCompleted
      };
      final result = await _dioClient.post(Endpoints.editHospital, data: requestData);
      print('✅ [AuthApi] editHospital() success - ProfileCompleted: $profileCompleted');
      final hospitalModel = HospitalRegisterModel.fromJson(result);
      print('✅ [AuthApi] editHospital() response - Success: ${hospitalModel.sucess}');
      return hospitalModel;
    } catch (e) {
      print('❌ [AuthApi] editHospital() error: $e');
      throw e;
    }
  }

  Future<DoctorRegisterModel> doctorRegister(
      String firstName,
      String email,
      String password,
      String location,
      String deviceToken,
      String gender,
      String phoneNo,
      String authType,
      String userRole,
      String expertise,
      String consultationFees,
      String qualification,
      String documentUrl,
      String image,
      String about) async {
    try {
      print('👨‍⚕️ [AuthApi] doctorRegister() called - Single-step DOCTOR signup');
      final requestData = {
        "name": firstName,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "gender": gender,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "expertise": expertise,
        "consultation_fee": consultationFees,
        "qualifications": qualification,
        "document": documentUrl,
        "image": image,
        "about_me": about
      };
      print('📤 [AuthApi] doctorRegister() Request Payload:');
      print('   - name: $firstName');
      print('   - email: $email');
      print('   - password: ${password.isNotEmpty ? "***" : "empty"}');
      print('   - location: $location');
      print('   - device_token: $deviceToken');
      print('   - gender: $gender');
      print('   - user_role: $userRole');
      print('   - auth_type: $authType');
      print('   - phone: $phoneNo');
      print('   - expertise: $expertise');
      print('   - consultation_fee: $consultationFees');
      print('   - qualifications: $qualification');
      print('   - document: $documentUrl');
      print('   - image: $image');
      print('   - about_me: $about');
      print('📤 [AuthApi] doctorRegister() Full Payload JSON: $requestData');
      
      final result = await _dioClient.post(Endpoints.doctorSignUpApi, data: requestData);
      
      print('📥 [AuthApi] doctorRegister() Raw Response: $result');
      
      // Check for errors in raw response first
      bool isSuccess = result['success'] ?? result['sucess'] ?? false;
      int? responseCode = result['code'];
      String? errorMessage = result['message'];
      
      if (isSuccess == false || responseCode != 200) {
        print('❌ [AuthApi] doctorRegister() Error Response Detected:');
        print('   - Code: $responseCode');
        print('   - Success: $isSuccess');
        print('   - Message: $errorMessage');
        throw Exception(errorMessage ?? 'Doctor registration failed');
      }
      
      final doctorModel = DoctorRegisterModel.fromJson(result);
      print('📥 [AuthApi] doctorRegister() Parsed Response:');
      print('   - UserId: ${doctorModel.data?.userId}');
      print('   - Success: ${doctorModel.sucess}');
      print('   - Message: ${doctorModel.message}');
      print('✅ [AuthApi] doctorRegister() success');
      return doctorModel;
    } catch (e) {
      print('❌ [AuthApi] doctorRegister() error: $e');
      throw e;
    }
  }

  Future AddDoctorAvailability(
    String userId,
    List<String> monday,
    List<String> tuesday,
    List<String> wednesday,
    List<String> thursday,
    List<String> friday,
    List<String> saturday,
    List<String> sunday,
  ) async {
    try {
      print('📅 [AuthApi] AddDoctorAvailability() called');
      print('📅 [AuthApi] UserId: $userId');
      final requestData = {
        "availability": [
          {"day": "Monday", "times": monday},
          {"day": "Tuesday", "times": tuesday},
          {"day": "Wednesday", "times": wednesday},
          {"day": "Thursday", "times": thursday},
          {"day": "Friday", "times": friday},
          {"day": "Saturday", "times": saturday},
          {"day": "Sunday", "times": sunday}
        ],
        "user_id": userId
      };
      final result =
          await _dioClient.post(Endpoints.addDoctorAvailability, data: requestData);
      print('✅ [AuthApi] AddDoctorAvailability() success');
      print('✅ [AuthApi] AddDoctorAvailability() response: $result');
      return result;
    } catch (e) {
      print('❌ [AuthApi] AddDoctorAvailability() error: $e');
      throw e;
    } finally {}
  }

  Future<BloodBankRegisterModel> bloodBankRegister(
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String authType,
      String userRole,
      String lat,
      String long,
      String placeId,
      String image) async {
    try {
      print('🩸 [AuthApi] bloodBankRegister() called - Single-step BLOODBANK signup');
      final requestData = {
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "image": image
      };
      print('📤 [AuthApi] bloodBankRegister() Request Payload:');
      print('   - name: $name');
      print('   - email: $email');
      print('   - password: ${password.isNotEmpty ? "***" : "empty"}');
      print('   - location: $location');
      print('   - device_token: $deviceToken');
      print('   - user_role: $userRole');
      print('   - auth_type: $authType');
      print('   - phone: $phoneNo');
      print('   - place_id: $placeId');
      print('   - lat: $lat');
      print('   - lng: $long');
      print('   - image: $image');
      print('📤 [AuthApi] bloodBankRegister() Full Payload JSON: $requestData');
      
      final result = await _dioClient.post(Endpoints.bloodBankSignUpApi, data: requestData);
      
      print('📥 [AuthApi] bloodBankRegister() Raw Response: $result');
      
      // Check for errors in raw response first
      bool isSuccess = result['success'] ?? result['sucess'] ?? false;
      int? responseCode = result['code'];
      String? errorMessage = result['message'];
      
      if (isSuccess == false || responseCode != 200) {
        print('❌ [AuthApi] bloodBankRegister() Error Response Detected:');
        print('   - Code: $responseCode');
        print('   - Success: $isSuccess');
        print('   - Message: $errorMessage');
        throw Exception(errorMessage ?? 'Blood bank registration failed');
      }
      
      final bloodBankModel = BloodBankRegisterModel.fromJson(result);
      print('📥 [AuthApi] bloodBankRegister() Parsed Response:');
      print('   - UserId: ${bloodBankModel.data?.userId}');
      print('   - Success: ${bloodBankModel.sucess}');
      print('   - Message: ${bloodBankModel.message}');
      print('✅ [AuthApi] bloodBankRegister() success');
      return bloodBankModel;
    } catch (e) {
      print('❌ [AuthApi] bloodBankRegister() error: $e');
      throw e;
    }
  }

  Future<PharmacyRegisterModel> PharmacyRegister(
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String authType,
      String userRole,
      String lat,
      String long,
      String placeId,
      String image) async {
    try {
      print('💊 [AuthApi] PharmacyRegister() called - Single-step PHARMACY signup');
      final requestData = {
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "image": image
      };
      print('📤 [AuthApi] PharmacyRegister() Request Payload:');
      print('   - name: $name');
      print('   - email: $email');
      print('   - password: ${password.isNotEmpty ? "***" : "empty"}');
      print('   - location: $location');
      print('   - device_token: $deviceToken');
      print('   - user_role: $userRole');
      print('   - auth_type: $authType');
      print('   - phone: $phoneNo');
      print('   - place_id: $placeId');
      print('   - lat: $lat');
      print('   - lng: $long');
      print('   - image: $image');
      print('📤 [AuthApi] PharmacyRegister() Full Payload JSON: $requestData');
      
      final result = await _dioClient.post(Endpoints.pharmacySignUpApi, data: requestData);
      
      print('📥 [AuthApi] PharmacyRegister() Raw Response: $result');
      
      // Check for errors in raw response first
      bool isSuccess = result['success'] ?? result['sucess'] ?? false;
      int? responseCode = result['code'];
      String? errorMessage = result['message'];
      
      if (isSuccess == false || responseCode != 200) {
        print('❌ [AuthApi] PharmacyRegister() Error Response Detected:');
        print('   - Code: $responseCode');
        print('   - Success: $isSuccess');
        print('   - Message: $errorMessage');
        throw Exception(errorMessage ?? 'Pharmacy registration failed');
      }
      
      final pharmacyModel = PharmacyRegisterModel.fromJson(result);
      print('📥 [AuthApi] PharmacyRegister() Parsed Response:');
      print('   - UserId: ${pharmacyModel.data?.userId}');
      print('   - Success: ${pharmacyModel.sucess}');
      print('   - Message: ${pharmacyModel.message}');
      print('✅ [AuthApi] PharmacyRegister() success');
      return pharmacyModel;
    } catch (e) {
      print('❌ [AuthApi] PharmacyRegister() error: $e');
      throw e;
    }
  }

  Future<HospitalRegisterModel> hospitalRegister(
      String name,
      String email,
      String password,
      String location,
      String deviceToken,
      String phoneNo,
      String authType,
      String userRole,
      String lat,
      String long,
      String placeId,
      String instituteType,
      String about,
      String checkupFee,
      String image) async {
    try {
      print('🏥 [AuthApi] hospitalRegister() called - Single-step HOSPITAL signup');
      final requestData = {
        "name": name,
        "email": email,
        "password": password,
        "location": location,
        "device_token": deviceToken,
        "user_role": userRole,
        "auth_type": authType,
        "phone": phoneNo,
        "place_id": placeId,
        "lat": lat,
        "lng": long,
        "checkup_fee": checkupFee,
        "about": about,
        "institute": instituteType,
        "image": image
      };
      print('📤 [AuthApi] hospitalRegister() Request Payload:');
      print('   - name: $name');
      print('   - email: $email');
      print('   - password: ${password.isNotEmpty ? "***" : "empty"}');
      print('   - location: $location');
      print('   - device_token: $deviceToken');
      print('   - user_role: $userRole');
      print('   - auth_type: $authType');
      print('   - phone: $phoneNo');
      print('   - place_id: $placeId');
      print('   - lat: $lat');
      print('   - lng: $long');
      print('   - checkup_fee: $checkupFee');
      print('   - about: $about');
      print('   - institute: $instituteType');
      print('   - image: $image');
      print('📤 [AuthApi] hospitalRegister() Full Payload JSON: $requestData');
      
      final result = await _dioClient.post(Endpoints.hospitalSignUpApi, data: requestData);
      
      print('📥 [AuthApi] hospitalRegister() Raw Response: $result');
      
      // Check for errors in raw response first
      bool isSuccess = result['success'] ?? result['sucess'] ?? false;
      int? responseCode = result['code'];
      String? errorMessage = result['message'];
      
      if (isSuccess == false || responseCode != 200) {
        print('❌ [AuthApi] hospitalRegister() Error Response Detected:');
        print('   - Code: $responseCode');
        print('   - Success: $isSuccess');
        print('   - Message: $errorMessage');
        throw Exception(errorMessage ?? 'Hospital registration failed');
      }
      
      final hospitalModel = HospitalRegisterModel.fromJson(result);
      print('📥 [AuthApi] hospitalRegister() Parsed Response:');
      print('   - UserId: ${hospitalModel.data?.userId}');
      print('   - Success: ${hospitalModel.sucess}');
      print('   - Message: ${hospitalModel.message}');
      print('✅ [AuthApi] hospitalRegister() success');
      return hospitalModel;
    } catch (e) {
      print('❌ [AuthApi] hospitalRegister() error: $e');
      throw e;
    }
  }
}
