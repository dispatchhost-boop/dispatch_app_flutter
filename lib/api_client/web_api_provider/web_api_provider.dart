import 'dart:io';
import 'package:dispatch/api_client/api_method.dart';
import 'package:dispatch/api_client/api_url.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/models/auth_model/check_kyc_status_model.dart';
import 'package:dispatch/models/auth_model/sign_in_model.dart';
import 'package:dispatch/models/dashboard_model/shipment_model.dart';
import 'package:dispatch/models/kyc_model/client_kyc_data_model.dart';
import 'package:dispatch/models/kyc_model/gst_verify_model.dart';
import 'package:dispatch/models/kyc_model/pan_verify_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/auth_model/sign_up_model.dart';
import '../../models/client_change_model.dart';
import '../../models/dashboard_model/client_list_model.dart';
import '../../models/dashboard_model/overview_model.dart';

var webApiProvider = Provider((ref) => WebApiProvider.getInstance());

class WebApiProvider {

  WebApiProvider._internal();

  static final WebApiProvider _instance = WebApiProvider._internal();

  static WebApiProvider getInstance() {
    return _instance;
  }

  // Create Account api
  Future<SignUpModel?> signUpAccount({required WidgetRef loaderRef, required Map<String, String> body, bool loader = true}) async {
      final response = await ApiMethods.getPost(
          url: ApiUrl.signUp,
          loaderRef: loaderRef,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
          // clientDetails: {}
      );
      DebugConfig.debugLog('SignUp Response :: $response');
      if (response != null ) {
        SignUpModel res = SignUpModel.fromJson(response.data);
        return res;
      }else{
        return null;
      }
  }

 //Sign In Account
  Future<SignInModel?> signInAccount({required WidgetRef loaderRef, required Map<String, String> body}) async {
    var response;
    // try {
       response = await ApiMethods.getPost(
          url: ApiUrl.logIn,
          loaderRef: loaderRef,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
         // clientDetails: {}
      );
      DebugConfig.debugLog('Login Response :: $response');
      if (response != null) {
        SignInModel dataModel = SignInModel.fromJson(response.data);
        return dataModel;
      }else{
        return null;
      }
  }

  Future<GstVerificationModel?> fetchGstDetails({required WidgetRef loaderRef, required Map<String, String> body}) async {
    var response;
    response = await ApiMethods.getPost(
        url: ApiUrl.gstVerify,
        loaderRef: loaderRef,
        // headers: {},
        body: body,
        // clientDetails: {}
    );
    DebugConfig.debugLog('Gst Api Response :: $response');
    if (response != null) {
      GstVerificationModel datamodel = GstVerificationModel.fromJson(response.data);
      return datamodel;
    }else{
      return null;
    }
  }

  Future<PanVerifyModel?> fetchPanDetails({required WidgetRef loaderRef, required Map<String, String> body}) async {
    var response;
    response = await ApiMethods.getPost(
      url: ApiUrl.panCard,
      loaderRef: loaderRef,
      // headers: {},
      body: body,
      // clientDetails: {}
    );
    DebugConfig.debugLog('Pan Api Response :: $response');
    if (response != null) {
      PanVerifyModel datamodel = PanVerifyModel.fromJson(response.data);
      return datamodel;
    }else{
      return null;
    }
  }

