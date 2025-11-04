import 'dart:collection';

import 'package:kyc_workflow/kyc_workflow.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'digio_config.dart';
import 'kyc_workflow_method_channel.dart';

abstract class KycWorkflowPlatform extends PlatformInterface {
  /// Constructs a KycWorkflowPlatform.
  KycWorkflowPlatform() : super(token: _token);

  static final Object _token = Object();

  static KycWorkflowPlatform _instance = MethodChannelKycWorkflow();

  /// The default instance of [KycWorkflowPlatform] to use.
  ///
  /// Defaults to [MethodChannelKycWorkflow].
  static KycWorkflowPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KycWorkflowPlatform] when
  /// they register themselves.
  static set instance(KycWorkflowPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<Object?, Object?>?> start(
      String documentId,
      String identifier,
      String tokenId,
      HashMap<String, String>? additionalData,
      DigioConfig digioConfig,
      GatewayEventListenerImpl gatewayEventListener) {
    throw UnimplementedError('start() has not been implemented.');
  }

}
