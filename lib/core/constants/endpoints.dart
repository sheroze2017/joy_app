class Endpoints {
  static String baseUrl = 'http://194.233.69.219:3006';

  //Auth

  static String loginApi = '/auth/login';
  static String signUpApi = '/auth/signup';

  //Pharmacy

  static String getAllPharmacy = '/pharmacy/getAllPharmacies';
  static String getPharmacyProduct = '/pharmacy/getAllProdcuts';
  static String createPharmacyProduct = '/pharmacy/createProduct';
  static String getPharmacyProductDetails = '/pharmacy/getProductDetails';

  static String createProduct = '/pharmacy/createProduct';

  //Hospial Details

  static String getAllHospitalPharmacies = '/hospital/getHospitalPharmacies';
  static String getAllHospitalDoctors = '/hospital/getHospitalDoctors';

  //Social Media
  static String getAllPosts = '/auth/getAllPosts';
  static String getAllPostById = '/auth/getPosts';
}