  Future<DashboardOverviewModel?> getOverviewData({required WidgetRef loaderRef, required bool loader}) async {
    // var response = {
    //   "tablesUsed": {
    //     "orders": "tbl_exp_orders",
    //     "lr": "tbl_exp_lr",
    //     "consignee": "tbl_exp_consignee_details"
    //   },
    //   "businessInsightObj": {
    //     "currentAvgOrders": 1.1111,
    //     "prevAvgOrders": 0,
    //     "currentAvgValue": 2726.814815,
    //     "prevAvgValue": 0,
    //     "orderChangePct": 0,
    //     "valueChangePct": 0
    //   },
    //   "orderSplitByPaymentMode": [
    //     {
    //       "payment_mode": "cod",
    //       "total": 2
    //     },
    //     {
    //       "payment_mode": "prepaid",
    //       "total": 28
    //     }
    //   ],
    //   "shipmentSplitByShippingMode": [
    //     {
    //       "shipping_mode": "Surface",
    //       "total": 15
    //     },
    //     {
    //       "shipping_mode": "Air",
    //       "total": 15
    //     }
    //   ],
    //   "shipmentSplitByCourier": [
    //     {
    //       "courier_name": "dtdc",
    //       "total": 17,
    //       "imageUrl": "assets/images/logos/dtdc.png"
    //     },
    //     {
    //       "courier_name": "delhivery",
    //       "total": 9,
    //       "imageUrl": "assets/images/logos/delhivery.png"
    //     },
    //     {
    //       "courier_name": "xpressbees",
    //       "total": 4,
    //       "imageUrl": "assets/images/logos/expressbees.png"
    //     }
    //   ],
    //   "orderJsonResponse": {
    //     "todayOrders": {
    //       "count": 3,
    //       "change": 0,
    //       "percentage": 0
    //     },
    //     "weekOrders": {
    //       "count": 12,
    //       "change": 1,
    //       "percentage": 9.09
    //     },
    //     "monthOrders": {
    //       "count": 30,
    //       "change": 30,
    //       "percentage": 0
    //     },
    //     "quarterOrders": {
    //       "count": 30,
    //       "change": 30,
    //       "percentage": 0
    //     }
    //   },
    //   "valueJsonResponse": {
    //     "todayValue": {
    //       "value": 3400,
    //       "change": 400,
    //       "percentage": 13.33
    //     },
    //     "weekValue": {
    //       "value": 11400,
    //       "change": -14228,
    //       "percentage": -55.52
    //     },
    //     "monthValue": {
    //       "value": 73624,
    //       "change": 73624,
    //       "percentage": 0
    //     },
    //     "quarterValue": {
    //       "value": 73624,
    //       "change": 73624,
    //       "percentage": 0
    //     }
    //   },
    //   "ShipmentSplitByWeight": [
    //     {
    //       "weight_bucket": "0-0.5kg",
    //       "total": 17
    //     },
    //     {
    //       "weight_bucket": "0.5-1kg",
    //       "total": 4
    //     },
    //     {
    //       "weight_bucket": "1-2kg",
    //       "total": 3
    //     },
    //     {
    //       "weight_bucket": "2-5kg",
    //       "total": 1
    //     },
    //     {
    //       "weight_bucket": "5-10kg",
    //       "total": 1
    //     },
    //     {
    //       "weight_bucket": "\u003E10kg",
    //       "total": 4
    //     }
    //   ],
    //   "OrderSplitAcrossTopStates": [
    //     {
    //       "state": "Maharashtra",
    //       "total_orders": 8
    //     },
    //     {
    //       "state": "Gujarat",
    //       "total_orders": 7
    //     },
    //     {
    //       "state": "Delhi",
    //       "total_orders": 5
    //     },
    //     {
    //       "state": "Uttar Pradesh",
    //       "total_orders": 3
    //     },
    //     {
    //       "state": "Rajasthan",
    //       "total_orders": 2
    //     }
    //   ],
    //   "DeliveryPerformance": [
    //     {
    //       "on_time": "5",
    //       "delay": "11",
    //       "rto": "3"
    //     }
    //   ]
    // };
    // try {
    final response = await ApiMethods.getGetApi(
        url: ApiUrl.dashboardOverView,
        loaderRef: loaderRef,
        loader: loader
      );

    DebugConfig.debugLog('OverView Response :: $response');
    if (response != null) {
      DashboardOverviewModel dataModel = DashboardOverviewModel.fromJson(response.data);
      return dataModel;
    }else{
      return null;
    }
  }

  Future<CheckKycStatusModel?> getKycStatus({required WidgetRef loaderRef}) async {
        final response = await ApiMethods.getGetApi(
                        url: ApiUrl.checkKycStatus,
                        loaderRef: loaderRef,
                        );

        DebugConfig.debugLog('Check KYC Response :: $response');
        if (response != null) {
          CheckKycStatusModel dataModel = CheckKycStatusModel.fromJson(response.data);
          return dataModel;
        }else{
          return null;
    }
  }

