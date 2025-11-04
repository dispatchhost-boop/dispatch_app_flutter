import 'dart:collection';

import 'package:kyc_workflow/gateway_event.dart';
import 'package:kyc_workflow/payload.dart';

import 'digio_config.dart';
import 'kyc_workflow_platform_interface.dart';
import 'workflow_response.dart';
import 'error.dart';

typedef GatewayEventListener = void Function(GatewayEvent? event);
typedef GatewayEventListenerImpl = void Function(Map<dynamic, dynamic>? map);

class KycWorkflow {
  final DigioConfig digioConfig;

  GatewayEventListener? gatewayEventListener;

  KycWorkflow(this.digioConfig);

  Future<WorkflowResponse> start(String documentId, String identifier,
      String tokenId, HashMap<String, String>? additionalData) async {
    Map<Object?, Object?>? result = await KycWorkflowPlatform.instance
        .start(documentId, identifier, tokenId, additionalData, digioConfig,
            (gatewayEventMap) {
      var gatewayEvent = GatewayEvent();
      gatewayEvent.documentId = gatewayEventMap?['documentId'] as String?;
      gatewayEvent.txnId = gatewayEventMap?['txnId'] as String?;
      gatewayEvent.entity = gatewayEventMap?['entity'] as String?;
      gatewayEvent.identifier = gatewayEventMap?['identifier'] as String?;
      gatewayEvent.event = gatewayEventMap?['event'] as String?;
      Map<Object?, Object?>? payloadMap =
          gatewayEventMap?['payload'] as Map<Object?, Object?>?;
      if (payloadMap != null) {
        var payload = Payload();
        payload.type = payloadMap['type'] as String?;
        payload.data = payloadMap['data'] as Map<Object?, Object?>?;
        var errorMap = payloadMap['error'] as Map<Object?, Object?>?;
        if (errorMap != null) {
          var error = Error();
          error.code = errorMap['code'] as String?;
          error.message = errorMap['message'] as String?;
          payload.error = error;
        }
        gatewayEvent.payload = payload;
      }
      if (this.gatewayEventListener != null) {
        this.gatewayEventListener!(gatewayEvent);
      }
    });
    print(result);
    var workflowResponse = WorkflowResponse();
    workflowResponse.documentId = result?['documentId'] as String?;
    workflowResponse.screen = result?['screen'] as String?;
    workflowResponse.message = result?['message'] as String?;
    workflowResponse.errorCode = result?['errorCode'] as int?;
    workflowResponse.code = result?['code'] as int?;
    workflowResponse.step = result?['step'] as String?;
    var _permissions = result?['permissions'] as String?;
    workflowResponse.permissions = _permissions?.split(",");
    return workflowResponse;
  }

  void setGatewayEventListener(
      GatewayEventListener gatewayFunnelEventCallback) {
    this.gatewayEventListener = gatewayFunnelEventCallback;
  }
}
