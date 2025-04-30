class ApiLinks {
  static const bool isDevelopment = true;
  static const String link =
      isDevelopment ? wasteManagementUAT : wasteManagementPROD;

  static const String wasteManagementPROD =
      "https://dev-wma.yaantrac.com/api/v1/";
  static const String wasteManagementUAT = "https://371f-2401-4900-6328-70db-1d82-3272-45e6-a07d.ngrok-free.app/api/v1/";
  static const String wasteManagementSIT = "";
  static const loginApi = "${link}management/login";
  static String vehicleDetails(String status, String search) =>
      "${link}ticket/getAll?keyword=$search&pageNo=1&pageSize=20&status=$status";
  static String ticketDetails(ticketId) =>
      "${link}ticket/getTicketById?ticketId=$ticketId";
  static const inspectionPost = "${link}ticket/inspection-staff";

  ///Profile
  static const profileGet = "${link}management/get/profile";
  static const profileUpdate = "${link}management/update/profile";
  static const changePassword = "${link}management/change/password";
}
