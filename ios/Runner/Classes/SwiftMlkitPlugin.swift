import Flutter
import UIKit

public class SwiftMlkitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mlkit_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftMlkitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

//  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    if(call.method == "textRecognition"){
//        let vc = MLKitViewController(nibName: "MLKitViewController", bundle: nil)
//        vc.detectorType = .text
//        vc.modalPresentationStyle = .overFullScreen
//        vc.suggestedData = { data in
//            result(data)
//        }
//        self.present(vc, animated: true, completion: nil)
//    }else  if(call.method == "objectRecognition"){
//        let vc = MLKitViewController(nibName: "MLKitViewController", bundle: nil)
//        vc.detectorType = .image
//        vc.modalPresentationStyle = .overFullScreen
//        vc.suggestedData = { data in
//            result(data)
//        }
//        self.present(vc, animated: true, completion: nil)
//    }
//    result("iOS " + UIDevice.current.systemVersion)
//  }
}
