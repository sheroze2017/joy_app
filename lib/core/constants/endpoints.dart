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

  //Pharmacy

  static String getAllPharmacy = '/pharmacy/getAllPharmacies';
  static String getPharmacyProduct = '/pharmacy/getAllProdcuts';
  static String createProduct = '/pharmacy/createProduct';
  static String getPharmacyProductDetails = '/pharmacy/getProductDetails';
  static String getAllCategories = '/pharmacy/getAllCategories';
  static String editPharmacyProduct = '/pharmacy/editProduct';
  static String getAllOrders = '/auth/getAllOrders';
  static String updateOrderStatus = '/auth/updateOrderStatus';

  //Hospial Details

  static String getAllHospitalPharmacies = '/hospital/getHospitalPharmacies';
  static String getAllHospitalDoctors = '/hospital/getHospitalDoctors';

  //Social Media
  static String getAllPosts = '/auth/getAllPosts';
  static String getAllPostById = '/auth/getPosts';
  static String uploadBase64Image = '/auth/uploadBase64';

  //Pharmacy
}
