import Flutter
import UIKit
import DigiokycSDK
import DigioEsignSDK


public class SwiftKycWorkflowPlugin: NSObject, FlutterPlugin,DigioKycResponseDelegate, DigioEsignDelegate {

    var result: FlutterResult!
    var channel: FlutterMethodChannel!

    init(channel: FlutterMethodChannel!) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "kyc_workflow", binaryMessenger: registrar.messenger())
        let instance = SwiftKycWorkflowPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        print(call.arguments)
        
        let rootViewController = UIApplication.shared.windows.filter({ (w) -> Bool in
            return w.isHidden == false
        }).first?.rootViewController
        
        if(call.method.elementsEqual("start")){
            do{
                let args: [String: Any] = call.arguments as! [String : Any]
                var additionalParams: [String: String]?
                var primaryColor: String?
                var tokenId: String?
                var logo: String?
                guard let docId = args["documentId"] as? String ,
                      let environment = args["environment"] as? String,
                      let identifier = args["identifier"] as? String else{
                    return
                }
                
                if args["additionalParams"] != nil && ((args["additionalParams"] as? [String: String]) != nil){
                    additionalParams = args["additionalParams"] as? [String: String]
                }
                if args["primaryColor"] != nil && ((args["primaryColor"] as? String) != nil){
                    primaryColor = args["primaryColor"] as? String
                }
                if args["tokenId"] != nil && ((args["tokenId"] as? String) != nil){
                    tokenId = args["tokenId"] as? String
                }
                if args["logo"] != nil && ((args["logo"] as? String) != nil){
                    logo = args["logo"] as? String
                }
                // give condition for Nach and DocID
                if docId.hasPrefix("ENA") || docId.hasPrefix("DID") {
                    print("***** Starting esign *********")
                    DigioBuilder().withController(viewController: rootViewController!) // Mandatory pass your view controller here
                                    .setDelegate(delegate: self)
                                    .setLogo(logo: logo ?? "") //optional your logo link
                                    .setDocumentId(documentId: docId) // Mandatory pass Document ID
                                    .setIdentifier(identifier: identifier) // Mandatory pass identifier
                                    .setTokenId(tokenId: tokenId) // Optional: token id to bypass first factor authentication
                                    .setEnvironment(environment: environment.elementsEqual("sandbox") ? DigioEnvironment.SANDBOX : DigioEnvironment.PRODUCTION)
                                    .setServiceMode(serviceMode: DigioServiceMode.OTP) // Mandatory
                                    .setPrimaryColor(hexColor: primaryColor ?? "")
                                    .setAdditionalParams(additionalParams: additionalParams ?? [:]) // optional use for eNach/mandate only
                                    .build()
                }else {
                    print("****** Starting kyc ******")
                    try DigioKycBuilder().withController(viewController: rootViewController!)
                                        .setDocumentId(documentId: docId)
                                        .setKycResponseDelegate(delegate: self)
                                        .setIdentifier(identifier: identifier)
                                        .setEnvironment(environment: environment.elementsEqual("sandbox") ? DigioEnvironment.SANDBOX : DigioEnvironment.PRODUCTION)
                                        .setPrimaryColor(hexColor: primaryColor ?? "")
                                        .setTokenId(tokenId: tokenId ?? "")
                                        .setLogo(logo: logo ?? "")
                                        .setAdditionalParams(additionalParams: additionalParams ?? [:])
                                        .build()
                }

//                 try DigioKycBuilder().withController(viewController: rootViewController!)
//                     .setDocumentId(documentId: docId)
//                     .setKycResponseDelegate(delegate: self)
//                     .setIdentifier(identifier: identifier)
//                     .setEnvironment(environment: environment.elementsEqual("sandbox") ? DigioEnvironment.SANDBOX : DigioEnvironment.PRODUCTION)
//                     .setPrimaryColor(hexColor: primaryColor ?? "")
//                     .setTokenId(tokenId: tokenId ?? "")
//                     .setLogo(logo: logo ?? "")
//                     .setAdditionalParams(additionalParams: additionalParams ?? [:])
//                     .build()
            }catch {
                print("Exception --> \(error.localizedDescription)")
            }
        }
    }
    
    private func formateJson(response: String)->[String: Any]{
        let kycResponse = try! JSONDecoder().decode(DigioKycResponse.self, from: response.data(using: .utf8)!)
        var resultMap: [String: Any] = [:]
        resultMap["message"] = kycResponse.message
        resultMap["documentId"] = kycResponse.id
        if let code = kycResponse.code {
            resultMap["code"] = code
        }
        if let errorCode = kycResponse.errorCode{
            resultMap["errorCode"] = errorCode
        }
        if let screen = kycResponse.screen{
            resultMap["screen"] = screen
        }
        if let type = kycResponse.type {
            resultMap["type"] = type
        }
        return resultMap
    }
    
    public func onDigioKycResponseSuccess(successResponse: String) {
        print("Success \(successResponse)")
        self.result(formateJson(response: successResponse))
    }
    
    public func onDigioKycResponseFailure(failureResponse: String) {
        print("Failure \(failureResponse)")
        self.result(formateJson(response: failureResponse))
    }
    
    public func onGateWayEvent(event: String) {
        channel.invokeMethod("gatewayEvent", arguments: convertToDictionary(text: event))
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }


    /**
    * eSign SDK response
    **/

     public func onDigioResponseSuccess(response: String) {
            print("Response --> success \(response)")
            self.result(formateJson(response: response))
        }

        public func onDigioResponseFailure(response: String) {
            print("Response --> failure \(response)")
            self.result(formateJson(response: response))
        }

        public func onGatewayEvent(event: String) {
            print("Response --> event \(event)")
            channel.invokeMethod("gatewayEvent", arguments: convertToDictionary(text: event))
        }

    
}


