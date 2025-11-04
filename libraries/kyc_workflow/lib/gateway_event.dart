import 'package:kyc_workflow/payload.dart';

class GatewayEvent {
  String? documentId;
  String? txnId;
  String? entity;
  String? identifier;
  String? event;
  Payload? payload;

  @override
  String toString() {
    return 'GatewayEvent{documentId: $documentId, txnId: $txnId, entity: $entity, identifier: $identifier, event: $event, payload: $payload}';
  }
}
