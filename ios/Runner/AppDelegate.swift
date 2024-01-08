import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAHMKgHxLvPvRwmOaB8NHWcFwn6laFvwbM")
      if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self
              }
      application.registerForRemoteNotifications()
          Messaging.messaging().delegate = self

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
