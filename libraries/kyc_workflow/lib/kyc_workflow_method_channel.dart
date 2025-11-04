import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kyc_workflow/kyc_workflow.dart';
import 'service_mode.dart';

import 'digio_config.dart';
import 'environment.dart';
import 'kyc_workflow_platform_interface.dart';

/// An implementation of [KycWorkflowPlatform] that uses method channels.
class MethodChannelKycWorkflow extends KycWorkflowPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kyc_workflow');

  @override
  Future<Map<Object?, Object?>?> start(
      String documentId,
      String identifier,
      String tokenId,
      HashMap<String, String>? additionalData,
      DigioConfig digioConfig,
      GatewayEventListenerImpl callback) async {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "gatewayEvent") {
        if (call.arguments != null) {
          callback(call.arguments);
        }
      }
    });
    final result =
        await methodChannel.invokeMethod<Map<Object?, Object?>>('start', {
      "documentId": documentId,
      "identifier": identifier,
      "tokenId": tokenId,
      "additionalData": additionalData,
      "environment": digioConfig.environment == Environment.SANDBOX
          ? "sandbox"
          : "production",
      "primaryColor": digioConfig.theme.primaryColor,
      "secondaryColor": digioConfig.theme.secondaryColor,
      "logo": digioConfig.logo,
      "serviceMode": _mapServiceMode(digioConfig.serviceMode),
      // "serviceMode": digioConfig.serviceMode == ServiceMode.FP
      //         ? "fp"
      //         : (digioConfig.serviceMode == ServiceMode.IRIS ? 'iris' :(digioConfig.serviceMode == ServiceMode.FACE ? 'face' : 'otp') : (digioConfig.serviceMode == ServiceMode.AADHAR ? 'aadhar' : 'otp'))
    });
    return result;
  }

  String _mapServiceMode(ServiceMode mode) {
    switch (mode) {
      case ServiceMode.FP:
        return "fp";
      case ServiceMode.IRIS:
        return "iris";
      case ServiceMode.FACE:
        return "face";
      case ServiceMode.AADHAAR:
        return "aadhaar";
      case ServiceMode.PAN:
        return "pan";
      case ServiceMode.GST:
        return "gst";
      case ServiceMode.ALL:
        return "all";
      case ServiceMode.OTP:
        return "otp";
      default:
        throw ArgumentError("❌ Unsupported ServiceMode: $mode");
    }
  }

}
