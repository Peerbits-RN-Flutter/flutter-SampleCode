class ApiEndPoints {
  ApiEndPoints._();

  //Authentication
  static const String getToken = "auth/common/getToken";
  static const String signin = "auth/company/signIn";
  static const String signup = "auth/company/signUp";
  static const String forgot_password = "auth/company/forgotPassword";
  static const String update_profile = "company/updateProfile";
  static const String logout = "auth/common/logout";
  static const String change_password = "auth/common/changePassword";
  static const String getNotifications = "common/getNotificaitons";
  static const String deleteApi = "common/me";
  static const String resendEmail = "common/resend-verification-email";
  static const String profile_details = "auth/common/profile";

  //Common
  static const String industry_type_list = "common/getIndustryTypeList";
  static const String location_list = "common/getLocationList";
  static const String work_type_list = "common/getWorkTypeList";
  static const String contract_type_list = "common/getContractTypeList";
  static const String get_cms = "common/getCMSPages";
  static const String notification_list = "common/getNotificaitons";

  //Home
  static const String home_data = "company/home";

  //Proposal
  static const String create_proposal = "company/createProposal";
  static const String proposal_list = "company/getProposals";
  static const String proposal_details = "company/getProposalDetails";

  //Candidate
  static const String candidate_list = "company/findCandidate";
  static const String candidate_details = "company/candidateDetails";
  static const String bookmark_candidate = "company/bookmarkCandidate";
  static const String like_candidate = "company/likeCandidate";


  static const String getOrders = 'user/orderlist';
  static const String getOrderDetails = 'user/\$/orderlist/';

  static String getOrdersEndPoint(String param)  {
    return "user/orderlist/${param}";
  }

}