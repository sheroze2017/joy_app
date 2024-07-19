class Endpoints {
  static String baseUrl = 'http://194.233.69.219:3006';

  //Auth

  static String loginApi = '/auth/login';
  static String userSignUpApi = '/auth/userSignup';
  static String doctorSignUpApi = '/auth/doctorSignup';
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
  //Social Media
  static String getAllPosts = '/auth/getAllPosts';
  static String getAllPostById = '/auth/getPosts';
  static String uploadBase64Image = '/auth/uploadBase64';
  static String createPost = '/auth/createPost';
  static String addComment = '/auth/addComment';

  static String getAllFriendRequest = '/user/getAllFriendRequests';
  static String getAllUser = '/user/getAllUsers';
  static String addFriend = '/user/addFriend';
  static String updateFriendRequest = '/user/updateFriendRequest';
  static String getAllFriendWithStatus = '/user/getAllFriends';
  static String getAllSearchUserDetail = '/user/getSearchedUserDetails';

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
