import UIKit
import Flutter
import GoogleMaps
import Firebase
import QuickLook

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    private var _latestLink: String?
    private var latestLink: String? {
        get {
            _latestLink
        }
        set(latestLink) {

            _latestLink = latestLink
            if _eventSink != nil {
                _eventSink?(_latestLink)
            }
        }
    }

    private var _eventSink: FlutterEventSink?
    var fileURL: URL!
    var  result: FlutterResult?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAHMKgHxLvPvRwmOaB8NHWcFwn6laFvwbM")
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
              let mlkitChannel = FlutterMethodChannel(name:"com.webkul.bagisto_mobikul/channel",
                                                        binaryMessenger: controller.binaryMessenger)
      
      mlkitChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          
          if call.method == "fileviewer"{
              if let urlString = call.arguments as? String, let url = self.showFileWithPath(urlString){
                  self.fileURL = url
                  let previewController = QLPreviewController()
                  previewController.dataSource = self
                  previewController.delegate = self
                  previewController.modalPresentationStyle = .fullScreen
                  controller.present(previewController, animated: true, completion: nil)
              }
          }
          })
      
      let chargingChannel = FlutterEventChannel(
          name: "uni_links/events",
          binaryMessenger: controller.binaryMessenger)
      chargingChannel.setStreamHandler(self)
      
      if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self
              }
      application.registerForRemoteNotifications()
          Messaging.messaging().delegate = self

      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func showFileWithPath(_ path: String) -> URL?{
        if let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
        print(documentsUrl)
        let destinationFileUrl = documentsUrl.appendingPathComponent(path)
        print(destinationFileUrl)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationFileUrl.path) {
            print("FILE AVAILABLE")
            return destinationFileUrl
        }
       }
        return nil
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       
        if userActivity.activityType == "NSUserActivityTypeBrowsingWeb" {
            print(userActivity.webpageURL as Any)
            setLatestLink(userActivity.webpageURL?.description)
        }
        return true
    }
}

extension AppDelegate: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print(#function)
        print(userActivityType)
        return true
    }
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = fileURL
        return url! as QLPreviewItem
    }

}

extension AppDelegate: FlutterStreamHandler {
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            _eventSink = events
            return nil
        }
    
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            _eventSink = nil
            return nil
        }
    func setLatestLink(_ latestLink: String?) {
        self.latestLink = latestLink
        if (_eventSink != nil) {
            _eventSink?(self.latestLink)
        }
    }
    }
