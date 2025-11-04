import 'dart:collection';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/prefs/share_pref.dart';
import 'package:dispatch/view_model/digio_kyc_vm/digio_home_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kyc_workflow/digio_config.dart';
import 'package:kyc_workflow/environment.dart';
import 'package:kyc_workflow/gateway_event.dart';
import 'package:kyc_workflow/kyc_workflow.dart';
import 'package:kyc_workflow/service_mode.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth_model/check_kyc_status_model.dart';
import '../../prefs/share_pref_keys.dart';
import '../../services/login_credentials/login_credentials.dart';

class DigioKycHome extends ConsumerStatefulWidget {
  const DigioKycHome({super.key});

  @override
  ConsumerState<DigioKycHome> createState() => _DigioKycHomeState();
}

class _DigioKycHomeState extends ConsumerState<DigioKycHome> {
  String _result = "Press ▶ to start";
  late DigioKycViewModel _vm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vm = DigioKycViewModel(ref);
  }

  Future<bool> _ensurePermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
    ].request();
    return statuses.values.every((e) => e.isGranted);
  }

  /// Step 1: KYC Process
  Future<void> _startKycProcess(Map<String, dynamic> data) async {
    final hasPermission = await _ensurePermissions();
    if (!hasPermission) {
      setState(() => _result = "❌ Permissions denied");
      return;
    }

    var config = DigioConfig();
    config.environment = Environment.SANDBOX;
    config.serviceMode = ServiceMode.FACE;

    final kycWorkflow = KycWorkflow(config);
    kycWorkflow.setGatewayEventListener((GatewayEvent? e) {
      debugPrint("📡 Event: ${e?.event}");
    });

    try {

      // // 👇 These should come from your backend API
      // const documentId = "KTP250926164752173CWJW1IC2QAOSU4";
      // // const documentId = "KID250926161859473SU4I8RNGOQ9ZTI";
      // const token = "CRN250926161859473J7";
      // const userIdentifier = "pulkit.tyagi@corewebconnections.com";

      final documentId = data['documentId'];
      final token = data['token'];
      final userIdentifier = data['userIdentifier'];

      final result = await kycWorkflow.start(
        documentId!,
        userIdentifier!,
        token!,
        HashMap(),
      );
      setState(() => _result = "✅ Face Liveness: $result");

      debugPrint("📡 Face Liveness Result :: $_result");
    } catch (e) {
      setState(() => _result = "⚠️ Face Liveness failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("KYC Process"), actions: [
        IconButton(
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 15),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text("Are you sure you want to log out of your account? ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      LoginCredentials().userLogout();
                      Get.offAllNamed("/login");
                    },
                    // icon: const Icon(Icons.call, color: Colors.white, size: 20),
                    label: const Text("LogOut"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout),
        ),
        SizedBox(width: 10,)
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Result: $_result", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final kycCredentials = MySharedPreferences.getMap(DIGIO_KYC_CREDENTIALS);
                if(kycCredentials.isNotEmpty){
                  DebugConfig.debugLog('Kyc Credentials is not Empty');
                  await _startKycProcess(kycCredentials);
                }else{
                  DebugConfig.debugLog('Kyc Credentials is Empty');
                  CheckKycStatusModel? res = await _vm.getKycStatus(loaderRef: ref);
                  DebugConfig.debugLog('KYC ka statuses111 :: $res');
                  if(res != null && res.id != null && res.id!.isNotEmpty && res.referenceId != null && res.referenceId!.isNotEmpty && res.referenceId != null && res.referenceId!.isNotEmpty){
                    DebugConfig.debugLog('KYC ka statuses :: $res');
                    Map<String, dynamic> data = {"documentId": res.accessToken?.entityId ?? '', "token": res.accessToken?.id ?? '', "userIdentifier": res.customerIdentifier ?? '', };
                    MySharedPreferences.setMap(DIGIO_KYC_CREDENTIALS, data);
                    await _startKycProcess(data);
                  }
                }
              },
              child: const Text("Start Kyc"),
            ),
          ],
        ),
      ),
    );
  }
}