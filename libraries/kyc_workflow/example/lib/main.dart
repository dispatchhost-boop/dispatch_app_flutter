import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kyc_workflow/digio_config.dart';
import 'package:kyc_workflow/environment.dart';
import 'package:kyc_workflow/gateway_event.dart';
import 'package:kyc_workflow/kyc_workflow.dart';
import 'package:kyc_workflow/service_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _workflowResult = '';


  @override
  void initState() {
    super.initState();
    // startKycWorkflow();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> startKycWorkflow() async {
    var workflowResult;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      var digioConfig = DigioConfig();
      digioConfig.theme.primaryColor = "#32a83a";
      digioConfig.logo =
          "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png";
      digioConfig.environment = Environment.PRODUCTION;
      digioConfig.serviceMode = ServiceMode.OTP;

      final _kycWorkflowPlugin = KycWorkflow(digioConfig);
      _kycWorkflowPlugin.setGatewayEventListener((GatewayEvent? gatewayEvent) {
        print("gateway funnel event ${gatewayEvent?.event}");
      });

      HashMap<String, String> additionalData = HashMap<String, String>();
      // additionalData["dg_disable_upi_collect_flow"] = "false"; // optional for mandate

      workflowResult = await _kycWorkflowPlugin.start(
          "KID25081816223XXX47FSCIRWE1OBXEY",
          "abc@digio.in",
          "GWT2508181622364XX35XINL8MM4GH6BS",
          additionalData
      );
      print('workflowResult : ' + workflowResult.toString());
    } on PlatformException {
      workflowResult = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _workflowResult = workflowResult.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Result: $_workflowResult'),
              SizedBox(height: 10),
              // Text('Event: $_workflowEvent'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: startKycWorkflow, // Your function to call
          child: Icon(Icons.play_arrow), // or any icon you like
          tooltip: 'Start Workflow',
        ),
      ),
    );
  }
}
