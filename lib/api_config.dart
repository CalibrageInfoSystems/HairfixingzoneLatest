library APIConstants;

const String SUCCESS_MESSAGE=" You will be contacted by us very soon.";

var baseUrl = "http://182.18.157.215/SaloonApp/API/";      // Test
//var baseUrl ="http://182.18.157.215/SaloonApp_Live/API/";//live

var getBanners ="GetBanner?Id=null";

var getbranches="api/Branch/null";
var GetBranchByUserId="GetBranchByUserId/";
var GetSlotsByDateAndBranch="api/Appointment/GetSlotsByDateAndBranch/";

var getgender="api/TypeCdDmt/1";
var getdropdown="api/TypeCdDmt/3";
var postApiAppointment="api/Appointment/AddUpdateAppointment";

var getbranchesbyuserid="api/Branch/";

var ValidateUser="ValidateUser";
var ValidateUserData="ValidateUserData";
var GetAppointment="api/Appointment/GetAppointment/";

var GetHolidayListByBranchId="api/Appointment/GetHolidayListByBranchId/";

var SendFirebaseNotifications="SendFirebaseNotifications";

var imagesflierepo= 'http://182.18.157.215/SaloonApp/Saloon_Repo/'; //test
//var imagesflierepo= 'http://182.18.157.215/SaloonApp_Live/Saloon_Repo/';

var AddAgentSlotInformation="AddAgentSlotInformation";

var GetApprovedDeclinedSlots ="api/Appointment/GetApprovedDeclinedSlots";
var Getnotificatons= "api/Appointment/GetNotificationsByUserId/";