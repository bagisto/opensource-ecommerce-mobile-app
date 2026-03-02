import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Pre-warm the iOS keyboard to avoid ~1s jank on first TextField focus.
    // Creates a native UITextField, makes it first responder (triggers keyboard
    // framework loading), then immediately resigns and removes it.
    DispatchQueue.main.async {
      let warmupField = UITextField(frame: .zero)
      warmupField.autocorrectionType = .no
      self.window?.addSubview(warmupField)
      warmupField.becomeFirstResponder()
      warmupField.resignFirstResponder()
      warmupField.removeFromSuperview()
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
