// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;

class Endpoints {
  static String baseUrl = 'https://joy.comsrvssoftwaresolutions.com';
//   Use 127.0.0.1 instead of localhost for better compatibility with iOS Simulator and Android Emulator
//   For Android Emulator, use 10.0.2.2 instead
//   For physical devices, use your machine's IP address (e.g., 192.168.x.x)
//   static String get baseUrl {
//     if (kIsWeb) {
//       return 'http://localhost:1006';
//     } else if (Platform.isAndroid) {
//       // Android Emulator uses 10.0.2.2 to access host machine's localhost
//       //   return 'http://10.0.2.2:1006';
//       return 'http://localhost:1006';
//     } else {
//       // iOS Simulator - use 127.0.0.1 which is more reliable than localhost
//       //   return 'http://192.168.100.20:1006';
//       return 'http://localhost:1006';
//     }
//   }

  // Chat uses same baseUrl as APIs
  static String get chatRestBase => baseUrl;
  static String get chatSocketBase => baseUrl;

  // Chat REST paths (prefix /chat)
  static String chatEnsureConversation = '/chat/ensureConversation';
  static String chatMyConversations = '/chat/myConversations';
  static String chatMessages = '/chat/messages';
  static String chatSend = '/chat/send';
  static String chatMarkRead = '/chat/markRead';
  //Auth

  static String loginApi = '/auth/login';
  static String socialAuthApi = '/auth/socialAuth';
  static String userSignUpApi = '/auth/userSignup';
  static String doctorSignUpApi = '/auth/doctorSignup';
  static String addDoctorAvailability = '/doctor/updateDoctorTime';
  static String bloodBankSignUpApi = '/auth/bloodbankSignup';
  static String hospitalSignUpApi = '/auth/hospitalSignup';
  static String pharmacySignUpApi = '/auth/pharmacySignup';
  static String isValidEmail = '/auth/checkEmail';
  static String editUser = '/auth/editUser';
  static String editPharmacy = '/pharmacy/editPharmacy';
  static String editHospital = '/hospital/editHospital';

  //Pharmacy

  static String getAllPharmacy = '/pharmacy/getAllPharmacies';
  static String getUnlinkedPharmacies = '/pharmacy/getUnlinkedPharmacies';
  static String getPharmacyProduct = '/pharmacy/getAllProdcuts';
  static String createProduct = '/pharmacy/createProduct';
  static String getPharmacyProductDetails = '/pharmacy/getProductDetails';
  static String getAllCategories = '/pharmacy/getAllCategories';
  static String editPharmacyProduct = '/pharmacy/editProduct';
  static String getAllOrders = '/auth/getAllOrders';
  static String updateOrderStatus = '/auth/updateOrderStatus';
  static String placeOrder = '/auth/placeOrder';

  //Hospial Details

  static String getAllHospitalPharmacies = '/hospital/getHospitalPharmacies';
  static String getAllHospitalDoctors = '/hospital/getHospitalDoctors';
  static String getAllHospital = '/hospital/getAllHospitals';
  static String getHospitalDetail = '/hospital/getHospitalDetails';
  static String linkHospital = '/auth/linkUserToUser';
  static String linkOrDelinkHospital = '/auth/linkOrDelinkHospital';
  static String linkOrDelinkPharmacy = '/hospital/linkOrDelinkPharmacy';

  //Social Media
  static String getAllPosts = '/auth/getAllPosts';
  static String getAllPostById = '/auth/getPosts';
  static String uploadBase64Image =
      '/auth/uploadBase64'; // Legacy, kept for backward compatibility
  static String uploadImage =
      '/auth/uploadImage'; // New form-data upload endpoint
  static String createPost = '/auth/createPost';
  static String addComment = '/auth/addComment';
  static String togglePostLike = '/auth/togglePostLike';
  static String togglePostDislike = '/auth/togglePostDislike';

  static String getAllFriendRequest = '/user/getAllFriendRequests';
  static String getAllUser = '/user/getAllUsers';
  static String addFriend = '/user/addFriend';
  static String updateFriendRequest = '/user/updateFriendRequest';
  static String getAllFriendWithStatus = '/user/getAllFriends';
  static String getAllSearchUserDetail = '/user/getSearchedUserDetails';
  static String getMyProfile = '/user/getMyProfile';
  static String getProfile = '/user/getProfile';
  static String getAnotherUserProfile = '/user/getAnotherUserProfile';
  static String getFriendRequestsAndSuggestions =
      '/user/getFriendRequestsAndSuggestions';

  static String createConversation = '/conversations';

  //Doctor

  static String getAllAppointment = '/doctor/getDoctorAppointments';
  static String getAllDoctors = '/doctor/getAllDoctors';
  static String getDoctorCategoriesWithDoctors =
      '/doctor/getDoctorCategoriesWithDoctors';
  static String getDoctorDetail = '/doctor/getDoctorDetails';
  static String updateDoctor = '/doctor/updateDoctor';
  static String updateAppointmentStatus = '/auth/updateAppointmentStatus';
  static String rescheduleAppointment = '/auth/rescheduleAppointment';
  static String createAppointment = '/doctor/appointment';
  static String giveReview = '/doctor/giveReview';
  static String giveAppointmentMedication = '/doctor/appointmentMedications';
  static String getAllUserAppointment = '/auth/getUserAppointments';
  static String getUserAppointmentsByStatus =
      '/auth/getUserAppointmentsByStatus';
  static String giveMedication = '/doctor/appointmentMedications';
  static String updateDeviceToken = '/auth/updateDeviceToken';
  static String getNotifications = '/auth/getNotifications';

  // BLOOD BANK

  static String getBloodBankDetails = '/bloodbank/getBloodBankDetails';
  static String getAllDonors = '/bloodbank/getAllDonors';
  static String getAllBloodRequest = '/bloodbank/getAllBloodRequests';
  static String createBloodDonor = '/bloodbank/createDonor';
  static String createBloodAppeal = '/bloodbank/createBloodRequest';
  static String deleteBloodRequest = '/bloodbank/deleteBloodRequest';
  static String attachDonorToBloodRequest =
      '/bloodbank/attachDonorToBloodRequest';
  static String detachDonorFromBloodRequest =
      '/bloodbank/detachDonorFromBloodRequest';
  static String markBloodRequestComplete =
      '/bloodbank/markBloodRequestComplete';
  static String editBloodBank = '/bloodbank/editBloodBank';
  static String getAllBloodBanks = '/bloodbank/getAllBloodbanks';
  static String getDonorDetails = '/bloodbank/getDonorDetails';
  static String updateAbout = '/bloodbank/updateAbout';
  static String updateTimings = '/bloodbank/updateTimings';

  // Nearby Services
  static String getNearbyServicesAndBookings =
      '/user/getNearbyServicesAndBookings';
}
