library APIConstants;

const String SUCCESS_MESSAGE = " You will be contacted by us very soon.";

var baseUrl = "http://182.18.157.215/SaloonApp/API/"; // Test
//var baseUrl = "http://182.18.157.215/Saloon_UAT/API/"; //UAT
//var baseUrl ="http://182.18.157.215/SaloonApp_Live/API/";//live

var getBanners = "GetBanner?Id=null";

var getbranches = "GetBranchById/null/true";
var GetBranchByUserId = "GetBranchByUserId/";
var GetSlotsByDateAndBranch = "api/Appointment/GetSlotsByDateAndBranch/";

var getgender = "api/TypeCdDmt/1";
var getdropdown = "api/TypeCdDmt/3";
var postApiAppointment = "api/Appointment/AddUpdateAppointment";

var getbranchesbyuserid = "api/Branch/";

var ValidateUser = "ValidateUser";
var ValidateUserData = "ValidateUserData";
var GetAppointment = "api/Appointment/GetAppointment";
var GetAppointmentByUserid = "api/Appointment/GetAppointmentByUserid";

var GetHolidayListByBranchId = "api/Appointment/GetHolidayListByBranchId/";

var SendFirebaseNotifications = "SendFirebaseNotifications";

var imagesflierepo = 'http://182.18.157.215/SaloonApp/Saloon_Repo/'; //test
//var imagesflierepo = 'http://182.18.157.215/Saloon_UAT/Saloon_Repo/'; //test
//var imagesflierepo= 'http://182.18.157.215/SaloonApp_Live/Saloon_Repo/';

var AddAgentSlotInformation = "AddAgentSlotInformation";

var GetApprovedDeclinedSlots = "api/Appointment/GetApprovedDeclinedSlots";
var Getnotificatons = "api/Appointment/GetNotificationsByUserId/";
var customeregisration = 'Register';
var getstatus = "api/TypeCdDmt/2";
var getPaymentMode = "api/TypeCdDmt/7";
var validateusername = 'ValidateUserName';
var validateusernameotp = 'ValidateOTP';
var getbrancheselectedcity = 'GetBranchesByCityId/';
var getcity = "GetCityById/4";
var getbanner = 'GetBanner?Id=null';
var getcontent = 'GetContent/true';
var addupdateconsulation = 'api/Consultation/AddUpdateConsultation';
var agentAppointments = 'api/Appointment/GetAppointment';
var getconsulationbranchesbyagentid = 'api/Consultation/GetConsultationsByBranchId/';
var changepassword = 'ChangePassword';
var getbranchesall = 'GetBranchById/null/true';
var updateuser = 'UpdateUser';
var resetpassword = 'ResetPassword';
var getproductsbyid = 'GetProductByStatus';
var getproducts = 'GetProduct';
var getCustomerDatabyid = 'GetCustomerData?id=';
var getholidayslist = 'api/HolidayList/GetHolidayListdetails';
var getconsulationbyranchid = 'api/Consultation/GetConsultationsByBranchId';
//var validateusernameotp = "ValidateOTP";
 var AddCustomerNotification = "AddCustomerNotification";
 var GetTechnicians = "api/Appointment/GetTechnicians";
