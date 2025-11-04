package com.digio.kyc_workflow

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import `in`.digio.sdk.gateway.DigioActivity
import `in`.digio.sdk.gateway.DigioConstants
import `in`.digio.sdk.gateway.enums.DigioEnvironment
import `in`.digio.sdk.gateway.enums.DigioErrorCode
import `in`.digio.sdk.gateway.model.DigioConfig
import `in`.digio.sdk.gateway.model.DigioTheme
import `in`.digio.sdk.gateway.enums.DigioServiceMode

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject

const val AAR_VERSION = "5.0.1"

private const val DIGIO_ACTIVITY = 7628422

/** KycWorkflowPlugin */
class KycWorkflowPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    var activityPluginBinding: ActivityPluginBinding? = null;
    var result: Result? = null
    var isReplied = false

    private val eventBroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
//            if (intent?.getStringExtra("data") != null) {
            if (intent?.getStringExtra("updateGatewayEvent") != null) {
                val jsonObject = JSONObject(
                    intent.getStringExtra(
                        "updateGatewayEvent"
                    )!!
                )
                val resultMap = JsonUtils.jsonToMap(jsonObject)
                channel.invokeMethod("gatewayEvent", resultMap)
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kyc_workflow")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        this.result = result
        if (call.method == "start") {
            val arguments = call.arguments as HashMap<*, *>
            // init digio workflow session
            val workflowConfig = DigioConfig()

            workflowConfig.environment =
                if (arguments.get("environment") != null && (arguments.get("environment") as String).equals(
                        "sandbox", true
                    )
                ) DigioEnvironment.SANDBOX else DigioEnvironment.PRODUCTION
            workflowConfig.logo =
                if (arguments.get("logo") != null) (arguments.get("logo") as String) else ""
                Log.e("mode","${arguments.get("serviceMode")}")
            if (arguments.get("serviceMode") != null) {
                when (arguments.get("serviceMode") as String) {
                    "fp" -> {
                        workflowConfig.serviceMode = DigioServiceMode.FP
                    }
                    "iris" -> {
                        workflowConfig.serviceMode = DigioServiceMode.IRIS
                    }
                    "face" -> {
                        workflowConfig.serviceMode = DigioServiceMode.FACE
                    }
                    else -> {
                        workflowConfig.serviceMode = DigioServiceMode.OTP
                    }
                }
            }

            val digioTheme = DigioTheme()
            digioTheme.primaryColorHex =
                if (arguments.get("primaryColor") != null) (arguments.get("primaryColor") as String) else ""
            digioTheme.secondaryColorHex =
                if (arguments.get("secondaryColor") != null) (arguments.get("secondaryColor") as String) else ""
            workflowConfig.theme = digioTheme
            workflowConfig.aarVersion = AAR_VERSION
//            workflowConfig.serviceMode = null
            workflowConfig.linkApproach = false
            workflowConfig.userIdentifier = arguments.get("identifier") as String
            workflowConfig.requestId = arguments.get("documentId") as String
            workflowConfig.gToken = arguments.get("tokenId") as String

            val additionalDataMap = HashMap<String, String>()

            (arguments.get("additionalData") as? Map<String, Any>)?.forEach { (key, value) ->
                additionalDataMap[key] = value.toString() // Ensure String values
            }
            workflowConfig.additionalData = additionalDataMap
            try {
                val intent = Intent(activityPluginBinding?.activity, DigioActivity::class.java)
                intent.putExtra("config", workflowConfig)
//                intent.putExtra("aar_version", AAR_VERSION)
//                intent.putExtra("navigation_graph", `in`.digio.sdk.kyc.R.navigation.workflow)
//                intent.putExtra("document_id", arguments.get("documentId") as String)
//                intent.putExtra("customer_identifier", arguments.get("identifier") as String)
//                intent.putExtra("token_id", arguments.get("tokenId") as String)
//                intent.putExtra("additional_data", "")
                isReplied = false
                activityPluginBinding?.activity?.startActivityForResult(intent, DIGIO_ACTIVITY)
            } catch (e: Exception) {
                // Throws DigioException if WorkflowResponseListener is not implemented/passed, or
                // DigioConfig is not valid (check config parameters)
                // It is mandatory to implemented/add WorkflowResponseListener
                e.printStackTrace()
            }

        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activityPluginBinding = binding
        this.activityPluginBinding?.addActivityResultListener(this)
        this.activityPluginBinding?.activity?.applicationContext?.let {
            ContextCompat.registerReceiver(
                it, eventBroadcastReceiver,
                IntentFilter(DigioConstants.GATEWAY_EVENT),
                ContextCompat.RECEIVER_NOT_EXPORTED
            )
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.activityPluginBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activityPluginBinding = binding
        this.activityPluginBinding?.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        this.activityPluginBinding = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == DIGIO_ACTIVITY) {
            val responseCode: Int = when {
                data?.hasExtra("responseCode") == true -> {
                    data.getIntExtra("responseCode", 0)
                }
                data?.hasExtra("errorCode") == true -> {
                    val errorCode = data.extras?.get("errorCode")
                    when (errorCode) {
                        is Int -> errorCode
                        is String -> errorCode.toIntOrNull() ?: resultCode
                        else -> resultCode
                    }
                }
                else -> 0
            }
            onActivityResult(responseCode, data)
            return true
        }
        return false
    }

    fun onActivityResult(resultCode: Int, data: Intent?) {
        val resultMap = hashMapOf<String, Any?>()
        resultMap.put("code", resultCode)
        if (data != null) {
            resultMap.put("message", data.getStringExtra("message"))
            resultMap.put("screen", data.getStringExtra("screen_name") ?: "starting_digio")
            resultMap.put("step", data.getStringExtra("step"))
            resultMap.put("documentId", data.getStringExtra("document_id"))
            resultMap.put("failingUrl", data.getStringExtra("failingUrl"))
            resultMap.put("errorCode", resultCode)
//            resultMap.put("errorCode", data.getIntExtra("errorCode", resultCode))
//            resultMap.put("errorCode", data.getIntExtra("error_code", resultCode))
            val stringArrayExtra = data.getStringArrayExtra("permissions")
            resultMap.put(
                "permissions",
                if (stringArrayExtra != null) stringArrayExtra.joinToString(",") else null
            )
        }
        if (resultCode == DigioConstants.RESPONSE_CODE_SUCCESS) {
            if (resultMap.get("message") == null) {
                resultMap.put("message", "KYC Success")
            }
            if (!isReplied) {
                result?.success(resultMap)
                isReplied = true
            }
//            result?.success(resultMap)
        } else if (resultCode == DigioErrorCode.DIGIO_PERMISSIONS_REQUIRED.errorCode) {
            resultMap.put("errorCode", resultCode)
            if (!isReplied) {
                result?.success(resultMap)
                isReplied = true
            }
//            result?.success(resultMap)
        } else {
            if (resultMap.get("message") == null) {
                resultMap.put("message", "KYC Failure")
            }
            resultMap.put("screen", resultMap.get("screen") ?: "starting_digio")
            resultMap.put("errorCode", resultCode)
            if (!isReplied) {
                result?.success(resultMap)
                isReplied = true
            }
//            result?.success(resultMap)
        }
    }
}
