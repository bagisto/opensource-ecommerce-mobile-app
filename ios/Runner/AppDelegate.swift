import UIKit
import Flutter
import GoogleMaps
import Firebase
import QuickLook
import PayPalCheckout

@main
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
    var accessToken: String = ""
    var orderId: String = ""
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
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
          else if call.method == "imageSearch"{
               let vc = MLKitViewController(nibName: "MLKitViewController", bundle: nil)
                   vc.detectorType =  .image
               vc.modalPresentationStyle = .overFullScreen
               vc.suggestedData = { data in
                   result(data)
               }
               controller.present(vc, animated: true, completion: nil)
               }
               else if call.method == "textSearch"{
                 let vc = MLKitViewController(nibName: "MLKitViewController", bundle: nil)
                     vc.detectorType = .text
                 vc.modalPresentationStyle = .overFullScreen
                 vc.suggestedData = { data in
                     result(data)
                 }
                 controller.present(vc, animated: true, completion: nil)
                 }
            else if call.method == "paypalPay" {
              guard let args = call.arguments as? [String: Any] else { return }

              let clientId = args["clientId"] as? String ?? ""
              let secretKey = args["secretKey"] as? String ?? ""
              let sandbox = args["sandboxMode"] as? Bool ?? true
              
              self.createAccessToken(clientId: clientId, secretKey: secretKey, sandbox: sandbox, args: args)
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
    
    func createAccessToken(clientId: String, secretKey: String, sandbox: Bool, args: [String: Any]) {
      let url = URL(string: sandbox ?
                    "https://api-m.sandbox.paypal.com/v1/oauth2/token" :
                    "https://api-m.paypal.com/v1/oauth2/token")!
        
        
      var request = URLRequest(url: url)
      let auth = "\(clientId):\(secretKey)"
      let authData = auth.data(using: .utf8)!
      let encoded = authData.base64EncodedString()
        
      request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
      request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      request.httpMethod = "POST"
      request.httpBody = "grant_type=client_credentials".data(using: .utf8)

      URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let token = json["access_token"] as? String else {
          return
        }
          
        self?.accessToken = token
        self?.createOrder(args: args, sandbox: sandbox)
      }.resume()
    }
    
    func createOrder(args: [String: Any], sandbox: Bool) {
        
        guard
            let transactions = args["transactions"] as? [[String: Any]],
            let firstTransaction = transactions.first,
            let amount = firstTransaction["amount"] as? [String: Any],
            let currency = amount["currency"] as? String ?? amount["currency_code"] as? String,
            let total = (amount["total"] as? String) ?? (amount["total"] as? Double)?.description
        else {
            return
        }
        
      let uniqueId = UUID().uuidString

      let order: [String: Any] = [
        "intent": "CAPTURE",
        "purchase_units": [[
          "reference_id": uniqueId,
          "amount": [
            "currency_code": currency,
            "value": total
          ]
        ]],
        "payment_source": [
          "paypal": [
            "experience_context": [
              "payment_method_preference": "IMMEDIATE_PAYMENT_REQUIRED",
              "landing_page": "LOGIN",
              "user_action": "PAY_NOW",
              "return_url": "com.webkul.bagisto.mobikul://paypalpay?opType=payment",
              "cancel_url": "com.webkul.bagisto.mobikul://paypalpay?opType=cancel"
            ]
          ]
        ]
      ]

      let url = URL(string: sandbox ?
                    "https://api-m.sandbox.paypal.com/v2/checkout/orders" :
                    "https://api-m.paypal.com/v2/checkout/orders")!

      var request = URLRequest(url: url)
      request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue(uniqueId, forHTTPHeaderField: "PayPal-Request-Id")
      request.httpMethod = "POST"
      request.httpBody = try? JSONSerialization.data(withJSONObject: order)

      URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let orderId = json["id"] as? String else {
          return
        }

        self?.orderId = orderId
        DispatchQueue.main.async {
          self?.startCheckout(orderId: orderId)
        }
      }.resume()
    }

    
    func captureOrder(orderId: String) {
        let isSandbox = true
        let baseUrl = isSandbox ?
            "https://api-m.sandbox.paypal.com" :
            "https://api-m.paypal.com"

        guard !accessToken.isEmpty else {
            print("Missing access token")
            return
        }

        let url = URL(string: "\(baseUrl)/v2/checkout/orders/\(orderId)/capture")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{}".data(using: .utf8)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Capture failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var resultMap = json
            resultMap["orderID"] = orderId

            DispatchQueue.main.async {
                guard let controller = self?.window?.rootViewController as? FlutterViewController else {
                    print("Failed to get FlutterViewController")
                    return
                }
                
                let methodChannel = FlutterMethodChannel(
                    name: "com.webkul.bagisto_mobikul/channel",
                    binaryMessenger: controller.binaryMessenger
                )
                
                methodChannel.invokeMethod("paypalPaymentResult", arguments: resultMap)
            }
        }.resume()
    }


    
    func startCheckout(orderId: String) {
        
        let config = CheckoutConfig(
                clientID: self.accessToken
            )

            config.environment = .sandbox

            Checkout.set(config: config)

        Checkout.start(
            createOrder: { createOrderAction in
                createOrderAction.set(orderId: orderId)
            },
            onApprove: { approval in
                
                print("PayPal approved order: \(orderId)")
                    self.captureOrder(orderId: orderId)
                
            },
            onCancel: {
                print("Payment canceled")
            },
            onError: { error in
                print("PayPal error: \(error)")
            }
        )
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
