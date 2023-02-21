import UIKit
import Flutter
import FirebaseCore
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    NSLog("didRegisterForRemoteNotificationsWithDeviceToken: %@", token);
    Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    Messaging.messaging().setAPNSToken(deviceToken, type: .unknown);
  } // 
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() 
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