  Future<ClientsListModel?> getAllClientsList({required WidgetRef loaderRef}) async {
    // var response = {
    //   "tablesUsed": {
    //     "orders": "tbl_exp_orders",
    //     "lr": "tbl_exp_lr",
    //     "consignee": "tbl_exp_consignee_details"
    //   },
    //   "businessInsightObj": {
    //     "currentAvgOrders": 1.1111,
    //     "prevAvgOrders": 0,
    //     "currentAvgValue": 2726.814815,
    //     "prevAvgValue": 0,
    //     "orderChangePct": 0,
    //     "valueChangePct": 0
    //   },
    //   "orderSplitByPaymentMode": [
    //     {
    //       "payment_mode": "cod",
    //       "total": 2
    //     },
    //     {
    //       "payment_mode": "prepaid",
    //       "total": 28
    //     }
    //   ],
    //   "shipmentSplitByShippingMode": [
    //     {
    //       "shipping_mode": "Surface",
    //       "total": 15
    //     },
    //     {
    //       "shipping_mode": "Air",
    //       "total": 15
    //     }
    //   ],
    //   "shipmentSplitByCourier": [
    //     {
    //       "courier_name": "dtdc",
    //       "total": 17,
    //       "imageUrl": "assets/images/logos/dtdc.png"
    //     },
    //     {
    //       "courier_name": "delhivery",
    //       "total": 9,
    //       "imageUrl": "assets/images/logos/delhivery.png"
    //     },
    //     {
    //       "courier_name": "xpressbees",
    //       "total": 4,
    //       "imageUrl": "assets/images/logos/expressbees.png"
    //     }
    //   ],
    //   "orderJsonResponse": {
    //     "todayOrders": {
    //       "count": 3,
    //       "change": 0,
    //       "percentage": 0
    //     },
    //     "weekOrders": {
    //       "count": 12,
    //       "change": 1,
    //       "percentage": 9.09
    //     },
    //     "monthOrders": {
    //       "count": 30,
    //       "change": 30,
    //       "percentage": 0
    //     },
    //     "quarterOrders": {
    //       "count": 30,
    //       "change": 30,
    //       "percentage": 0
    //     }
    //   },
    //   "valueJsonResponse": {
    //     "todayValue": {
    //       "value": 3400,
    //       "change": 400,
    //       "percentage": 13.33
    //     },
    //     "weekValue": {
    //       "value": 11400,
    //       "change": -14228,
    //       "percentage": -55.52
    //     },
    //     "monthValue": {
    //       "value": 73624,
    //       "change": 73624,
    //       "percentage": 0
    //     },
    //     "quarterValue": {
    //       "value": 73624,
    //       "change": 73624,
    //       "percentage": 0
    //     }
    //   },
    //   "ShipmentSplitByWeight": [
    //     {
    //       "weight_bucket": "0-0.5kg",
    //       "total": 17
    //     },
    //     {
    //       "weight_bucket": "0.5-1kg",
    //       "total": 4
    //     },
    //     {
    //       "weight_bucket": "1-2kg",
    //       "total": 3
    //     },
    //     {
    //       "weight_bucket": "2-5kg",
    //       "total": 1
    //     },
    //     {
    //       "weight_bucket": "5-10kg",
    //       "total": 1
    //     },
    //     {
    //       "weight_bucket": "\u003E10kg",
    //       "total": 4
    //     }
    //   ],
    //   "OrderSplitAcrossTopStates": [
    //     {
    //       "state": "Maharashtra",
    //       "total_orders": 8
    //     },
    //     {
    //       "state": "Gujarat",
    //       "total_orders": 7
    //     },
    //     {
    //       "state": "Delhi",
    //       "total_orders": 5
    //     },
    //     {
    //       "state": "Uttar Pradesh",
    //       "total_orders": 3
    //     },
    //     {
    //       "state": "Rajasthan",
    //       "total_orders": 2
    //     }
    //   ],
    //   "DeliveryPerformance": [
    //     {
    //       "on_time": "5",
    //       "delay": "11",
    //       "rto": "3"
    //     }
    //   ]
    // };
    // try {
    final response = await ApiMethods.getGetApi(
      url: ApiUrl.clientsList,
      loaderRef: loaderRef,
      // clientDetails: UserAuthentication().getClientDetails('', '')
    );

    DebugConfig.debugLog('Clients List Response :: $response');
    if (response != null) {
      ClientsListModel dataModel = ClientsListModel.fromJson(response.data);
      return dataModel;
    }else{
      return null;
    }
  }

  Future<ShipmentDataModel?> getShipmentData({required WidgetRef loaderRef, required Map<String, String> body, required Map<String, String> clientDetails}) async{
    final response = await ApiMethods.getPost(
        url: ApiUrl.dashboardShipment,
        loaderRef: loaderRef,
        body: body,
        // clientDetails: clientDetails
    );
    DebugConfig.debugLog('Shipment Api Response :: $response');
    if (response != null) {
      ShipmentDataModel dataModel = ShipmentDataModel.fromJson(response.data);
      return dataModel;
    }else{
      return null;
    }
  }

  Future<ClientChangeModel?> clientChangeApi({required WidgetRef loaderRef, required Map<String, String> clientDetails}) async{
    final response = await ApiMethods.getPost(
        url: ApiUrl.clientChange,
        loaderRef: loaderRef,
        body: clientDetails,
      loader: false
    );
    DebugConfig.debugLog('Client Change Api Response :: $response');
    if (response != null) {
      ClientChangeModel dataModel = ClientChangeModel.fromJson(response.data);
      DebugConfig.debugLog('Client token newww  :: ${dataModel.token ?? ''}');
      return dataModel;
    }else{
      return null;
    }
  }

  Future<ClientKycDataModel?> getClientKycData({required WidgetRef loaderRef}) async {
    final response = await ApiMethods.getGetApi(
      url: ApiUrl.clientKycData,
      loaderRef: loaderRef,
      // clientDetails: UserAuthentication().getClientDetails('', '')
    );

    DebugConfig.debugLog('Clients Kyc Response :: $response');
    if (response != null) {
      ClientKycDataModel dataModel = ClientKycDataModel.fromJson(response.data);
      return dataModel;
    }else{
      return null;
    }
  }

  Future<ClientKycDataModel?> onSubmitKycDetails({required WidgetRef loaderRef, Map<String, dynamic>? fields, Map<String, File>? files}) async {
    final response = await ApiMethods.postMultipart(
      url: ApiUrl.submitKycData,
      loaderRef: loaderRef,
        fields: fields,
        files: files
    );


    DebugConfig.debugLog('Clients Kyc Response :: $response');
    if (response != null) {
      ClientKycDataModel dataModel = ClientKycDataModel.fromJson(response.data);
      return dataModel;
    }else{
      return null;
    }
  }

}