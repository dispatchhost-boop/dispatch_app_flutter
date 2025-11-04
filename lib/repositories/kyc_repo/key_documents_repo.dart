
import 'dart:io';
import 'package:dispatch/api_client/web_api_provider/web_api_provider.dart';
import 'package:dispatch/models/kyc_model/gst_verify_model.dart';
import 'package:dispatch/models/kyc_model/pan_verify_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var kycDataRepo = Provider((ref)=> KycDocumentsRepo(ref.read(webApiProvider)));

class KycDocumentsRepo{
  late final WebApiProvider _ref;
  KycDocumentsRepo(this._ref);

  Future<GstVerificationModel?> fetchGstDetails({required WidgetRef loaderRef, required Map<String, String> body})async{
    final res = await _ref.fetchGstDetails(body: body, loaderRef: loaderRef);
    return res;
  }

  Future<PanVerifyModel?> fetchPanDetails({required WidgetRef loaderRef, required Map<String, String> body})async{
    final res = await _ref.fetchPanDetails(body: body, loaderRef: loaderRef);
    return res;
  }

  Future<dynamic> uploadKycDetails({required WidgetRef loaderRef, Map<String, dynamic>? fields, Map<String, File>? files})async{
    final res = await _ref.onSubmitKycDetails(loaderRef: loaderRef, files: files, fields: fields);
    return res;
  }

}