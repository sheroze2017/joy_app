class Endpoints {
  // static String baseUrl = 'https://joy.comsrvssoftwaresolutions.com';
  static String baseUrl = 'http://localhost:1006';

  // Chat environment config
  // Toggle this to switch chat URLs between staging (localhost) and prod
  static bool chatUseProd = false;

  // Staging (localhost) and Prod bases
  static String chatRestBaseStaging = 'http://localhost:1006';
  static String chatSocketBaseStaging = 'http://localhost:1006';
  static String chatRestBaseProd = 'https://joy.comsrvssoftwaresolutions.com';
  static String chatSocketBaseProd = 'https://joy.comsrvssoftwaresolutions.com';

  // Active chat bases
  static String get chatRestBase => chatUseProd ? chatRestBaseProd : chatRestBaseStaging;
  static String get chatSocketBase => chatUseProd ? chatSocketBaseProd : chatSocketBaseStaging;

  // Chat REST paths (prefix /chat)
  static String chatEnsureConversation = '/chat/ensureConversation';
  static String chatMyConversations = '/chat/myConversations';
  static String chatMessages = '/chat/messages';
  static String chatSend = '/chat/send';
  static String chatMarkRead = '/chat/markRead';
  //Auth

  static String loginApi = '/auth/login';
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

  //Social Media
  static String getAllPosts = '/auth/getAllPosts';
  static String getAllPostById = '/auth/getPosts';
  static String uploadBase64Image = '/auth/uploadBase64'; // Legacy, kept for backward compatibility
  static String uploadImage = '/auth/uploadImage'; // New form-data upload endpoint
  static String createPost = '/auth/createPost';
  static String addComment = '/auth/addComment';
  static String togglePostLike = '/auth/togglePostLike';

  static String getAllFriendRequest = '/user/getAllFriendRequests';
  static String getAllUser = '/user/getAllUsers';
  static String addFriend = '/user/addFriend';
  static String updateFriendRequest = '/user/updateFriendRequest';
  static String getAllFriendWithStatus = '/user/getAllFriends';
  static String getAllSearchUserDetail = '/user/getSearchedUserDetails';

  static String createConversation = '/conversations';

  //Doctor

  static String getAllAppointment = '/doctor/getDoctorAppoinntments';
  static String getAllDoctors = '/doctor/getAllDoctors';
  static String getDoctorDetail = '/doctor/getDoctorDetails';
  static String updateDoctor = '/doctor/updateDoctor';
  static String updateAppointmentStatus = '/auth/updateAppointmentStatus';
  static String createAppointment = '/doctor/appointment';
  static String giveReview = '/doctor/giveReview';
  static String giveAppointmentMedication = '/doctor/appointmentMedications';
  static String getAllUserAppointment = '/auth/getUserAppointments';
  static String giveMedication = '/doctor/appointmentMedications';

  // BLOOD BANK

  static String getBloodBankDetails = '/bloodbank/getBloodBankDetails';
  static String getAllDonors = '/bloodbank/getAllDonors';
  static String getAllBloodRequest = '/bloodbank/getAllBloodRequests';
  static String createBloodDonor = '/bloodbank/createDonor';
  static String createBloodAppeal = '/bloodbank/createBloodRequest';
  static String editBloodBank = '/bloodbank/editBloodBank';
  static String getAllBloodBanks = '/bloodbank/getAllBloodBanks';
}
